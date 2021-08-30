module Website
    ( runWebsite
    ) where

import Data.Time (getCurrentTime, getCurrentTimeZone, localDay, toGregorian, utcToLocalTime)
import Hakyll (Identifier, Rules, applyAsTemplate, compile, compressCssCompiler, constField,
               copyFileCompiler, create, defaultContext, hakyll, idRoute, loadAndApplyTemplate,
               makeItem, match, relativizeUrls, route, templateBodyCompiler, (.||.))
import Hakyll.Core.Identifier (fromFilePath, toFilePath)

import Website.Blog (createBlog, createTags, matchBlogPosts)
import Website.Context (stripExtension)
import Website.Experience (mkExperienceCtx)
import Website.Hobbies (mkHobbiesCtx)
import Website.Nav (mkNavCtx)
import Website.Project (mkProjectCtx)
import Website.Social (mkSocialCtx)


-- | Main function that runs the website.
runWebsite :: IO ()
runWebsite = currentYear >>= \year -> hakyll $ do
    match (    "images/**"
          .||. "fonts/**"
          .||. "js/*"
          .||. "pde/*"
          .||. "files/*"
          .||. "favicon.ico"
          .||. "keybase.txt"
          ) $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- Main pages
    let createMainPage = createPage year
    createMainPage "index.html"
    createMainPage "projects.html"
    createMainPage "hobbies.html"
    createMainPage "hobbies/travel.html"
    createMainPage "hobbies/art.html"
    createMainPage "about.html"


    -- post pages
    matchBlogPosts
    -- All posts page
    createBlog year
    -- build up tags
    createTags year

    -- Render the 404 page, we don't relativize URL's here.
    create ["404.html"] $ do
        route idRoute
        compile $ do
            let ctx = stripExtension <> defaultContext
            makeItem ""
                >>= applyAsTemplate ctx
                >>= loadAndApplyTemplate "templates/404.html" ctx

    match "templates/**" $ compile templateBodyCompiler

createPage :: String -> Identifier -> Rules ()
createPage year page = create [page] $ do
    route idRoute
    compile $ do
        let ctx = stripExtension
               <> mkSocialCtx
               <> mkHobbiesCtx
               <> mkExperienceCtx
               <> mkNavCtx
               <> mkProjectCtx
               <> defaultContext
               <> constField "year" year
        makeItem ""
            >>= applyAsTemplate ctx
            >>= loadAndApplyTemplate (fromFilePath $ "templates/" ++ toFilePath page) ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

currentYear :: IO String
currentYear = do
    now <- getCurrentTime
    zone <- getCurrentTimeZone
    let localNow = utcToLocalTime zone now
    let (year, _, _) = toGregorian $ localDay localNow
    pure $ show year
