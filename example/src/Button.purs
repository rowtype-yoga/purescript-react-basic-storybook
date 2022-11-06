module Button where

import Prelude

import Effect (Effect)
import Foreign.Object as Object
import React.Basic (JSX)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Basic.Hooks as React

type Props =
  { content :: JSX
  , onClick :: Effect Unit
  , buttonVariant :: ButtonVariant
  , disabled :: Boolean
  }

data ButtonVariant = Primary | Regular | Danger

mkButton :: React.Component Props
mkButton = do
  React.component "MyButton" \{ content, onClick, buttonVariant, disabled } -> React.do
    pure $
      R.button
        { onClick: handler_ $ unless disabled onClick
        , style:
            if disabled then
              R.css
                { "--button-background-col": "#ccc"
                , "--button-border-col": "#ccc"
                , "--button-text-col": "#eee"
                }
            else case buttonVariant of
              Primary -> R.css
                { "--button-background-col": "#00b692"
                , "--button-border-col": "#00b692"
                , "--button-text-col": "#f0f0f3"
                }
              Danger -> R.css
                { "--button-background-col": "#dc3545"
                , "--button-border-col": "#dc2535"
                , "--button-text-col": "#f0f0f3"
                }
              Regular -> R.css
                { "--button-background-col": "#385060"
                , "--button-border-col": "#385060"
                , "--button-text-col": "#eef0f8"
                }

        , _data: Object.singleton "testid" "my-button"
        , disabled
        , children: [ content ]
        , className: "my-button"
        }
