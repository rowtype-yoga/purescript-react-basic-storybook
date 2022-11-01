{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "react-basic-storybook"
, license = "MIT"
, repository = "https://github.com/rowtype-yoga/purescript-react-basic-storybook.git"
, dependencies =
  [ "effect"
  , "prelude"
  , "react-basic"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
