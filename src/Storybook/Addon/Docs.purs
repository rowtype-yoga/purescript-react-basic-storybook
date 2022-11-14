module Storybook.Addon.Docs where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Data.Symbol (class IsSymbol)
import Prim.Row as Row
import Prim.RowList (class RowToList)
import React.Basic (ReactComponent)
import Record as Record
import Record.Studio (class SingletonRecord)
import Record.Studio.SingletonRecord as SingletonRecord
import Storybook.Addon.Docs.Types (ArgType, ArgTypeControl)

foreign import titleImpl :: forall p. ReactComponent p
foreign import subtitleImpl :: forall p. ReactComponent p
foreign import descriptionImpl :: forall p. ReactComponent p
foreign import primaryImpl :: forall p. ReactComponent p
foreign import argsTableImpl :: forall p. ReactComponent p
foreign import storiesImpl :: forall p. ReactComponent p
foreign import primaryStoryImpl :: forall p. ReactComponent p

type MapArgType a s key sRL rec missing =
  Row.Cons key ArgType missing rec
  => IsSymbol key
  => RowToList s sRL
  => SingletonRecord key a s sRL
  => { | s }
  -> { | rec }
  -> { | rec }

setDescription :: forall s s' k r r'. MapArgType String s k s' r r'
setDescription s = mapArgType (_ { description = Just (SingletonRecord.value s) }) s

setName :: forall s s' k r r'. MapArgType String s k s' r r'
setName s = mapArgType (_ { name = (SingletonRecord.value s) }) s

setRequired :: forall s s' k r r'. MapArgType Boolean s k s' r r'
setRequired s = mapArgType (_ { required = (SingletonRecord.value s) }) s

setType :: forall s s' k r r'. MapArgType String s k s' r r'
setType s = s # mapArgType
  \x -> x
    { table = x.table
        { type = x.table.type
            { summary = (SingletonRecord.value s)
            }
        }
    }

setTypeDetail :: forall s s' k r r'. MapArgType String s k s' r r'
setTypeDetail s = s # mapArgType
  \x -> x
    { table = x.table
        { type = x.table.type
            { detail = Just (SingletonRecord.value s)
            }
        }
    }

setDefaultValue :: forall s s' k r r'. MapArgType String s k s' r r'
setDefaultValue s = s # mapArgType
  \x -> x
    { table = x.table
        { defaultValue = Just
            ( (x.table.defaultValue # fromMaybe mempty)
                { summary = SingletonRecord.value s
                }
            )
        }
    }

setDefaultValueDetail :: forall s s' k r r'. MapArgType String s k s' r r'
setDefaultValueDetail s = s # mapArgType
  \x -> x
    { table = x.table
        { defaultValue = Just
            ( (x.table.defaultValue # fromMaybe mempty)
                { detail = Just (SingletonRecord.value s)
                }
            )
        }
    }

setControl :: forall s s' k r r'. MapArgType (ArgTypeControl) s k s' r r'
setControl s = s # mapArgType \x -> x { control = (SingletonRecord.value s) }

mapArgType
  :: forall a s key sRL rec missing
   . Row.Cons key ArgType missing rec
  => IsSymbol key
  => RowToList s sRL
  => SingletonRecord key a s sRL
  => (ArgType -> ArgType)
  -> { | s }
  -> { | rec }
  -> { | rec }
mapArgType setter s rec = Record.modify key setter rec
  where
  key = SingletonRecord.key s
