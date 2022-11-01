module AppDecorator where

import Prelude

import Effect (Effect)
import React.Basic (JSX)
import React.Basic.DOM as R
import React.Basic.Hooks as React
import Storybook (decorator)
import Storybook.Types (Decorator)

appDecorator ∷ Decorator
appDecorator =
  decorator \story → mkPageContainer <@> [ story ]

mkPageContainer ∷ Effect (Array JSX → JSX)
mkPageContainer = do
  React.component "PageContainer" \children → pure $
    R.div
      { style: R.css
          { background: "radial-gradient(#e0e2e5 67%, #d0d2d5 100%)"
          , padding: "3vw"
          , display: "flex"
          , justifyContent: "center"
          , alignItems: "center"
          }
      , children
      }
