# Purescript React Basic Storybook

# Requirements
This is intended to be used with the hooks version of react basic.

You need to use webpack and purs-loader in order for this to work. 

# Using it
You will need to add this to your `packages.dhall` (I don't support bower):

In `additions`:
```
 react-basic-storybook =
         { dependencies =
             [ "console"
             , "effect"
             , "psci-support"
             , "react-basic-hooks"
             ]
         , repo =
             "https://github.com/i-am-the-slime/purescript-react-basic-storybook.git"
         , version =
             "75db8aaa6ed2b3d0343246393d8ac76e94662135"
         }
```

# Example
I'll upload an example of how to use this to a different repo as soon as anybody creates an issue for it!


