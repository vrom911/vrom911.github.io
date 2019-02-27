module Website.Hobbies
       ( Hobby (..)
       , mkHobbiesCtx
       ) where

import Hakyll (Compiler, Context, Item, field, itemBody, listField, makeItem)

data Hobby = Hobby
    { hName :: String
    , hLink :: String
    , hIcon :: String
    , hDesc :: String
    }

hobbyName, hobbyLink, hobbyIcon, hobbyDesc :: Context Hobby
hobbyName = field "hobbyName" $ pure . hName . itemBody
hobbyLink = field "hobbyLink" $ pure . hLink . itemBody
hobbyIcon = field "hobbyIcon" $ pure . hIcon . itemBody
hobbyDesc = field "hobbyDesc" $ pure . hDesc . itemBody

allHobbies :: Compiler [Item Hobby]
allHobbies = traverse makeItem
    [ Hobby
        { hName = "Travel"
        , hLink = "/hobbies/travel"
        , hIcon = "map-signs"
        , hDesc = "Hello there"
        }
    , Hobby
        { hName = "Generative Art"
        , hLink = "/hobbies/art"
        , hIcon = "palette"
        , hDesc = "Hello there"
        }
    , Hobby
        { hName = "Books"
        , hLink = "/hobbies/books"
        , hIcon = "book-reader"
        , hDesc = "Hello there"
        }
    , Hobby
        { hName = "Open Source"
        , hLink = "/hobbies/open-source"
        , hIcon = "code-branch"
        , hDesc = "Hello there"
        }
    , Hobby
        { hName = "Movies"
        , hLink = "/hobbies/movies"
        , hIcon = "film"
        , hDesc = "Hello there"
        }

    ]

mkHobbiesCtx :: Context a
mkHobbiesCtx = listField "hobbies" (hobbyName <> hobbyLink <> hobbyIcon <> hobbyDesc) allHobbies
