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
    [ Social "fab fa-twitter"   "https://twitter.com/vrom911"
    , Social "fab fa-github"    "https://github.com/vrom911"
    , Social "fab fa-linkedin"  "https://www.linkedin.com/in/veronikaromashkina/"
    ]

allSocials :: [Social]
allSocials = postSocials ++
    [ Social "fab fa-reddit"    "https://www.reddit.com/user/vrom911"
    , Social "fab fa-telegram"  "https://t.me/vrom911"
    , Social "fab fa-facebook"  "https://www.facebook.com/ronnie.romashkina"
    , Social "fab fa-instagram" "https://www.instagram.com/vrom911/"
    , Social "fas fa-rss"       "https://vrom911.github.io/rss.xml"
    ]

mkSocialCtx :: Context a
mkSocialCtx = listField "socials" (socialName <> socialLink) (traverse makeItem allSocials)

mkPostSocialCtx :: Context a
mkPostSocialCtx = listField "socials" (socialName <> socialLink) (traverse makeItem postSocials)
