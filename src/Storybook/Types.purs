module Storybook.Types where

import Effect (Effect)
import React.Basic (JSX)

foreign import data StoryDecorator ∷ Type -> Type -> Type

type StoryContext args argTypes =
  { args :: args -- the story arguments. You can use some args in your decorators and drop them in the story implementation itself.
  , argTypes :: argTypes -- Storybook's argTypes allow you to customize and fine-tune your stories args.
  , globals :: {} -- Storybook-wide globals. In particular you can use the toolbars feature to allow you to change these values using Storybook’s UI.
  , hooks :: {} -- Storybook's API hooks (e.g., useArgs).
  , parameters :: {} -- the story's static metadata, most commonly used to control Storybook's behavior of features and addons.
  , viewMode :: String -- Storybook's current active window (e.g., canvas, docs).
  }

foreign import data MetaDecorator ∷ Type

type MetaR props =
  ( title :: String
  , decorators :: Array MetaDecorator
  , tags :: Array String
  , parameters :: MetaParameters
  , id :: String
  , includeStories :: Array String
  , excludeStories :: Array String
  , args :: Args
  , argTypes :: ArgTypes
  , play :: PlayFunction
  , component :: Effect props
  , loaders :: Array LoaderFunction
  )

foreign import data MetaComponent :: Type

foreign import data LoaderFunction :: Type

foreign import data PlayFunction :: Type

foreign import data Args :: Type

foreign import data ArgTypes :: Type

foreign import data MetaParameters :: Type

foreign import data Meta :: Type

foreign import data Story ∷ Type

type RequiredStoryOptions props args r =
  ( component :: Effect (props -> JSX)
  , render :: (props -> JSX) -> args -> JSX
  | r
  )

type StoryOptions props args argTypes params =
  RequiredStoryOptions props args
    ( args :: args
    , argTypes :: argTypes
    , name :: String
    , decorators :: Array (StoryDecorator args argTypes)
    , parameters :: params
    , play :: PlayFunction
    )

foreign import data ActionArg :: Type
