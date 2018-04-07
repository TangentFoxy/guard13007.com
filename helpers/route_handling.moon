import respond_to, capture_errors from require "lapis.application"
import locate from require "locator"
import shallow_copy from locate "gtable"

login_before = =>
  unless @user
    @write redirect_to: @url_for "user_login", nil, redirect: @url_for(@route_name)

admin_before = =>
  login_before(@)
  unless @user.admin
    @session.info = "You do not have permission to access this page."
    @write redirect_to: @url_for "index"

require_login = (tab) ->
  respond_to shallow_copy {before: login_before}, tab

require_admin = (tab) ->
  respond_to shallow_copy {before: admin_before}, tab

print_errors = =>
  if #@errors > 1
    @session.info = "The following errors occurred:"
    for err in *@errors
      @session.info ..= " #{err}"
  else
    @session.info = "An error occurred: #{@errors[1]}"
  @write redirect_to: @url_for(@route_name)

show_errors = (tab) ->
  capture_errors shallow_copy {on_error: print_errors}, tab

{
  :require_login
  :require_admin
  :show_errors
}
