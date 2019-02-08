import Hakyll (applyAsTemplate, compile, compressCss, compressCssCompiler, copyFileCompiler, create,
               defaultContext, hakyll, idRoute, loadAndApplyTemplate, makeItem, match,
               relativizeUrls, route, setExtension, templateBodyCompiler, (.||.))
import Hakyll.Web.Sass (sassCompiler)

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

    -- Main page
    create ["index.html"] $ do
        route idRoute
        compile $ do
            makeItem ""
                >>= applyAsTemplate defaultContext
                >>= loadAndApplyTemplate "templates/main.html" defaultContext
                >>= relativizeUrls
    -- Main page
    create ["new.html"] $ do
        route idRoute
        compile $ do
            makeItem ""
                >>= applyAsTemplate defaultContext
                >>= loadAndApplyTemplate "templates/new.html" defaultContext
                >>= relativizeUrls

    -- Render the 404 page, we don't relativize URL's here.
    create ["404.html"] $ do
        route idRoute
        compile $ do
            let ctx = defaultContext
            makeItem ""
                >>= applyAsTemplate ctx
                >>= loadAndApplyTemplate "templates/404.html" ctx

    match "templates/*" $ compile templateBodyCompiler
