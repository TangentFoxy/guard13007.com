import Sessions from require "models"

{
  before_filter: =>
    @user = Sessions\get(@session)
}
