module Story.Button (default, button, buttonSimple) where

import Prelude

import AppDecorator (appDecorator)
import Button (ButtonVariant(..), mkButton)
import Button as Button
import Data.Maybe (Maybe(..))
import Data.Time.Duration (Seconds(..))
import Data.Time.Duration as Millis
import Debug (spy)
import Effect.Aff as Aff
import React.Basic.DOM as R
import Record.Studio (mapRecord)
import Storybook (ActionArg, EnumArg(..), LogEffect(..), Meta, Story, enumArg, inferArgTypes, meta, parameters, setDescription, setPlayFunction, story)
import Storybook.Addon.Actions (action)
import Storybook.TestingLibrary (within)
import Storybook.TestingLibrary as STL
import Web.HTML (window)
import Web.HTML.Window (alert)

default :: Meta Button.Props
default = meta
  { title: "Examples/Button"
  , component: mkButton
  , decorators: [ appDecorator ]
  , tags: [ "docsPage" ]
  --   , parameters: parameters
  --       { docs:
  --           { inlineStories: true
  --           , description:
  --               { component: componentDescription
  --               , story: "merkel"
  --               }
  --           , source:
  --               { language: "purescript"
  --               , code:
  --                   """
  -- mkButtonExample :: Effect JSX
  -- mkButtonExample = do
  --   buttonView <- Button.mkButton
  --   pure $ buttonView
  --     { content: R.text "Hello"
  --     , onClick: mempty
  --     , buttonVariant: Button.Primary
  --     , disabled: false
  --     }
  -- """
  --               }
  -- }
  -- }
  }

componentDescription ∷ String
componentDescription =
  """
## This is a so-called DocsPage

You get it by supplying to your default export (`Meta`):

```js
  , tags: [ "docsPage" ]
```


Just read the code, and [create an issue](https://github.com/rowtype-yoga/purescript-react-basic-storybook/issues/new?title=Documentation+is+shit&body=I+do+not+understand+how+to) if you don't understand something
  """

button ∷ Story Button.Props
button = story args argTypes # setPlayFunction playFunction
  where

  args =
    { content: "Hello"
    , buttonVariant: enumArg { "Variant": Button.Regular }
    , disabled: false
    , onClick: LogEffect "onClick"
    }

  inferredArgTypes = inferArgTypes args

  argTypes = inferredArgTypes #
    setDescription { content: "The text in the Button" }
      >>> setDescription { buttonVariant: "The colour of the button" }
      >>>
        setDescription { disabled: "Whether the button is active or not" }

  playFunction = \{ canvasElement } -> do
    canvas <- within canvasElement
    buttonElem <- canvas.findByTestId "my-button"
    Aff.delay (Millis.fromDuration (2.0 # Seconds))
    STL.click buttonElem

buttonSimple ∷ Story Button.Props
buttonSimple = story args $ inferArgTypes args
  where
  args =
    { content: "Hello"
    , buttonVariant: EnumArg Button.Primary :: _ "Variant" _
    , disabled: false
    , onClick: LogEffect "onClick"
    }
