module Website.Blog
       ( matchBlogPosts
       , createBlog
       , createTags

       , compilePosts
       , makeExternalPostsContext
       ) where

import Data.List (nub)
import Hakyll (Compiler, Context, Item, Pattern, Rules, buildTags, compile, constField, create,
               customRoute, defaultContext, defaultHakyllReaderOptions, defaultHakyllWriterOptions,
               field, fromCapture, getResourceString, getTags, idRoute, itemBody, itemIdentifier,
               listField, loadAll, loadAndApplyTemplate, makeItem, match, pandocCompiler,
               recentFirst, relativizeUrls, renderPandocWith, route, tagsRules, toFilePath)
import System.FilePath (replaceExtension)
import Text.Pandoc.Options (WriterOptions (..))

import Website.Context (postCtx, postCtxWithTags)
import Website.Nav (mkNavCtx)
import Website.Social (mkPostSocialCtx, mkSocialCtx)


-- | Creates each post page.
matchBlogPosts :: Rules ()
matchBlogPosts = match "blog/*" $ do
    route $ customRoute $ (`replaceExtension` "html") . ("blog/" ++) . drop 16 . toFilePath
    compile $ do
        i   <- getResourceString
        pandoc <- renderPandocWith defaultHakyllReaderOptions withToc i
        let toc = itemBody pandoc
        tgs <- getTags (itemIdentifier i)
        let postTagsCtx = postCtxWithTags tgs
                       <> mkPostSocialCtx
                       <> constField "toc" toc
        pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" postTagsCtx
            >>= relativizeUrls

-- | Creates "Blog" page with all tags.
createBlog :: Rules ()
createBlog = create ["blog.html"] $ compilePosts "Blog Posts" "blog/*"

createTags :: Rules ()
createTags = do
    tags <- buildTags "blog/*" (fromCapture "tags/*.html")
    tagsRules tags $ \tag ptrn -> do
        let title = "Tag " ++ tag
        compilePosts title ptrn

-- | Compiles all posta for the blog pages with the tags context
compilePosts :: String -> Pattern -> Rules ()
compilePosts title ptrn = do
    route idRoute
    compile $ do
        posts <- recentFirst =<< loadAll ptrn
        let ids = map itemIdentifier posts
        tagsList <- nub . concat <$> traverse getTags ids
        let ctx = postCtxWithTags tagsList
               <> listField "posts" postCtx (pure posts)
               <> mkNavCtx
               <> mkSocialCtx
               <> makeExternalPostsContext
               <> constField "title" title
               <> defaultContext

        makeItem ""
            >>= loadAndApplyTemplate "templates/blog.html" ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

-- | Compose TOC from the markdown.
withToc :: WriterOptions
withToc = defaultHakyllWriterOptions
    { writerTableOfContents = True
    , writerTOCDepth = 4
    , writerTemplate = Just "$toc$"
    }

----------------------------------------------------------------------------
-- External posts
----------------------------------------------------------------------------

data ExternalPost = ExternalPost
    { epTitle :: String
    , epDate  :: String
    , epLink  :: String
    }

epTitleC, epDateC, epLinkC :: Context ExternalPost
epTitleC = field "externalTitle" $ pure . epTitle . itemBody
epDateC  = field "externalDate"  $ pure . epDate  . itemBody
epLinkC  = field "externalLink"  $ pure . epLink  . itemBody

allExternalPosts :: Compiler [Item ExternalPost]
allExternalPosts = traverse makeItem
    [ ExternalPost "Dhall to HLint: Using Dhall to generate HLint rules" "September  9, 2018" "https://kowainik.github.io/posts/2018-09-09-dhall-to-hlint"
    , ExternalPost "typerep-map Step by Step" "July 11, 2018" "https://kowainik.github.io/posts/2018-07-11-typerep-map-step-by-step"
    ]

-- | The Context with the information about external posts.
makeExternalPostsContext :: Context a
makeExternalPostsContext =
    listField "external" (epTitleC <> epDateC <> epLinkC) allExternalPosts
