- [x] rebuild the settings system (currently it is very easy to accidentally not save things)
- [ ] settings: remove githook.*
- [ ] set up CSS (partially done)
- [ ] check that log in, log out, and new user all respect redirect
- [ ] SECURITY: check that everything that respects redirect is SAFE (only support local redirects)
- [ ] contains TODOs: layouts/default, models/CraftTags,
- [ ] Make all JavaScript requiring functionality fallback to non-JavaScript equivalents
- [ ] review import/youtube.moon (probably need a redo, once I get a scheduler in place)
- [ ] figure out why there are Twitter keys in the settings
- [ ] I believe Tags' \__tostring should have a space in the call to `concat` ?
- [ ] log failed craft submissions that fail because of their download link
- [ ] try to better log internal errors
- [ ] Remove the requirement for an image on submissions, merge existing submission images into craft descriptions
- [ ] allow using Imgur galleries on craft submissions? (better embedding/HTML support with marked.js)
- [ ] craft should have their tags as a text item on them as well as the separate DB structure
- [ ] models/Posts has a super convoluted types system, get rid of it, replace with tags perhaps
- [ ] Make an admin panel for changing settings
- [ ] Make a scheduler
- [ ] Make a scripting system
- [ ] make an admin panel for scheduling scripts
- [ ] review static content, remove as much as possible
- [ ] make a test export script (create a reusable random subset of data for use in testing migrations)
- [ ] paginate /keys
- [ ] note that data corruption in the tags system is possible due to the lack of unique primary keys and
      Lapis' Model update system, however, I should be going over these manually in the future
- [ ] Delete indexes on githook_logs and the table itself
- [ ] Create id indexes on all tables
- [ ] Remove johns table?
- [ ] explicit length requirements are needed on all text fields!
- [ ] Start deleting old/dead sessions
- [ ] BUG "Image URL invalid" when not using an image... (probably an error in retrieving a craft's link)
