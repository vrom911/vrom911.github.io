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
    ]

mkProjectCtx :: Context a
mkProjectCtx = listField "projects" projectCtx allProjects
