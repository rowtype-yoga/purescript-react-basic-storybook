module Storybook.TestingLibrary where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Function.Uncurried (Fn1, runFn1)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Foreign (Foreign)
import Storybook.TestingLibrary.Types (CanvasElement, RenderQueriesJS, RenderQueries)
import Unsafe.Coerce (unsafeCoerce)
import Web.HTML (HTMLElement)

foreign import typeImpl :: EffectFn2 HTMLElement String Unit

typeText :: String -> HTMLElement -> Aff Unit
typeText s elem = runEffectFn2 typeImpl elem s # liftEffect

foreign import clickImpl :: EffectFn1 HTMLElement Unit

click :: HTMLElement -> Aff Unit
click = runEffectFn1 clickImpl <#> liftEffect

foreign import withinImpl :: EffectFn1 CanvasElement RenderQueriesJS

within :: CanvasElement -> Aff RenderQueries
within x = liftRunEffectFn1 withinImpl x <#> toRenderQueries

liftRunEffectFn1 ∷ ∀ m a b. MonadEffect m => EffectFn1 a b -> a -> m b
liftRunEffectFn1 = (map >>> map) liftEffect runEffectFn1

toRenderQueries ∷ RenderQueriesJS -> RenderQueries
toRenderQueries rq =
  { findByLabelText: map unsafeCoerce runToAff1 rq.findByLabelText
  , findAllByLabelText: map unsafeCoerce runToAff1 rq.findAllByLabelText
  , findByTestId: map unsafeCoerce runToAff1 rq.findByTestId
  , findAllByTestId: map unsafeCoerce runToAff1 rq.findAllByTestId
  , findByAltText: map unsafeCoerce runToAff1 rq.findByAltText
  , findAllByAltText: map unsafeCoerce runToAff1 rq.findAllByAltText
  , findByText: map unsafeCoerce runToAff1 rq.findByText
  , findAllByText: map unsafeCoerce runToAff1 rq.findAllByText
  , findByTitle: map unsafeCoerce runToAff1 rq.findByTitle
  , findAllByTitle: map unsafeCoerce runToAff1 rq.findAllByTitle
  , findByDisplayValue: map unsafeCoerce runToAff1 rq.findByDisplayValue
  , findAllByDisplayValue: map unsafeCoerce runToAff1 rq.findAllByDisplayValue
  , findByRole: map unsafeCoerce runToAff1 rq.findByRole
  , findAllByRole: map unsafeCoerce runToAff1 rq.findAllByRole
  , findByPlaceholderText: map unsafeCoerce runToAff1 rq.findByPlaceholderText
  , findAllByPlaceholderText: map unsafeCoerce runToAff1 rq.findAllByPlaceholderText
  , queryByLabelText: map unsafeCoerce runFn1 (query rq.queryByLabelText)
  , queryAllByLabelText: map unsafeCoerce runFn1 (query rq.queryAllByLabelText)
  , queryByTestId: map unsafeCoerce runFn1 (query rq.queryByTestId)
  , queryAllByTestId: map unsafeCoerce runFn1 (query rq.queryAllByTestId)
  , queryByAltText: map unsafeCoerce runFn1 (query rq.queryByAltText)
  , queryAllByAltText: map unsafeCoerce runFn1 (query rq.queryAllByAltText)
  , queryByText: map unsafeCoerce runFn1 (query rq.queryByText)
  , queryAllByText: map unsafeCoerce runFn1 (query rq.queryAllByText)
  , queryByTitle: map unsafeCoerce runFn1 (query rq.queryByTitle)
  , queryAllByTitle: map unsafeCoerce runFn1 (query rq.queryAllByTitle)
  , queryByDisplayValue: map unsafeCoerce runFn1 (query rq.queryByDisplayValue)
  , queryAllByDisplayValue: map unsafeCoerce runFn1 (query rq.queryAllByDisplayValue)
  , queryByRole: map unsafeCoerce runFn1 (query rq.queryByRole)
  , queryAllByRole: map unsafeCoerce runFn1 (query rq.queryAllByRole)
  , queryByPlaceholderText: map unsafeCoerce runFn1 (query rq.queryByPlaceholderText)
  , queryAllByPlaceholderText: map unsafeCoerce runFn1 (query rq.queryAllByPlaceholderText)
  , rerender: liftRunEffectFn1 rq.rerender
  }

runToAff1 ∷ ∀ a b. (a -> Promise b) -> a -> Aff b
runToAff1 = map Promise.toAff <$> runFn1

foreign import queryImpl ∷ ∀ a. (∀ x. x -> Maybe x) -> (∀ x. Maybe x) -> (Fn1 Foreign a) -> Foreign -> Maybe a

query ∷ ∀ a. (Fn1 Foreign a) -> Foreign -> Maybe a
query = queryImpl Just Nothing
