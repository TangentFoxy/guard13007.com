lapis = require "lapis"
http = require "lapis.nginx.http"
csrf = require "lapis.csrf"
config = require("lapis.config").get!

bcrypt = require "bcrypt"

import decode from require "cjson"
import respond_to, capture_errors, assert_error, yield_error from require "lapis.application"
import assert_valid, validate_functions from require "lapis.validate"
import trim from require "lapis.util"
import locate, autoload from require "locator"
import settings from autoload "utility"

import Users, Sessions from require "models"

validate_functions.not_equals = (...) ->
  return not validate_functions.equals(...)
validate_functions.unique_user = (input) ->
  return not Users\find name: input
validate_functions.unique_email = (input) ->
  return not Users\find email: input
validate_functions.max_repetitions = (input, max) ->
  tab = {}
  for i=1,#input
    char = input\sub i, i
    if tab[char]
      tab[char] += 1
    else
      tab[char] = 1
  for k,v in pairs tab
    if v >= settings["users.maximum-character-repetition"]
      return false
  return true

class extends lapis.Application
  @path: "/users"
  @name: "user_"

  [new: "/new"]: respond_to {
    before: =>
      unless settings["users.allow-sign-up"]
        @session.info = "Sign ups are disabled."
        return redirect_to: @params.redirect or @url_for "index"

    GET: =>
      if @user
        @session.info = "You are logged into an account already."
        return redirect_to: @params.redirect or @url_for "user_me"

      @csrf_token = csrf.generate_token(@)

      return render: locate "views.user_new"

    POST: capture_errors {
      on_error: =>
        @session.info = "The following errors occurred:"
        for err in *@errors
          @session.info ..= " #{err}"
        return redirect_to: @url_for "user_new", nil, redirect: @params.redirect

      =>
        csrf.assert_token(@)

        if settings["users.require-recaptcha"]
          body = http.simple "https://www.google.com/recaptcha/api/siteverify", {
            secret: settings["users.recaptcha-secret"]
            response: @params["g-recaptcha-response"]
          }
          unless decode(body).success
            yield_error "You failed to complete the reCAPTCHA challenge."

        assert_valid @params, {
          {"name", exists: true, "You must have a username."}
          {"name", unique_user: true, "That username is taken."}
          {"password", exists: true, "You must enter a password."}
          {"password", min_length: settings["users.minimum-password-length"], "Your password must be at least #{settings["users.minimum-password-length"]} characters long."}
          {"password", max_repetitions: settings["users.maximum-character-repetition"], "Your password must not have more than #{settings["users.maximum-character-repetition"]} repetitions of the same character."}
        }

        if settings["users.password-check-fn"]
          fn = locate settings["users.password-check-fn"]
          assert_error fn(@params.password)

        if settings["users.require-email"]
          assert_valid @params, {
            {"email", exists: true, "You must enter an email address."}
          }
          if settings["users.require-unique-email"]
            assert_valid @params, {
              {"email", unique_email: true, "That email address is already tied to another account."}
            }

        digest = bcrypt.digest @params.password, settings["users.bcrypt-digest-rounds"]

        user = assert_error Users\create {
          name: trim @params.name -- NOTE this might allow an empty username by using spaces to fool validation functions
          email: trim @params.email
          digest: digest
        }

        -- if there are no admins, they become one
        unless Users\find admin: true
          user\update admin: true

        if settings["users.admin-only-mode"] and (not user.admin)
          yield_error "Your account was created. However, this site is in admin-only mode right now, so you are not logged in."

        session = assert_error Sessions\create user_id: user.id
        @session.session_id = session.id
        @session.info = "Account created, you are logged in."
        return redirect_to: @params.redirect or @url_for "user_me"
    }
  }

  [me: "/me"]: =>
    unless @user
      @session.info = "You are not logged in."
      return redirect_to: @url_for "user_login", nil, redirect: @url_for "user_me"

    return render: locate "views.user_me"

  [edit: "/edit"]: respond_to {
    before: =>
      unless @user
        @session.info = "You are not logged in."
        return redirect_to: @url_for "user_login", nil, redirect: @url_for "user_edit"

    GET: =>
      @csrf_token = csrf.generate_token(@)
      return render: locate "views.user_edit"

    POST: capture_errors {
      on_error: =>
        @session.info = "The following errors occurred:"
        for err in *@errors
          @session.info ..= " #{err}"
        return redirect_to: @url_for "user_edit"

      =>
        csrf.assert_token(@)

        if @params.name
          unless settings["users.allow-name-change"]
            yield_error "You cannot change your username."
          assert_valid @params, {
            {"name", exists: true, "You must have a username."}
            {"name", not_equals: @user.name, "You must enter a different username to change it."}
            {"name", unique_user: true, "That username is taken."}
          }
          assert_error @user\update name: trim @params.name
          @session.info = "Username updated."
          return redirect_to: @url_for "user_edit"

        if @params.email
          unless settings["users.allow-email-change"]
            yield_error "You cannot change your email address."
          if settings["users.require-email"]
            assert_valid @params, {
              {"email", exists: true, "You must enter an email address."}
            }
            if settings["users.require-unique-email"]
              assert_valid @params, {
                {"email", unique_email: true, "That email address is already tied to another account."}
              }
          assert_error @user\update email: trim @params.email
          @session.info = "Email address updated."
          return redirect_to: @url_for "user_edit"

        if @params.password
          assert_valid @params, {
            {"password", exists: true, "You must enter a password."}
            {"password", min_length: settings["users.minimum-password-length"], "Your password must be at least #{settings["users.minimum-password-length"]} characters long."}
            {"password", max_repetitions: settings["users.maximum-character-repetition"], "Your password must not have more than #{settings["users.maximum-character-repetition"]} repetitions of the same character."}
          }
          if settings["users.password-check-fn"]
            fn = locate settings["users.password-check-fn"]
            assert_error fn(@params.password)

          unless bcrypt.verify @params.oldpassword, @user.digest
            yield_error "Incorrect password."

          assert_error @user\update digest: bcrypt.digest @params.password, settings["users.bcrypt-digest-rounds"]
          @session.info = "Password updated."
          return redirect_to: @url_for "user_edit"

        if @params.delete
          Sessions\close(@session)
          assert_error @user\delete!
          @session.info = "Account deleted."
          return redirect_to: @url_for "index"

        @csrf_token = csrf.generate_token(@)
        return render: locate "views.user_edit"
    }
  }

  [admin: "/admin"]: respond_to {
    before: =>
      unless @user
        @session.info = "You are not logged in."
        return redirect_to: @url_for "user_login", nil, redirect: @url_for "user_admin"

      unless @user.admin
        @session.info = "You are not an administrator."
        return redirect_to: @url_for "index"

    GET: =>
      @csrf_token = csrf.generate_token(@)
      @user_editing = @user
      return render: locate "views.user_admin"

    POST: capture_errors {
      on_error: =>
        @session.info = "The following errors occurred:"
        for err in *@errors
          @session.info ..= " #{err}"
        return redirect_to: @url_for "user_admin"

      =>
        csrf.assert_token(@)

        -- figure out who we're editing
        if @params.change_via_name and @params.change_via_name\len! > 0
          @user_editing = Users\find name: @params.change_via_name
        elseif @params.change_via_id
          @user_editing = Users\find id: @params.change_via_id
        else
          @user_editing = Users\find id: @params.id -- query params option
        unless @user_editing
          yield_error "No user selected. You have been automatically selected."

        -- figure out what we're editing and do it
        if @params.name
          assert_valid @params, {
            {"name", exists: true, "They must have a username."}
            {"name", not_equals: @user_editing.name, "You must enter a different username to change it."}
            {"name", unique_user: true, "That username is taken."}
          }
          assert_error @user_editing\update name: trim @params.name
          @session.info = "Username updated."
          return redirect_to: @url_for "user_admin"

        if @params.email
          if settings["users.require-email"]
            assert_valid @params, {
              {"email", exists: true, "They must have an email address."}
            }
            if settings["users.require-unique-email"]
              assert_valid @params, {
                {"email", unique_email: true, "That email address is already tied to another account."}
              }
          assert_error @user_editing\update email: trim @params.email
          @session.info = "Email address updated."
          return redirect_to: @url_for "user_admin"

        if @params.password
          assert_error @user_editing\update digest: bcrypt.digest @params.password, settings["users.bcrypt-digest-rounds"]
          @session.info = "Password updated. (Warning: Admins editing passwords are not restricted to secure passwords, as these are intended to be TEMPORARY only!)"
          -- TODO require a password edited by an admin to be changed upon login
          return redirect_to: @url_for "user_admin"

        if @params.admin ~= nil
          assert_error @user_editing\update admin: @params.admin
          if @params.admin
            @session.info = "#{@user_editing.name} is now an admin!"
          else
            @session.info = "#{@user_editing.name} is no longer an admin."
          return redirect_to: @url_for "user_admin"

        if @params.delete
          assert_error @user_editing\delete!
          @session.info = "Account deleted. You are now viewing your own account."
          @user_editing = @user

        @csrf_token = csrf.generate_token(@)
        return render: locate "views.user_admin"
    }
  }

  [list: "/list"]: =>
    unless @user
      @session.info = "You are not logged in."
      return redirect_to: @url_for "user_login", nil, redirect: @url_for "user_list"

    unless @user.admin
      @session.info = "You are not an administrator."
      return redirect_to: @url_for "index"

    @users = Users\select "WHERE true ORDER BY name ASC"
    return render: locate "views.user_list"

  [login: "/login"]: respond_to {
    before: =>
      if @user
        @session.info = "You are already logged in."
        return redirect_to: @params.redirect or @url_for "user_me"

    GET: =>
      @csrf_token = csrf.generate_token(@)
      return render: locate "views.user_login"

    POST: capture_errors {
      on_error: =>
        @session.info = "The following errors occurred:"
        for err in *@errors
          @session.info ..= " #{err}"
        return redirect_to: @url_for "user_login"

      =>
        csrf.assert_token(@)

        user = assert_error Users\find name: trim @params.name
        if settings["users.admin-only-mode"] and (not user.admin)
          yield_error "This site is in admin-only mode. You cannot log in."

        if bcrypt.verify @params.password, user.digest
          session = assert_error Sessions\create user_id: user.id
          @session.session_id = session.id
          @session.info = "Logged in."
          return redirect_to: @params.redirect or @session.redirect or @url_for "index"

        @session.info = "Invalid username or password."
        return redirect_to: @url_for "user_login", nil, redirect: @params.redirect or @session.redirect
    }
  }

  [logout: "/logout"]: =>
    @session.id = nil
    @session.redirect = nil
    Sessions\close(@session)
    return redirect_to: @params.redirect or @url_for "index"
