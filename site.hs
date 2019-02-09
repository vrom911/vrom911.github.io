import Hakyll (Context, Identifier, Rules, applyAsTemplate, compile, compressCss,
               compressCssCompiler, copyFileCompiler, create, defaultContext, functionField, hakyll,
               idRoute, loadAndApplyTemplate, makeItem, match, relativizeUrls, route, setExtension,
               templateBodyCompiler, (.||.))
import Hakyll.Core.Identifier (fromFilePath, toFilePath)
import Hakyll.Web.Sass (sassCompiler)

import qualified Data.Text as T


main :: IO ()
main = hakyll $ do
    match ("images/**" .||. "fonts/**" .||. "js/*" .||. "pde/*"  .||. "favicon.ico") $ do
        route   idRoute
        compile copyFileCompiler

    match "scss/*.scss" $ do
        route $ setExtension "css"
        let compressCssItem = fmap compressCss
        compile (compressCssItem <$> sassCompiler)

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- Main pages
    createMainPage "index.html"
    createMainPage "projects.html"
    createMainPage "hobbies.html"
    createMainPage "blog.html"

    createMainPage "about.html"

    -- Render the 404 page, we don't relativize URL's here.
    create ["404.html"] $ do
        route idRoute
        compile $ do
            let ctx = defaultContext
            makeItem ""
                >>= applyAsTemplate ctx
                >>= loadAndApplyTemplate "templates/404.html" ctx

    match "templates/*" $ compile templateBodyCompiler

createMainPage :: Identifier -> Rules ()
createMainPage page = create [page] $ do
    route idRoute
    compile $ do
        let ctx = stripExtension <> defaultContext
        makeItem ""
            >>= applyAsTemplate ctx
            >>= loadAndApplyTemplate (fromFilePath $ "templates/" ++ toFilePath page) ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

-- | Removes the @.html@ suffix in the post URLs.
stripExtension :: Context a
stripExtension = functionField "stripExtension" $ \args _ -> case args of
    [k] -> pure $ maybe k T.unpack (T.stripSuffix ".html" $ T.pack k)
    _   -> error "relativizeUrl only needs a single argument"
