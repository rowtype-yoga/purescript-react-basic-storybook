{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "react-basic-storybook"
, dependencies =
  [ "effect"
  , "prelude"
  , "react-basic"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
