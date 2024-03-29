module AppDecorator where

import Prelude

import React.Basic.DOM as R
import Storybook (MetaDecorator, metaDecorator)

appDecorator ∷ MetaDecorator
appDecorator = metaDecorator $ \child -> do
  R.div
    { style: R.css
        { background: "radial-gradient(#f4f2f5 67%, #efeff2 100%)"
        , padding: "3vw"
        , display: "flex"
        , justifyContent: "center"
        , alignItems: "center"
        }
    , children: [ child ]
    }
