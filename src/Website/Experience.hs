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
    , eCountry  :: String
    }

experienceCtx :: Context Experience
experienceCtx =
    field "eName"     (pure . eName     . itemBody)
 <> field "eLink"     (pure . eLink     . itemBody)
 <> field "eImg"      (pure . eImg      . itemBody)
 <> field "eTime"     (pure . eTime     . itemBody)
 <> field "ePosition" (pure . ePosition . itemBody)
 <> field "eCountry"  (pure . eCountry  . itemBody)

allExperience :: Compiler [Item Experience]
allExperience = traverse makeItem
    [ Experience
        { eName = "Holmusk"
        , eLink = "https://holmusk.com"
        , eImg  = "hm.jpg"
        , eTime = "May, 2018 — Nov, 2019"
        , ePosition = "Middle Haskell Developer"
        , eCountry = "Singapore"
        }
    , Experience
        { eName = "Serokell"
        , eLink = "https://serokell.io"
        , eImg  = "sk.png"
        , eTime = "Nov, 2017 — April, 2018"
        , ePosition = "Haskell Developer"
        , eCountry = "Russia, Saint Petersburg"
        }
    , Experience
        { eName = "Aelve"
        , eLink = "https://aelve.com"
        , eImg  = "ae.png"
        , eTime = "Jul, 2017 — Oct, 2018"
        , ePosition = "Junior Haskell Developer"
        , eCountry = "Russia, Saint Petersburg"
        }
    , Experience
        { eName = "EUG2016"
        , eLink = "http://eug2016.com/"
        , eImg  = "eug.jpg"
        , eTime = "Jul, 2016 — Aug, 2016"
        , ePosition = "Level 2 Helpdesk Engineer"
        , eCountry = "Croatia, Zagreb"
        }
    , Experience
        { eName = "ATEF"
        , eLink = "http://www.atefgroup.com/en/"
        , eImg  = "atef.png"
        , eTime = "Jan, 2016 — Jul, 2016"
        , ePosition = "Python Web Developer"
        , eCountry = "Azerbaijan, Baku"
        }

    ]

mkExperienceCtx :: Context a
mkExperienceCtx = listField "experience" experienceCtx allExperience
