module Website.Project
       ( Project (..)
       , mkProjectCtx
       ) where

import Hakyll (Compiler, Context, Item, field, itemBody, listField, makeItem)

data Project = Project
    { pName :: String
    , pLink :: String
    , pImg  :: String
    , pDesc :: String
    }

projectCtx :: Context Project
projectCtx =
    field "pName" (pure . pName . itemBody)
 <> field "pLink" (pure . pLink . itemBody)
 <> field "pImg"  (pure . pImg  . itemBody)
 <> field "pDesc" (pure . pDesc . itemBody)

allProjects :: Compiler [Item Project]
allProjects = traverse makeItem
    [ Project
        { pName = "Summoner"
        , pLink = "kowainik/summoner"
        , pImg  = "https://user-images.githubusercontent.com/8126674/44388234-320aac00-a55a-11e8-879d-5dca68512031.png"
        , pDesc = "Tool for scaffolding batteries-included production-level Haskell projects"
        }
    , Project
        { pName = "TypeRep-Map"
        , pLink = "kowainik/typerep-map"
        , pImg  = "https://user-images.githubusercontent.com/8126674/44323413-788dd700-a484-11e8-842e-f224cfaa4206.png"
        , pDesc = "Efficient implementation of Map with types as keys"
        }
    , Project
        { pName = "Relude"
        , pLink = "kowainik/relude"
        , pImg  = "https://user-images.githubusercontent.com/8126674/67678250-9d8eab80-f99f-11e9-96ca-27883ceeefa6.png"
        , pDesc = "Alternative Prelude"
        }
    , Project
        { pName = "Smuggler"
        , pLink = "kowainik/smuggler"
        , pImg  = "https://user-images.githubusercontent.com/4276606/45937457-c2715c00-bff2-11e8-9766-f91051d36ffe.png"
        , pDesc = "Haskell Source Plugin which removes unused imports automatically."
        }
    , Project
        { pName = "Hit On"
        , pLink = "kowainik/hit-on"
        , pImg  = "https://user-images.githubusercontent.com/4276606/53816638-d86e4a00-3f9e-11e9-83ab-74032363292f.png"
        , pDesc = "Git Workflow Helper Tool"
        }
    , Project
        { pName = "Haskeller"
        , pLink = "vrom911/haskeller-answers"
        , pImg  = "https://user-images.githubusercontent.com/8126674/68671035-d87c0c00-0567-11ea-9db0-258c2b27a464.png"
        , pDesc = "Web app for typical Haskeller answers to everything."
        }
    , Project
        { pName = "Tomland"
        , pLink = "kowainik/tomland"
        , pImg  = "https://user-images.githubusercontent.com/4276606/51088259-7a777000-176e-11e9-9d76-6be4023c0ac3.png"
        , pDesc = "Bidirectional TOML serialization."
        }
    ]

mkProjectCtx :: Context a
mkProjectCtx = listField "projects" projectCtx allProjects
