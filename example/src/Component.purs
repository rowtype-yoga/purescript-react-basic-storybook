module Component where

import Prelude

import Effect (Effect)
import React.Basic (JSX)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Basic.Hooks as React

type Props = { content :: JSX, onClick :: Effect Unit }

mkButton :: React.Component Props
mkButton = do
  React.component "MyButton" \{ content, onClick } -> React.do
    pure $
      R.button
        { onClick: handler_ onClick
        , children: [ content ]
        , style: R.css
            { fontSize: "clamp(1rem, 3vw, 1.5rem)"
            , appearance: "none"
            , border: "1px solid #eee"
            , borderTop: "1px solid #fff"
            , color: "#444"
            , cursor: "pointer"
            , background: "#f6f8f9"
            , padding: "8px 16px"
            , borderRadius: "9px"
            , boxShadow: "0 1px 2px rgba(0, 0, 0, 0.1)"
            }
        }
