module Website
       ( runWebsite
       ) where

import Hakyll (Identifier, Rules, applyAsTemplate, compile, compressCssCompiler, copyFileCompiler,
               create, defaultContext, hakyll, idRoute, loadAndApplyTemplate, makeItem, match,
               relativizeUrls, route, templateBodyCompiler, (.||.))
import Hakyll.Core.Identifier (fromFilePath, toFilePath)

import Website.Blog (createBlog, createTags, matchBlogPosts)
import Website.Context (stripExtension)
import Website.Hobbies (mkHobbiesCtx)
import Website.Social (mkSocialCtx)


-- | Main function that runs the website.
runWebsite :: IO ()
runWebsite = hakyll $ do
    match ("images/**" .||. "fonts/**" .||. "js/*" .||. "pde/*"  .||. "favicon.ico") $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- Main pages
    createMainPage "index.html"
    createMainPage "projects.html"
    createMainPage "hobbies.html"
    createMainPage "hobbies/travel.html"
    createMainPage "about.html"


    -- post pages
    matchBlogPosts
    -- All posts page
    createBlog
    -- build up tags
    createTags

    -- Render the 404 page, we don't relativize URL's here.
    create ["404.html"] $ do
        route idRoute
        compile $ do
            let ctx = stripExtension <> defaultContext
            makeItem ""
                >>= applyAsTemplate ctx
                >>= loadAndApplyTemplate "templates/404.html" ctx

    match "templates/**" $ compile templateBodyCompiler

createMainPage :: Identifier -> Rules ()
createMainPage page = create [page] $ do
    route idRoute
    compile $ do
        let ctx = stripExtension <> mkSocialCtx <> mkHobbiesCtx <> defaultContext
        makeItem ""
            >>= applyAsTemplate ctx
            >>= loadAndApplyTemplate (fromFilePath $ "templates/" ++ toFilePath page) ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls
