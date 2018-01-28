lapis = require "lapis"

class extends lapis.Application
  @include "githook"

  "/": =>
    "Welcome to Lapis #{require "lapis.version"}!"
