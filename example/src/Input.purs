module Input where

import Prelude

import Data.Foldable (traverse_)
import Effect (Effect)
import Foreign.Object as Object
import React.Basic.DOM as R
import React.Basic.DOM.Events (targetValue)
import React.Basic.Events (handler)
import React.Basic.Hooks as React

type Props = { text :: String, onChange :: String -> Effect Unit, disabled :: Boolean }

mkInput :: React.Component Props
mkInput = do
  React.component "MyInput" \{ text, onChange, disabled } -> React.do
    pure $
      R.input
        { type: "text"
        , _data: Object.singleton "testid" "my-input"
        , className: "my-input"
        , value: text
        , disabled
        , onChange: handler targetValue (traverse_ onChange)
        }
