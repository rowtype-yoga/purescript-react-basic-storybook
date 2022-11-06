{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "react-basic-storybook"
, license = "MIT"
, repository =
    "https://github.com/rowtype-yoga/purescript-react-basic-storybook.git"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "debug"
  , "effect"
  , "foreign"
  , "foreign-object"
  , "functions"
  , "maybe"
  , "prelude"
  , "react-basic"
  , "record-studio"
  , "strings"
  , "typelevel-prelude"
  , "unsafe-coerce"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
