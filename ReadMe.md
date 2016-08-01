## Installation

From application root: `git submodule add https://github.com/lazuscripts/githook githook`<br>
Inside your application class: `@include "githook/githook"`

## Config

`githook = true` must be set for the hook to do anything.

Assumes you are using MoonScript and have `moonc` available. Will attempt to
compile all code after pulling, before updating the running server.
