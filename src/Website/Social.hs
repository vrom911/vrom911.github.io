module Website.Social
       ( Social (..)
       , mkSocialCtx
       , mkPostSocialCtx
       ) where

import Hakyll (Context, field, itemBody, listField, makeItem)

data Social = Social
    { sName :: String
    , sLink :: String
    }

socialName, socialLink :: Context Social
socialName = field "socialName" $ pure . sName . itemBody
socialLink = field "socialLink" $ pure . sLink . itemBody

postSocials :: [Social]
postSocials =
    [ Social "twitter"   "https://twitter.com/vrom911"
    , Social "github"    "https://github.com/vrom911"
    , Social "linkedin"  "https://www.linkedin.com/in/veronikaromashkina/"
    ]

allSocials :: [Social]
allSocials = postSocials ++
    [ Social "reddit"    "https://www.reddit.com/user/vrom911"
    , Social "telegram"  "https://t.me/vrom911"
    , Social "facebook"  "https://www.facebook.com/ronnie.romashkina"
    , Social "instagram" "https://www.instagram.com/vrom911/"
    ]

mkSocialCtx :: Context a
mkSocialCtx = listField "socials" (socialName <> socialLink) (traverse makeItem allSocials)

mkPostSocialCtx :: Context a
mkPostSocialCtx = listField "socials" (socialName <> socialLink) (traverse makeItem postSocials)
