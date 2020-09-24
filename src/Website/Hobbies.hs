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
        { hName = "Open Source"
        , hLink = "/hobbies/open-source"
        , hIcon = "code-branch"
        , hDesc = "I'm a very active member of the Open Source community. Over the last few years, I have contributed to many Haskell libraries and applications, created a number of the projects and tools that improve users experience. Check out the link with my Open Source work."
        }
    , Hobby
        { hName = "Travel"
        , hLink = "/hobbies/travel"
        , hIcon = "map-signs"
        , hDesc = "I dream about visiting most of the World. Currently, I'm in London, UK. Check out the countries I've already been to."
        }
    , Hobby
        { hName = "Generative Art"
        , hLink = "/hobbies/art"
        , hIcon = "palette"
        , hDesc = "Generative patterns are something that I completely adore. I even have made a few by myself. Check out some of my Processing drafts I did a while ago."
        }
    , Hobby
        { hName = "Books"
        , hLink = "/hobbies/books"
        , hIcon = "book-reader"
        , hDesc = "Coming soon"
        }
    , Hobby
        { hName = "Movies"
        , hLink = "/hobbies/movies"
        , hIcon = "film"
        , hDesc = "Coming soon."
        }

    ]

mkHobbiesCtx :: Context a
mkHobbiesCtx = listField "hobbies" (hobbyName <> hobbyLink <> hobbyIcon <> hobbyDesc) allHobbies
