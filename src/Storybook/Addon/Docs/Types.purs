module Storybook.Addon.Docs.Types where

import Prelude

import Color (Color, toHexString)
import Color as Color
import Control.MonadPlus as MP
import Data.Array as Array
import Data.Array.NonEmpty as NEA
import Data.Bounded.Generic (class GenericBottom, class GenericTop, genericBottom, genericTop)
import Data.Enum (class BoundedEnum, enumFromTo)
import Data.Enum.Generic (class GenericBoundedEnum, class GenericEnum, genericPred, genericSucc)
import Data.Eq.Generic (class GenericEq, genericEq)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep as GR
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NES
import Data.Symbol (class IsSymbol, reflectSymbol)
import Data.Tuple (Tuple(..))
import Data.Unfoldable (class Unfoldable, singleton, unfoldr)
import Data.Unfoldable (class Unfoldable1)
import Data.Unfoldable1 (unfoldr1)
import Effect (Effect)
import Foreign.Object (Object)
import Heterogeneous.Mapping (class Mapping)
import Literals.Undefined (undefined)
import Prim.Row as Row
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import React.Basic (JSX)
import React.Basic.DOM as R
import Record (merge)
import Record.Builder (Builder)
import Record.Builder as Builder
import Record.Studio (class SingletonRecord)
import Record.Studio.SingletonRecord as SingletonRecord
import Storybook.Addon.Actions (action)
import Type.Equality (class TypeEquals)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Union (UndefinedOr, maybeToUor, uorToMaybe)

foreign import data ActionArg :: Type
foreign import data ActionArg_ :: Type

-- ArgType

type ArgType =
  { name :: String
  , required :: Boolean
  , description :: Maybe String
  , table ::
      { type :: { summary :: String, detail :: Maybe String }
      , defaultValue ::
          Maybe { summary :: String, detail :: Maybe String }
      }
  , control :: ArgTypeControl
  }

data ArgTypeControl
  = BooleanControl
  | NumberControl { min :: Number, max :: Number, step :: Number }
  | RangeControl { min :: Number, max :: Number, step :: Number }
  | TextControl
  | ObjectControl
  | FileControl { accept :: String }
  | RadioControl (Array String)
  | InlineRadioControl (Array String)
  | SelectControl (Array String)
  | InlineSelectControl (Array String)
  | CheckControl (Array String)
  | InlineCheckControl (Array String)
  | ColorControl (Array Color)
  | DateControl
  | NoControl

type StorybookArgType =
  { control :: String
  , description :: Nullable String
  , name :: String
  , options :: Array String
  , table ::
      { defaultValue ::
          Nullable
            { detail :: Nullable String
            , summary :: String
            }
      , type ::
          { detail :: Nullable String
          , summary :: String
          }
      }
  , type ::
      { required :: Boolean
      }
  }

argTypeToStorybook
  :: ArgType
  -> StorybookArgType
argTypeToStorybook { name, required, description, table, control: argTypeControl } =
  { name
  , type: { required }
  , description: Nullable.toNullable description
  , table:
      { type: table.type { detail = Nullable.toNullable table.type.detail }
      , defaultValue: Nullable.toNullable
          $ table.defaultValue
              <#>
                (_ { detail = Nullable.toNullable (_.detail =<< table.defaultValue) })
      }
  , control
  , options
  }
  where
  { control, options } = case argTypeControl of
    NumberControl minMaxStep -> { control: unsafeCoerce ({ type: "number" } # merge minMaxStep), options: [] }
    RangeControl minMaxStep -> { control: unsafeCoerce ({ type: "range" } # merge minMaxStep), options: [] }
    TextControl -> { control: "text", options: [] }
    BooleanControl -> { control: "boolean", options: [] }
    ObjectControl -> { control: "object", options: [] }
    FileControl accept -> { control: unsafeCoerce ({ type: "file" } # merge accept), options: [] }
    RadioControl options -> { control: "radio", options }
    InlineRadioControl options -> { control: "inline-radio", options }
    SelectControl options -> { control: "select", options }
    InlineSelectControl options -> { control: "inline-select", options }
    CheckControl options -> { control: "check", options }
    InlineCheckControl options -> { control: "inline-check", options }
    ColorControl presetColors -> { control: unsafeCoerce ({ type: "color" } # merge { presetColors: toHexString <$> presetColors }), options: [] }
    DateControl -> { control: "color", options: [] }
    NoControl -> { control: unsafeCoerce { disable: true }, options: unsafeCoerce undefined }

data LogAction input = LogAction (input -> String)
data LogEffect = LogEffect (String)

-- The helpers

class ToArgType :: forall k. k -> Constraint
class ToArgType a where
  toArgType :: Proxy a -> ArgType

instance ToArgType String where
  toArgType _ =
    { name: "?"
    , required: true
    , description: Nothing
    , table: { type: { summary: "String", detail: Nothing }, defaultValue: Nothing }
    , control: TextControl
    }

instance ToArgType (UndefinedOr String) where
  toArgType _ =
    { name: "?"
    , required: false
    , description: Nothing
    , table: { type: { summary: "String", detail: Nothing }, defaultValue: Nothing }
    , control: TextControl
    }

instance ToArgType (UndefinedOr NonEmptyString) where
  toArgType _ =
    { name: "?"
    , required: false
    , description: Nothing
    , table: { type: { summary: "NonEmptyString", detail: Nothing }, defaultValue: Nothing }
    , control: TextControl
    }

instance ToArgType (Object String) where
  toArgType _ =
    { name: "?"
    , required: true
    , description: Nothing
    , table: { type: { summary: "Object String", detail: Nothing }, defaultValue: Nothing }
    , control: ObjectControl
    }

instance ToArgType JSX where
  toArgType _ =
    { name: "?"
    , required: true
    , description: Nothing
    , table: { type: { summary: "JSX", detail: Nothing }, defaultValue: Nothing }
    , control: TextControl
    }

instance ToArgType (Array JSX) where
  toArgType _ =
    { name: "?"
    , required: true
    , description: Nothing
    , table: { type: { summary: "JSX", detail: Nothing }, defaultValue: Nothing }
    , control: ObjectControl
    }

instance ToArgType Boolean where
  toArgType _ =
    { name: "?"
    , required: true
    , description: Nothing
    , table: { type: { summary: "Boolean", detail: Nothing }, defaultValue: Nothing }
    , control: BooleanControl
    }

instance ToArgType Int where
  toArgType _ =
    { name: "?"
    , required: true
    , description: Nothing
    , table:
        { type: { summary: "Int", detail: Nothing }
        , defaultValue: Nothing
        }
    , control: NumberControl { max: 1000.0, min: -1000.0, step: 1.0 }
    }

instance ToArgType Number where
  toArgType _ =
    { name: ""
    , required: true
    , description: Nothing
    , table:
        { type: { summary: "Number", detail: Nothing }
        , defaultValue: Nothing
        }
    , control: RangeControl { max: 100.0, min: -100.0, step: 0.1 }
    }

instance ToArgType NonEmptyString where
  toArgType _ =
    { name: ""
    , required: true
    , description: Nothing
    , table:
        { type: { summary: "NonEmptyString", detail: Nothing }
        , defaultValue: Nothing
        }
    , control: RangeControl { max: 100.0, min: -100.0, step: 0.1 }
    }

data EnumArg :: forall k. k -> Type -> Type
data EnumArg typeName a = EnumArg a

enumArg
  :: forall name a rec rl
   . RowToList rec rl
  => SingletonRecord name a rec rl
  => { | rec }
  -> EnumArg name a
enumArg = EnumArg <<< SingletonRecord.value

instance (Generic a rep, GenericEnum rep, GenericBottom rep, ConstrName rep, IsSymbol typeName) => ToArgType (EnumArg typeName a) where
  toArgType _ =
    { name: ""
    , required: true
    , description: Nothing
    , table:
        { type: { summary: reflectSymbol (Proxy :: Proxy typeName), detail: Nothing }
        , defaultValue: Nothing
        }
    , control: SelectControl
        ( (items :: Array a) <#> constrName
        )
    }
    where
    items = go [ first ] first

    go :: Array a -> a -> Array a
    go acc curr = case genericSucc curr of
      _ | Array.length acc >= 30 -> acc
      Nothing -> acc
      Just next -> go (Array.snoc acc next) next
    first = genericBottom

instance
  ( Generic a rep
  , GenericEnum rep
  , GenericBottom rep
  , ConstrName rep
  , IsSymbol typeName
  , ToArgType (EnumArg typeName a)
  ) =>
  ToArgType (UndefinedOr (EnumArg typeName a)) where
  toArgType _ = aArgType { required = false }
    where
    aArgType = toArgType (Proxy :: Proxy (EnumArg typeName a))

instance toArgTypeCallback :: (ToArgType a) => ToArgType (LogAction a) where
  toArgType _ =
    { name: ""
    , required: true
    , description: Nothing
    , table:
        { type: { summary: aArgType.table.type.summary <> " -> Effect Unit", detail: Nothing }
        , defaultValue: Nothing
        }
    , control: NoControl
    }
    where
    aArgType = toArgType (Proxy :: Proxy a)

instance toArgTypeEffect :: ToArgType (LogEffect) where
  toArgType _ =
    { name: ""
    , required: true
    , description: Nothing
    , table:
        { type: { summary: "Effect Unit", detail: Nothing }
        , defaultValue: Nothing
        }
    , control: NoControl
    }

enumToArgType
  ∷ ∀ a rep
  . Generic a rep
  ⇒ GenericEnumToArgType rep
  ⇒ a
  → ArgType
enumToArgType a = genericEnumToArgType (GR.from a)

class GenericEnumToArgType rep where
  genericEnumToArgType ∷ rep → ArgType

instance
  ( GenericEnumToArgType a
  , GenericEnumToArgType b
  ) ⇒
  GenericEnumToArgType (GR.Sum a b) where
  genericEnumToArgType = case _ of
    (GR.Inl a) → genericEnumToArgType a
    (GR.Inr a) → genericEnumToArgType a

class FromStorybookArg from a where
  fromStorybookArg :: from -> a

instance FromStorybookArg String String where
  fromStorybookArg = identity

instance FromStorybookArg (Object String) (Object String) where
  fromStorybookArg = identity

instance FromStorybookArg (UndefinedOr String) (UndefinedOr String) where
  fromStorybookArg = identity

instance FromStorybookArg (UndefinedOr String) (UndefinedOr NonEmptyString) where
  fromStorybookArg x = uorToMaybe x >>= NES.fromString # maybeToUor

instance FromStorybookArg String (UndefinedOr NonEmptyString) where
  fromStorybookArg = NES.fromString >>> maybeToUor

instance FromStorybookArg Color String where
  fromStorybookArg = Color.cssStringRGBA

instance FromStorybookArg Boolean Boolean where
  fromStorybookArg = identity

instance FromStorybookArg String JSX where
  fromStorybookArg = R.text

instance FromStorybookArg JSX JSX where
  fromStorybookArg = identity

instance FromStorybookArg (Array JSX) (Array JSX) where
  fromStorybookArg = identity

instance FromStorybookArg String (Array JSX) where
  fromStorybookArg = pure <<< R.text

instance FromStorybookArg (Array String) (Array JSX) where
  fromStorybookArg = map R.text

instance FromStorybookArg Int Int where
  fromStorybookArg = identity

instance FromStorybookArg Number Number where
  fromStorybookArg = identity

instance (FromStorybookArg a b) => FromStorybookArg (UndefinedOr a) (Maybe b) where
  fromStorybookArg = uorToMaybe >>> map fromStorybookArg

instance
  ( Generic a rep
  , ConstrName rep
  , GenericBottom rep
  , GenericEnum rep
  , GenericTop rep
  ) =>
  FromStorybookArg (EnumArg typeName a) a where
  fromStorybookArg raw = go first
    where
    go x = case genericSucc x of
      Nothing -> first
      Just next -> if constrName next == str then next else go next
    first = genericBottom

    str :: String
    str = unsafeCoerce raw

instance FromStorybookArg (LogAction a) (a -> Effect Unit) where
  fromStorybookArg (LogAction toString) = \v -> action (toString v) v

instance FromStorybookArg (LogEffect) (Effect Unit) where
  fromStorybookArg (LogEffect str) = action "Callback called" str

data FromStorybookArgHelper = FromStorybookArgHelper

instance
  ( FromStorybookArg from to
  ) =>
  Mapping FromStorybookArgHelper from to where
  mapping FromStorybookArgHelper = fromStorybookArg

type Props =
  { theText :: String
  , bier :: Int
  , loveBoats :: Number
  , stuff :: Maybe String
  , callback :: String -> Effect Unit
  }

-- Infer Arg types for records
inferArgTypes :: forall r rl to. RowToList r rl => InferArgTypesRL rl r () to => { | r } -> { | to }
inferArgTypes _ = Builder.buildFromScratch $
  toArgTypeFields (Proxy :: Proxy rl) (Proxy :: Proxy { | r })

class
  InferArgTypesRL (rl :: RowList Type) row (from :: Row Type) (to :: Row Type)
  | rl -> row from to where
  toArgTypeFields :: Proxy rl -> Proxy { | row } -> Builder (Record from) (Record to)

instance inferArgTypesTail ::
  ( IsSymbol name
  , ToArgType ty
  , InferArgTypesRL tail row from from'
  , Row.Cons name ty whatever row
  , Row.Lacks name from'
  , Row.Cons name ArgType from' to
  ) =>
  InferArgTypesRL (RL.Cons name ty tail) row from to where
  toArgTypeFields _ recP = result
    where
    result = Builder.insert nameP value <<< rest
    nameP = Proxy :: Proxy name
    name = reflectSymbol nameP
    tailP = Proxy :: Proxy tail
    tyP = Proxy :: Proxy ty
    value = (toArgType tyP) { name = name }
    rest = toArgTypeFields tailP recP

instance InferArgTypesRL RL.Nil row () () where
  toArgTypeFields _ _ = identity

class ConstrName rep where
  constrName' :: rep -> String

instance IsSymbol name => ConstrName (GR.Constructor name a) where
  constrName' (GR.Constructor _) = reflectSymbol (Proxy :: Proxy name)

instance (ConstrName a, ConstrName b) => ConstrName (GR.Sum a b) where
  constrName' (GR.Inl a) = constrName' a
  constrName' (GR.Inr b) = constrName' b

constrName :: forall a rep. Generic a rep => ConstrName rep => a -> String
constrName a = constrName' $ GR.from a
