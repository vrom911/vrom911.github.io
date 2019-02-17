module Website.Context
       ( stripExtension
       , postCtx
       , postCtxWithTags
       ) where

import Hakyll (Context, dateField, defaultContext, field, functionField, itemBody, listField,
               makeItem)

import qualified Data.Text as T


-- | Removes the @.html@ suffix in the post URLs.
stripExtension :: Context a
stripExtension = functionField "stripExtension" $ \args _ -> case args of
    [k] -> pure $ maybe k T.unpack (T.stripSuffix ".html" $ T.pack k)
    _   -> error "relativizeUrl only needs a single argument"

-- | Context to use in posts
postCtx :: Context String
postCtx = stripExtension
    <> dateField "date" "%B %e, %Y"
    <> defaultContext

-- | Context with tags and dates.
postCtxWithTags :: [String] -> Context String
postCtxWithTags tags =
    listField "tagsList" (field "tag" $ pure . itemBody) (traverse makeItem tags)
    <> postCtx
