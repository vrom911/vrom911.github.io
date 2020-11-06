---
title: Website is not easy
description: I decided to dedicate the very first post of my blog to the process of its creation.
tags: haskell, web, hakyll, processing
---

I decided to dedicate the very first post of my blog to the process of its creation. I am going to briefly walk you through the different aspects of website development. Based on my own experience, I am going to show how I put together different languages, tools, concepts, paradigms and how to overcome the frustration working on the website when you’re a backend developer, but you want your page to be fancy and semantically correct from all web points of view.

This website is hosted at [Github pages][GP]. Its content is generated with the help of the [`Hakyll`][Hakyll] templating framework written in [Haskell][hs]. I’m using [Processing][Processing] language for the images and art illustrations. And, standard pack of `HTML` + `CSS` + a bit of custom `JS`. You can find the code itself here:

* [Website sources](https://github.com/vrom911/vrom911.github.io)

## Quick history

I had a plan about having my own hand-made, custom and fancy website as any decent web developer (as I thought back then!). And the fundamental motive of this was my dream to create everything by myself from scratch, starting with the colour palette sketch, images, CSS responsive grid framework (I gave up this idea, of course) and finishing with the deployment mechanisms. The purpose of doing everything in this particular way was to get as much knowledge as possible from this process and, to be honest, I enjoyed learning every part the hard way.

I started the work in far 2014 where I was studying a lot of frontend techniques via courses, articles and other online resources. Among the courses, I would like to highlight a few interesting ones: HTML5 concepts and best practices and also very impressive but not very common about [Information and Communication Technology (ICT) Accessibility](https://www.edx.org/course/information-communication-technology-ict-gtx-ict100x-0). I was absolutely happy to find out all that concepts that make the website building processes more strict and semantically correct which surely could be beneficial for all the internet users if only all developers create “correct” websites. Hmm, interesting, now I am starting to think that even back then I liked the type-safety even not knowing about functional languages. Anyway, I abandoned the project in the middle as I got the job (not as the programmer) and only got back to finishing the website this month.

Beyond doubt, at this point, it’s not perfect in both design and semantical meaning, but at least I have my own cosy corner on the internet which I created by myself. So, do not judge me too hard.

## Tools

Here I am going to tell more about each component of the website to show how it all shaping up into the bigger picture.

### Haskell

Haskell has a very convenient library for static websites generation — [`Hakyll`][Hakyll]. In simple words, it is the web templating engine (similar to [Jekyll][jekyll]) based on [`pandoc`][pandoc] which is a universal file converter. This is an important point as it gives us a lot of flexibility with the formats to use. Moreover, it allows us to write our own preprocessors for the content in a straightforward way. I already have experience in implementing websites with Hakyll — check out [`Kowainik`][Kowainik] page, where I put a lot of efforts into its creation.

Hakyll is used to establish the rules of combining different pieces of the webpage together. Here is what I mean, with rules you can say how you would like the routes to be transformed, how to compile CSS files, what extensions of the files you what them to be translated to, how to apply different templates together etc.

Blog posts are written in markdown. Since `pandoc` supports the document's metadata, Hakyll heavily uses it for generating web pages from the `md` format. For example, the date of the blog post creation is stored inside the markdown file name and can be used in the blog post context as `$date$` variable. In the same manner, you can add your own contexts which will include some important information for each piece. Tags for blog posts are created using this feature. As the bonus `pandoc` provides us with the Table of Contents context as well.

Contexts are very powerful in Hakyll, they help you to write less boilerplate. I am going to demonstrate it in a small example. Let’s say you want to display the list of all your favourite movies on the page. You can just create the list by hands in your HTML file:

```html
<section class=”film row”>
    <div class=”col-3”>
         <img src=”/images/film1.png” alt=”Film 1”>
    </div>
    <div class=”col-9”>
        <a href=”https://my-favourite-film.com/1>Film 1</a>
    </div>
</section>
<section class=”film row”>
    <div class=”col-3”>
         <img src=”/images/film2.png” alt=”Film 2”>
    </div>
    <div class=”col-9”>
        <a href=”https://my-favourite-film.com/1>Film 2</a>
    </div>
<section>
    ...
```

This list can be very boring to fill in, most probably you’d copy the previous section and change some names and links when you want to add another entry. This is not interesting. And the refactoring is not easy when you need to change style — you need to change the same part in every element manually. But with Hakyll you can write:

```
 $for(myFilms)$
      <section class=”film row”>
        <div class=”col-3”>
            <img src=”/images/$filmImage$.png” alt=”$filmName$”>
        </div>
        <div class=”col-9”>
            <a href=”https://my-favourite-film.com/$filmLink$>$filmName$</a>
        </div>
    </section>
$endfor$

```

It feels better. And this is not difficult to achieve. You can create the data type with the necessary fields, create the list of the elements of this type and using [`listField`](http://hackage.haskell.org/package/hakyll-4.12.5.0/docs/Hakyll-Web-Template-Context.html#v:listField) function from the `Hakyll` create the context.
See the actual example from my website source code:

* [Experience Context](https://github.com/vrom911/vrom911.github.io/blob/develop/src/Website/Experience.hs)

There are a lot of other interesting elements of the Hakyll and Pandoc, probably I will cover the most useful tricks I know later in some dedicated blog posts. For the moment I just want to highlight, that this combination is a very powerful tool of the static website projects, and I would strongly advise to give it a shot when you decide to create your own page or blog. Feel free to reach out to meif you have any questions about aiming anything with Hakyll.

### HTML/CSS/JS

This is one of the hardest parts of the project for me, as it requires a lot of time for creating and implementing every page view.

I’ll start with the additional frameworks that are used for the project:

* [`bootstrap-4.0`](https://getbootstrap.com/) – for CSS
* [`font awesome`](https://fontawesome.com/) – for icons
* [`highlight.js`](https://highlightjs.org/) – for syntax highlighting (though I created the code theme by my own).
* [`jquery`](https://jquery.com/) – for some page scrolling effects
* [`processing.js`][pjs] – for Processing visual elements (See more details in the following section)

As I am not proficient with HTML and CSS I find its syntax very excess. I would rather write it all with some [Haskell][clay] [DSL][lucid] [written for these purposes][blaze], but in this case, I would lose the ability of on-the-fly page update and result refresh, as Haskell should be recompiled each time I make a small typo fix in the page, or change the font size in the CSS. I also could even write it in Elm, but it is a bit overengineering for a static website. And as a bonus, Hakyll has [integration][hakyll-sass] for SASS/LESS/SCSS preprocessors that also work on-the-fly.

As I mentioned before I’m heavily using the `pandoc`’s templating system to move out the similar parts in HTML files, as well as metadata and contexts to reduce the need for HTML boilerplate creation.

### Processing

Probably you noticed the animated navigation buttons, or some small arts, or at least logo at this website – well, this all is done with [Processing][Processing]. Processing is the language for the generative art creation. I am not going to talk a lot about its features or any other implementation details, there are plenty of materials, books, examples with crazy stuff done via Processing.

If you check the project structure you can see `pde` folder – these are all files I’m using to show animations and arts on the page. In order to make drawing compatible with the HTML pages, I’m using [`ProcessingJS`][pjs] which provides the integration of the `.pde` files with the modern web interface. It uses `canvas` elements to visualize Processing code on the page.

You can wonder how I came up with this Processing stuff. I’m not an artist neither I am a person with a great design taste, but I really enjoy patterns. I could look at them for hours. All these interweaving lines and elegant figures fascinate me. So I decided to give a shot to the Processing course a long time ago. The language is very straightforward to create the patterns, but I must mention, that it’s not that simple. Looking very simple, the piece of the pattern can lead to difficult math calculations. For example, I needed to use [Bézier curve ](https://en.wikipedia.org/wiki/B%C3%A9zier_curve) definitions to create some elements on my webpage.

Here is just a random example of the generated art:

![Processing Pattern](https://user-images.githubusercontent.com/8126674/53868247-9a216b00-4030-11e9-80fb-995fb5fa7b27.png)

### Github deployment



I admire GitHub for giving us the ability to deploy personal static websites so easily. This reduced the required number of actions for publishing each new version of the website to running a single script just once! And the script itself can be written and maintained even by a person with no prior DevOps experience. This sounds amazing and it is very convenient for such projects as personal blogs etc.

To give the full picture here are checkpoints to deploy your own website right now:

1. Get yourself the repo at GitHub called `yourUserName.github.io`.
2. Create two branches:
   + `develop` – this is where all your code will go while you’re working
   + `main` – this is where the generated code for the website should go, so GitHub can deploy it.
3. Get your Hakyll website working as you want website to look like.
4. Commit.
5. Run the deployment script: `./scripts/deploy.hs “Initial creation”`.

Speaking about the deployment script, there is no magic in there. It’s a simple bash file which runs `Hakyll` executable to generate site content and commits it to the `main` branch. You can see how it’s implemented in here:

```bash
#!/usr/bin/env bash
set -eo pipefail

# Clean rebuild
cabal new-exec site rebuild

# Create deploy environment inside of .deploy directory
mkdir .deploy
cd .deploy
git init --initial-branch=main
git remote add origin git@github.com:vrom911/vrom911.github.io.git
git pull -r origin main

# Add built site files
rsync -a ../_site/ .
git add .
git commit -m "$1"
git push origin main

# Cleanup .deploy directory after a successful push
cd ..
rm -rf .deploy
```

## Conclusion

To summarize my experience with the personal website creation: well, the resulting product is not perfect, the development process is very hard, and the webpage doesn’t look like the ideal one in the end and maybe some people would hate it very badly, but these aspects are not the points of my writing. I intended to show that the person knowing so little can achieve the complete result and make stuff work the way one wants it to. So, do not wait for your dream webpage, go and make one!


[hs]: https://www.haskell.org/
[Processing]: https://processing.org/
[GP]: https://pages.github.com/
[Kowainik]: https://kowainik.github.io
[Hakyll]: https://jaspervdj.be/hakyll/
[pandoc]: https://pandoc.org/
[jekyll]: https://jekyllrb.com/
[pjs]: http://processingjs.org/
[hakyll-sass]: http://hackage.haskell.org/package/hakyll-sass
[clay]: http://fvisser.nl/clay/
[lucid]: http://hackage.haskell.org/package/lucid
[blaze]: https://jaspervdj.be/blaze/
