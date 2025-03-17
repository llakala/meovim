-- `ts-comments` doesn't handle comment continuation, only
-- the binding for commenting/uncommenting something
-- you can set that up via the `comments` parameter in ftplugin
-- For gleam, I did it like this:
-- o.comments = ":////,:///,://"
-- The order does seem to matter, I had to do it longest-shortest
require("ts-comments").setup({
  lang = {
    gleam = { "// %s", "/// %s", "//// %s"}
  }
})
