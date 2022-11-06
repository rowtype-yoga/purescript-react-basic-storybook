module Storybook.Addon.Docs where

import React.Basic (ReactComponent)

foreign import titleImpl :: forall p. ReactComponent p
foreign import subtitleImpl :: forall p. ReactComponent p
foreign import descriptionImpl :: forall p. ReactComponent p
foreign import primaryImpl :: forall p. ReactComponent p
foreign import argsTableImpl :: forall p. ReactComponent p
foreign import storiesImpl :: forall p. ReactComponent p
foreign import primaryStoryImpl :: forall p. ReactComponent p
