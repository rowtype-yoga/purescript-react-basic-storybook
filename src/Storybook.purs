module Storybook
  ( meta
  , parameters
  , setPlayFunction
  , loaderFunction
  , metaDecorator
  , story
  , module Storybook.Types
  , module Storybook.Addon.Docs.Types
  , module Storybook.Addon.Docs
  ) where

import Prelude
import Storybook.Types (ArgTypes, Args, LoaderFunction, Meta, MetaComponent, MetaDecorator, MetaParameters, MetaR, PlayFunction, RequiredStoryOptions, Story, StoryContext, StoryDecorator, StoryOptions)
import Storybook.Addon.Docs.Types (ArgType, FromStorybookArgHelper(..), StorybookArgType, argTypeToStorybook)
import Storybook.Addon.Docs (MapArgType, argsTableImpl, descriptionImpl, mapArgType, primaryImpl, primaryStoryImpl, setDescription, setName, setRequired, setType, setTypeDetail, storiesImpl, subtitleImpl, titleImpl, setControl)

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Function.Uncurried (mkFn2)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn2, mkEffectFn1, mkEffectFn2)
import Foreign (Foreign, unsafeToForeign)
import Heterogeneous.Folding (class HFoldlWithIndex)
import Heterogeneous.Mapping (class HMap, hmap)
import Prim.Row (class Union)
import Prim.RowList (class RowToList)
import React.Basic (JSX)
import Record.Builder (Builder)
import Record.Studio (MapRecord, mapRecord)
import Storybook.TestingLibrary.Types (CanvasElement)
import Type.Row.Homogeneous (class Homogeneous)
import Unsafe.Coerce (unsafeCoerce)

meta
  :: forall props attrs attrs_
   . Union attrs attrs_ (MetaR props)
  => { | attrs }
  -> Meta { | props }
meta = toMeta

foreign import toMeta :: forall r props. { | r } -> Meta props

loaderFunction :: forall a. (Foreign -> Aff { | a }) -> LoaderFunction
loaderFunction fn = toLoaderFunction
  (mkEffectFn1 $ \x -> Promise.fromAff (unsafeToForeign <$> fn x))
  where
  toLoaderFunction :: (EffectFn1 Foreign (Promise (Foreign))) -> LoaderFunction
  toLoaderFunction = unsafeCoerce

parameters :: forall r. r -> MetaParameters
parameters = unsafeCoerce

metaDecorator ∷ (JSX -> JSX) → MetaDecorator
metaDecorator fn = toMetaDecorator $ mkEffectFn2 \effJSX _args -> do
  jsx <- effJSX
  pure $ fn jsx
  where
  toMetaDecorator ∷ EffectFn2 (Effect JSX) Foreign JSX → MetaDecorator
  toMetaDecorator = unsafeCoerce

story
  :: forall props args propsRL argsRL argTypes argTypesRL storybookArgTypes
   . RowToList props propsRL
  => RowToList args argsRL
  => RowToList argTypes argTypesRL
  => HMap FromStorybookArgHelper { | args } { | props }
  => HFoldlWithIndex (MapRecord ArgType StorybookArgType) (Builder {} {}) { | argTypes } (Builder {} { | storybookArgTypes })
  --  => SameKeys args argTypes
  => Homogeneous argTypes ArgType
  => { | args }
  -> { | argTypes }
  -> Story { | props }
story args argTypes = toStory
  { render: mkFn2 \(currentArgs :: { | args }) ctx ->
      (ctx.component :: { | props } -> JSX)
        (hmap FromStorybookArgHelper currentArgs :: { | props })
  , argTypes: (mapRecord argTypeToStorybook argTypes) :: { | storybookArgTypes }
  , args
  }
  where
  toStory :: _ -> Story { | props }
  toStory = unsafeCoerce

foreign import addPlayFunctionImpl :: forall p. PlayFunction -> Story p -> Story p

setPlayFunction :: forall p. ({ canvasElement :: CanvasElement } -> Aff Unit) -> Story p -> Story p
setPlayFunction fn = addPlayFunctionImpl $ toPlayFn (mkEffectFn1 $ \x -> Promise.fromAff (fn x))
  where
  toPlayFn :: (EffectFn1 { canvasElement :: CanvasElement } (Promise Unit)) -> PlayFunction
  toPlayFn = unsafeCoerce

