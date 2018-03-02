## Installation

(Note: These instructions need to be rewritten for use with the new service
 locator and utility modules I've made recently.)

1. From application root: `git submodule add https://github.com/lazuscripts/users users`

2. Inside your application: `@include "users/users"`

3. In migrations, do the following:
   ```moonscript
   import create_table, types from require "lapis.db.schema"
   create_table "users", {
       {"id", types.serial primary_key: true}
       {"name", types.varchar unique: true}
       {"digest", types.text}
       {"admin", types.boolean default: false}
   }
   ```

4. `bcrypt` Lua Rock must be installed!

5. If `@session.redirect` is defined when going to the login route, a user will be
   redirected there after logging in.

Note: Assumes you have a route named "index" to redirect to when things go
wrong.

**WARNING**: Now expects you to display informational messages stored in
`@session.info`.

## Config

`digest_rounds 9` must be set. Use a higher or lower number depending on how
long it takes to calculate a digest or how paranoid you want to be. See this bit
about tuning: https://github.com/mikejsavage/lua-bcrypt#tuning

## Access

To get the Users model for use outside of this sub-application:<br>
`Users = require "users.models.Users"`

Named routes:

- user_new
- user_me
- user_admin
- user_edit
- user_login
- user_logout
- user_list
