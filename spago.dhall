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
  , "arrays"
  , "colors"
  , "debug"
  , "effect"
  , "enums"
  , "foreign"
  , "foreign-object"
  , "functions"
  , "heterogeneous"
  , "lists"
  , "literals"
  , "maybe"
  , "nullable"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "record"
  , "record-studio"
  , "strings"
  , "tuples"
  , "typelevel-prelude"
  , "unsafe-coerce"
  , "untagged-union"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
