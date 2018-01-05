import Users from require "models"

is_admin = =>
  error "@ not passed!" unless @
  if @session.id
    if user = Users\find id: @session.id
      return user.admin
  return false

{
  :is_admin
}
