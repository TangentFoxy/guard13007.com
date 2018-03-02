## Installation

(Note: I'm going to rewrite this to explain how to use with locator, a simple
server locator I designed for use with Lapis and these sub-applications.)

Dependencies:

- Lapis (duh)
- MoonScript
- OpenResty user needs a bash shell (ch -s /bin/bash user)

From the shell:

```bash
git subtree add --prefix githook https://github.com/lazuscripts/githook.git master --squash
```

(`--prefix` specifies where it will be saved.)

Alternately, you can add it as a remote for easier maintenance:

```bash
git remote add -f githook https://github.com/lazuscripts/githook.git
git subtree add --prefix githook githook master --squash
```

From your main application class: `@include "githook.githook"` (or wherever you put it)

### Updating

From the shell:

```bash
git subtree pull --prefix githook https://github.com/lazuscripts/githook.git master --squash
```

Or, if it is set up as remote:

```bash
git subtree pull --prefix githook githook master --squash
```

## Config

All configuration is optional. Without configuration, will attempt to update any
time it is visited.

- `githook_branch "branch"` which branch you want updating (as string)
  (to prevent updates triggering when pushing unrelated branches)
- `githook_secret "secret"` the secret string used on GitHub

Will attempt to checkout, pull, update submodules if needed, compile all code,
then run migrations, and finally update the running server without interruption.

Returns a log along with exit codes on success or failure.
