module Storybook.Addon.Actions where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import actionImpl :: forall a. String -> EffectFn1 a Unit

action :: forall a. String -> a -> Effect Unit
action = runEffectFn1 <<< actionImpl
