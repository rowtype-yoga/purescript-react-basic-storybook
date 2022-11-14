module Story.Form (default, form) where

import Prelude

import Button (ButtonVariant(..), mkButton)
import Control.Monad.Rec.Class (forever)
import Data.Foldable (traverse_)
import Data.String as String
import Data.Time.Duration (Seconds(..))
import Data.Time.Duration as Millis
import Data.Tuple.Nested ((/\))
import Effect.Aff (Milliseconds(..), parallel, sequential)
import Effect.Aff as Aff
import Effect.Class (liftEffect)
import Input (mkInput)
import React.Basic.DOM as R
import React.Basic.DOM.Events (capture_)
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
import Storybook (Meta, Story, meta, setPlayFunction, story)
import Storybook.Addon.Actions (action)
import Storybook.TestingLibrary (typeText, within)
import Storybook.TestingLibrary as STL

default :: Meta {}
default = meta { title: "Examples/Form", component: mkHelper }

form ∷ Story {}
form = story {} {} #
  setPlayFunction
    \{ canvasElement } -> do
      canvas <- within canvasElement
      inputElem <- canvas.findByTestId "my-input"
      String.toCodePointArray "This is a test" # traverse_ \cp -> do
        inputElem # typeText (String.fromCodePointArray [ cp ])
        Aff.delay (Millis.fromDuration (0.1 # Seconds))
      Aff.delay (Millis.fromDuration (1.0 # Seconds))
      buttonElem <- canvas.findByTestId "my-button"
      Aff.delay (Millis.fromDuration (0.2 # Seconds))
      STL.click buttonElem

mkHelper :: React.Component {}
mkHelper = do
  input <- mkInput
  button <- mkButton
  React.component "FormStory" \_ -> React.do
    text /\ onChange <- React.useState' ""
    buttonText /\ setButtonText <- React.useState' "Run!"
    loading /\ setLoading <- React.useState' false
    let disabled = loading

    let
      wait = Aff.delay (Milliseconds 66.67)
      write txt = setButtonText txt # liftEffect
      changeLoadingText = forever do
        write "🙉" *> wait
        write "🙈" *> wait
        write "🙊" *> wait
        write "🙈" *> wait

      stopLoading = setLoading false # liftEffect
    useAff loading do
      if loading then do
        sequential
          ( parallel changeLoadingText *>
              parallel (Aff.delay (Milliseconds 3000.0) *> stopLoading)
          )
      else
        setButtonText "Run!" # liftEffect

    pure $ R.form
      { onSubmit: capture_ mempty
      , children:
          [ input { text, onChange, disabled }
          , button
              { content: R.text buttonText
              , disabled
              , onClick: do
                  setLoading true
                  action "loading" text
              , buttonVariant: if loading then Regular else Primary
              }
          ]
      }
