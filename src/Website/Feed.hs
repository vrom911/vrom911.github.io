-- | RSS and Atom feeds.

module Website.Feed
    ( createFeeds
    ) where

import Hakyll (Compiler, Context, Item, Rules, bodyField, compile, create, idRoute,
               loadAllSnapshots, recentFirst, route)
import Hakyll.Web.Feed (FeedConfiguration (..), renderAtom, renderRss)

import Website.Context (postCtxWithTags)


feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "vrom911 Blog"
    , feedDescription = "This feed provides blog posts about Haskell and functional programming in general"
    , feedAuthorName  = "Veronika Romashkina"
    , feedAuthorEmail = "vrom911@gmail.com"
    , feedRoot        = "https://vrom911.github.io"
    }

type FeedRenderer =
    FeedConfiguration
    -> Context String
    -> [Item String]
    -> Compiler (Item String)

feedContext :: Context String
feedContext = postCtxWithTags [] <> bodyField "description"

feedCompiler :: FeedRenderer -> Compiler (Item String)
feedCompiler renderer = loadAllSnapshots "blog/*" "content"
    >>= fmap (take 10) . recentFirst
    >>= renderer feedConfiguration feedContext

-- | Create RSS and Atom feeds.
createFeeds :: Rules ()
createFeeds = do
    -- Atom feed
    create ["atom.xml"] $ do
        route idRoute
        compile $ feedCompiler renderAtom

    -- RSS feed
    create ["rss.xml"] $ do
        route idRoute
        compile $ feedCompiler renderRss
