module Story.Filter (default, button) where

import Prelude

import AppDecorator (appDecorator)
import Component (mkButton)
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.DOM as R
import Storybook.Types (Story)
import Web.HTML (window)
import Web.HTML.Window (alert)

default ∷ Story
default = { title: "Button", decorators: [ appDecorator ] }

button :: Effect JSX
button = do
  btn <- mkButton
  pure $ btn
    { content: R.text "Click me"
    , onClick: window >>= alert "Hello"
    }
