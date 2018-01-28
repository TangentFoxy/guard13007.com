lapis = require "lapis"

class extends lapis.Application
  @include "githook.init"

  "/": =>
    "Welcome to Lapis #{require "lapis.version"}!"
