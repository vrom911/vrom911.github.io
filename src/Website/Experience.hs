module Website.Experience
       ( Experience (..)
       , mkExperienceCtx
       ) where

import Hakyll (Compiler, Context, Item, field, itemBody, listField, makeItem)

data Experience = Experience
    { eName     :: String
    , eLink     :: String
    , eImg      :: String
    , eTime     :: String
    , ePosition :: String
    }

experienceCtx :: Context Experience
experienceCtx =
    field "eName"     (pure . eName     . itemBody)
 <> field "eLink"     (pure . eLink     . itemBody)
 <> field "eImg"      (pure . eImg      . itemBody)
 <> field "eTime"     (pure . eTime     . itemBody)
 <> field "ePosition" (pure . ePosition . itemBody)

allExperience :: Compiler [Item Experience]
allExperience = traverse makeItem
    [ Experience
        { eName = "Holmusk"
        , eLink = "https://holmusk.com"
        , eImg  = "hm.jpg"
        , eTime = "May, 2018 — present"
        , ePosition = "Haskell Developer"
        }
    ]

mkExperienceCtx :: Context a
mkExperienceCtx = listField "experience" experienceCtx allExperience
