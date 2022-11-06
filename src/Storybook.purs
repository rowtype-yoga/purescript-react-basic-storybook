module Storybook
  ( meta
  , story_
  , story
  , simpleStory
  , parameters
  , playFunction
  , loaderFunction
  , metaDecorator
  , module Storybook.Types
  ) where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn2, mkEffectFn1, mkEffectFn2)
import Data.Function.Uncurried (mkFn2)
import Foreign (Foreign, unsafeToForeign)
import Prim.Row (class Union)
import React.Basic (JSX)
import Record.Studio (class SameKeys)
import Storybook.TestingLibrary.Types (CanvasElement)
import Storybook.Types (LoaderFunction, Meta, MetaDecorator, MetaParameters, MetaR, PlayFunction, RequiredStoryOptions, Story, StoryContext, StoryOptions)
import Unsafe.Coerce (unsafeCoerce)

meta :: forall props attrs attrs_. Union attrs attrs_ (MetaR props) => { | attrs } -> Meta
meta = toMeta

foreign import toMeta :: forall r. { | r } -> Meta

loaderFunction :: forall a. (Foreign -> Aff { | a }) -> LoaderFunction
loaderFunction fn = toLoaderFunction
  (mkEffectFn1 $ \x -> Promise.fromAff (unsafeToForeign <$> fn x))
  where
  toLoaderFunction :: (EffectFn1 Foreign (Promise (Foreign))) -> LoaderFunction
  toLoaderFunction = unsafeCoerce

playFunction :: ({ canvasElement :: CanvasElement } -> Aff Unit) -> PlayFunction
playFunction fn = toPlayFn
  (mkEffectFn1 $ \x -> Promise.fromAff (fn x))
  where
  toPlayFn :: (EffectFn1 { canvasElement :: CanvasElement } (Promise Unit)) -> PlayFunction
  toPlayFn = unsafeCoerce

parameters :: forall r. r -> MetaParameters
parameters = unsafeCoerce

metaDecorator ∷ (JSX -> JSX) → MetaDecorator
metaDecorator fn = toMetaDecorator $ mkEffectFn2 \effJSX _args -> do
  -- [TODO] Expose args?
  -- let _ = spy "args" args
  -- yields
  --  ↓↓↓
  {-
    abortSignal : AbortSignal {aborted: false, reason: undefined, onabort: null}
    allArgs : {label: 'Gerwin, der Arsch'}
    applyLoaders : async c=> {…}
    argTypes : {label: {…}}
    args : {label: 'Gerwin, der Arsch'}
    argsByTarget : {"": {…}}
    canvasElement : div#storybook-root
    component : undefined
    componentId : "button"
    globals : {backgrounds: null, measureEnabled: false, outline: false}
    hooks : x {hookListsMap: WeakMap, mountedDecorators: Set(7), prevMountedDecorators: Set(7), currentHooks: Array(0), renderListener: ƒ, …}
    id : "button--button"
    initialArgs : {label: 'Hello'}
    kind : "Button"
    loaded : {}
    moduleExport : {name: 'Button', args: {…}, argTypes: {…}, component: ƒ, render: ƒ}
    name : "Button"
    originalStoryFn : args => story.render(component)(args)
    parameters : {framework: 'react', docs: {…}, backgrounds: {…}, fileName: './output/Story.Filter/index.js', __isArgsStory: true}
    playFunction : undefined
    story : "Button"
    subcomponents : undefined
    tags : ['story']
    title : "Button"
    unboundStoryFn : c=> {…}
    undecoratedStoryFn : c=> {…}
    viewMode : "story"
  -}
  jsx <- effJSX
  pure $ fn jsx
  where
  toMetaDecorator ∷ EffectFn2 (Effect JSX) Foreign JSX → MetaDecorator
  toMetaDecorator = unsafeCoerce

simpleStory :: forall props. props -> Story
simpleStory props = toStory { render: mkFn2 \_ ctx -> ctx.component props }

story_
  :: forall props opts opts_
   . Union (RequiredStoryOptions props {} opts) opts_ (StoryOptions props {} {} {})
  => { | RequiredStoryOptions props {} opts }
  -> Story
story_ = toStory

story
  :: forall props args argTypes params opts opts_
   . SameKeys args argTypes
  => Union (RequiredStoryOptions props { | args } opts)
       opts_
       (StoryOptions props { | args } { | argTypes } { | params })
  => { | RequiredStoryOptions props { | args } opts }
  -> Story
story = toStory

foreign import toStory :: forall a. a -> Story
