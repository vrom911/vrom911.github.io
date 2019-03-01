module Website.Nav
       ( Nav (..)
       , mkNavCtx
       ) where

import Hakyll (Compiler, Context, Item, field, itemBody, listField, makeItem)

data Nav = Nav
    { nName :: String
    , nLink :: String
    , nId   :: String
    }

navCtx :: Context Nav
navCtx =
    field "navName" (pure . nName . itemBody)
 <> field "navLink" (pure . nLink . itemBody)
 <> field "navId"   (pure . nId   . itemBody)

allNavs :: Compiler [Item Nav]
allNavs = traverse makeItem
    [ Nav
        { nName = "About me"
        , nLink = "about"
        , nId   = "1"
        }
    , Nav
        { nName = "Projects"
        , nLink = "projects"
        , nId   = "2"
        }
    , Nav
        { nName = "Hobbies"
        , nLink = "hobbies"
        , nId   = "3"
        }
    , Nav
        { nName = "Blog"
        , nLink = "blog"
        , nId   = "4"
        }
    ]

mkNavCtx :: Context a
mkNavCtx = listField "navs" navCtx allNavs
