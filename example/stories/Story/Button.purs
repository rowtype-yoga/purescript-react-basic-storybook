module Story.Button (default, simple, button) where

import Prelude

import AppDecorator (appDecorator)
import Button (ButtonVariant(..), mkButton)
import Data.Time.Duration (Seconds(..))
import Data.Time.Duration as Millis
import Effect.Aff as Aff
import React.Basic.DOM as R
import Storybook (Meta, Story, meta, parameters, playFunction, story, story_)
import Storybook.Addon.Actions (action)
import Storybook.TestingLibrary (within)
import Storybook.TestingLibrary as STL
import Web.HTML (window)
import Web.HTML.Window (alert)

default :: Meta
default = meta
  { title: "Examples/Button"
  , decorators: [ appDecorator ]
  , tags: [ "docsPage" ]
  , parameters: parameters
      { docs:
          { inlineStories: true
          , description:
              { component: componentDescription
              , story: "merkel"
              }
          , source:
              { language: "purescript"
              , code:
                  """
mkButtonExample :: Effect JSX
mkButtonExample = do
  buttonView <- Button.mkButton
  pure $ buttonView
    { content: R.text "Hello"
    , onClick: mempty
    , buttonVariant: Button.Primary
    , disabled: false
    }
"""
              }
          }
      }
  , component: mkButton
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

simple ∷ Story
simple = story_
  { name: "Simple"
  , component: mkButton
  , render: \btn _ -> btn
      { content: R.text "Click me"
      , buttonVariant: Primary
      , onClick: window >>= alert "Clicked"
      , disabled: false
      }
  }

button ∷ Story
button = story
  { name: "Button"
  , component: mkButton
  , render: \btn args -> do
      btn
        { content: R.text args.label
        , disabled: false
        , onClick: (action "Oh Yeah" 4)
        , buttonVariant: case args.variant of
            "Primary" -> Primary
            "Regular" -> Regular
            "Danger" -> Danger
            _ -> Primary
        }
  , args: { label: "Hello", variant: "Primary" }
  , argTypes:
      { label: { control: "text" }
      , variant:
          { control: { type: "select" }
          , type: { name: "ButtonVariant", required: true }
          , table: { type: { summary: "ButtonVariant", detail: "Button.ButtonVariant" } }
          , description: "A colour variant"
          , options: [ "Primary", "Regular", "Danger" ]
          }
      }
  , play: playFunction \{ canvasElement } -> do
      canvas <- within canvasElement
      buttonElem <- canvas.findByTestId "my-button"
      Aff.delay (Millis.fromDuration (2.0 # Seconds))
      STL.click buttonElem
  -- , parameters: { docs: { description: "Hi"}}
  -- , parameters:
  -- { docs:
  -- {
  --   description: { component: "A nice little button" }
  -- ,
  -- source:
  --     { excludeDecorators: true
  --     , sourceType: "code"
  -- , transformSource: mkEffectFn2 \source more ->do
  --     let _ = spy "source" source
  --     let _ = spy "more" more
  --     pure source
  --               , code:
  --                   """do
  --   button <- mkButton
  --   pure $ button { onClick: Console.log "Help!", label: R.text "Click me" }
  -- """
  -- }
  -- }
  -- }
  }
