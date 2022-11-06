module Storybook.TestingLibrary.Types where

import Prelude

import Control.Promise (Promise)
import Data.Function.Uncurried (Fn1)
import Data.Maybe (Maybe)
import Data.String.Regex (Regex)
import Effect.Aff (Aff)
import Effect.Class (class MonadEffect)
import Effect.Uncurried (EffectFn1)
import Foreign (Foreign)
import Prim.TypeError (class Fail, Text)
import React.Basic (JSX)
import Web.HTML (HTMLElement)

foreign import data CanvasElement :: Type

type RenderQueriesJS =
  { findByLabelText ∷ Fn1 Foreign (Promise HTMLElement)
  , findAllByLabelText ∷ Fn1 Foreign (Promise (Array HTMLElement))
  , findByTestId ∷ Fn1 Foreign (Promise HTMLElement)
  , findAllByTestId ∷ Fn1 Foreign (Promise (Array HTMLElement))
  , findByAltText ∷ Fn1 Foreign (Promise HTMLElement)
  , findAllByAltText ∷ Fn1 Foreign (Promise (Array HTMLElement))
  , findByText ∷ Fn1 Foreign (Promise HTMLElement)
  , findAllByText ∷ Fn1 Foreign (Promise (Array HTMLElement))
  , findByTitle ∷ Fn1 Foreign (Promise HTMLElement)
  , findAllByTitle ∷ Fn1 Foreign (Promise (Array HTMLElement))
  , findByDisplayValue ∷ Fn1 Foreign (Promise HTMLElement)
  , findAllByDisplayValue ∷ Fn1 Foreign (Promise (Array HTMLElement))
  , findByRole ∷ Fn1 Foreign (Promise HTMLElement)
  , findAllByRole ∷ Fn1 Foreign (Promise (Array HTMLElement))
  , findByPlaceholderText ∷ Fn1 Foreign (Promise HTMLElement)
  , findAllByPlaceholderText ∷ Fn1 Foreign (Promise (Array HTMLElement))
  , queryByLabelText ∷ Fn1 Foreign HTMLElement
  , queryAllByLabelText ∷ Fn1 Foreign (Array HTMLElement)
  , queryByTestId ∷ Fn1 Foreign HTMLElement
  , queryAllByTestId ∷ Fn1 Foreign (Array HTMLElement)
  , queryByAltText ∷ Fn1 Foreign HTMLElement
  , queryAllByAltText ∷ Fn1 Foreign (Array HTMLElement)
  , queryByText ∷ Fn1 Foreign HTMLElement
  , queryAllByText ∷ Fn1 Foreign (Array HTMLElement)
  , queryByTitle ∷ Fn1 Foreign HTMLElement
  , queryAllByTitle ∷ Fn1 Foreign (Array HTMLElement)
  , queryByDisplayValue ∷ Fn1 Foreign HTMLElement
  , queryAllByDisplayValue ∷ Fn1 Foreign (Array HTMLElement)
  , queryByRole ∷ Fn1 Foreign HTMLElement
  , queryAllByRole ∷ Fn1 Foreign (Array HTMLElement)
  , queryByPlaceholderText ∷ Fn1 Foreign HTMLElement
  , queryAllByPlaceholderText ∷ Fn1 Foreign (Array HTMLElement)
  , rerender ∷ EffectFn1 JSX Unit
  }

type RenderQueries =
  { findByLabelText ∷ ∀ tm. TextMatch tm => tm -> Aff HTMLElement
  , findAllByLabelText ∷ ∀ tm. TextMatch tm => tm -> Aff (Array HTMLElement)
  , findByTestId ∷ ∀ tm. TextMatch tm => tm -> Aff HTMLElement
  , findAllByTestId ∷ ∀ tm. TextMatch tm => tm -> Aff (Array HTMLElement)
  , findByAltText ∷ ∀ tm. TextMatch tm => tm -> Aff HTMLElement
  , findAllByAltText ∷ ∀ tm. TextMatch tm => tm -> Aff (Array HTMLElement)
  , findByText ∷ ∀ tm. TextMatch tm => tm -> Aff HTMLElement
  , findAllByText ∷ ∀ tm. TextMatch tm => tm -> Aff (Array HTMLElement)
  , findByTitle ∷ ∀ tm. TextMatch tm => tm -> Aff HTMLElement
  , findAllByTitle ∷ ∀ tm. TextMatch tm => tm -> Aff (Array HTMLElement)
  , findByDisplayValue ∷ ∀ tm. TextMatch tm => tm -> Aff HTMLElement
  , findAllByDisplayValue ∷ ∀ tm. TextMatch tm => tm -> Aff (Array HTMLElement)
  , findByRole ∷ ∀ tm. TextMatch tm => tm -> Aff HTMLElement
  , findAllByRole ∷ ∀ tm. TextMatch tm => tm -> Aff (Array HTMLElement)
  , findByPlaceholderText ∷ ∀ tm. TextMatch tm => tm -> Aff HTMLElement
  , findAllByPlaceholderText ∷ ∀ tm. TextMatch tm => tm -> Aff (Array HTMLElement)
  , queryByLabelText ∷ ∀ tm. TextMatch tm => tm -> Maybe HTMLElement
  , queryAllByLabelText ∷ ∀ tm. TextMatch tm => tm -> Maybe (Array HTMLElement)
  , queryByTestId ∷ ∀ tm. TextMatch tm => tm -> Maybe HTMLElement
  , queryAllByTestId ∷ ∀ tm. TextMatch tm => tm -> Maybe (Array HTMLElement)
  , queryByAltText ∷ ∀ tm. TextMatch tm => tm -> Maybe HTMLElement
  , queryAllByAltText ∷ ∀ tm. TextMatch tm => tm -> Maybe (Array HTMLElement)
  , queryByText ∷ ∀ tm. TextMatch tm => tm -> Maybe HTMLElement
  , queryAllByText ∷ ∀ tm. TextMatch tm => tm -> Maybe (Array HTMLElement)
  , queryByTitle ∷ ∀ tm. TextMatch tm => tm -> Maybe HTMLElement
  , queryAllByTitle ∷ ∀ tm. TextMatch tm => tm -> Maybe (Array HTMLElement)
  , queryByDisplayValue ∷ ∀ tm. TextMatch tm => tm -> Maybe HTMLElement
  , queryAllByDisplayValue ∷ ∀ tm. TextMatch tm => tm -> Maybe (Array HTMLElement)
  , queryByRole ∷ ∀ tm. TextMatch tm => tm -> Maybe HTMLElement
  , queryAllByRole ∷ ∀ tm. TextMatch tm => tm -> Maybe (Array HTMLElement)
  , queryByPlaceholderText ∷ ∀ tm. TextMatch tm => tm -> Maybe HTMLElement
  , queryAllByPlaceholderText ∷ ∀ tm. TextMatch tm => tm -> Maybe (Array HTMLElement)
  , rerender ∷ ∀ m. MonadEffect m => JSX -> m Unit
  }

-- | To be used for most of the getBy/findBy etc functions
class TextMatch ∷ ∀ k. k -> Constraint
class TextMatch a

instance tmString ∷ TextMatch String
else instance tmRegex ∷ TextMatch Regex
else instance tmFn ∷ TextMatch (String -> Boolean)
else instance tmInvalidType ∷
  ( Fail (Text "TextMatch must either be a String, a Regex, or String -> Boolean")
  ) =>
  TextMatch a
