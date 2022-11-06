let conf = ./spago.dhall

in    conf
    ⫽ { sources = conf.sources # [ "stories/**/*.purs" ]
      , dependencies =
            conf.dependencies
          # [ "datetime"
            , "strings"
            , "react-basic-storybook"
            , "web-html"
            , "aff"
            , "tailrec"
            , "tuples"
            ]
      }
