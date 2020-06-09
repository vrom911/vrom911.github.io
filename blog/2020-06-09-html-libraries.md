---
title: Choosing an HTML library in Haskell
description: The post contains a brief description and comparison of the three particular Haskell HTML generating libraries.
tags: haskell, library, html
---

Recently I was on the lookout for a Haskell HTML rendering library. I was
surprised by the number of great and yet so different packages in the
assortment. It was tough to choose among them though, so I decided to quickly
write this post with my evaluation of all libraries I tried. I hope my notes can
be helpful for other seekers like me.

The post contains a brief description and comparison of the three particular
Haskell HTML generating libraries that I personally used in my project while
deciding on the best fit. Besides, this text documents the decision-making
process which is actually a really helpful practice, I can recommend everyone
taking such notes for recording your decisions.

To understand the pros and cons of each library described in this post, no HTML
knowledge is required. Moreover, I myself can not be considered an HTML expert.
Just pure Haskell familiarity is enough.

## Use case

To make the libraries comparison fairer, I want to share my use case on which I
built the library choice decision. It is definitely the key part here, as every
mentioned library has its strengths and weaknesses, and it is always important
to understand first what is needed for your particular problem in order to bring
benefits to the whole project.

The problem I was trying to solve with the HTML generation library is for a
really cool project [ChShersh](https://kodimensional.dev/) and I are working on
at the moment.

In our case, we need to generate a small HTML report file based on the output
data of our tool's work. We have several conditions we want the desired library
to satisfy.

* First of all, the HTML generation (in runtime) should be fast, as we want to
  produce the result in no time.
* Secondly, the code responsible for the resulting HTML should be easily
  maintainable, testable and readable, especially keeping in mind that only
  Haskellers are working on it, not professionals in HTML.
* In the perfect world, it should not bring the dependencies overhead, as users
  are going to build our tool from sources as well. For that purpose, we need to
  leave the dependencies trace light and the compilation time reasonable enough.

These are the basic criteria we want the solution to have.

In this post, we are going to look more closely at three particular libraries:
`type-of-html`, `blaze-html` and `mustache`. However, there are much more
libraries in the wild. This choice was initially made based only on our use case
and how promising candidates look for the particular problem. Please, take all
further comparison with the given specific use-case in mind as well. I would
probably go with another option if my requirements were different.

## type-of-html

__Source:__ [knupfer/type-of-html](@github)

__Documentation:__ [type-of-html](@hackage)

__Description:__ library for generating HTML in a highly performant, modular and
type-safe manner. This library makes most invalid HTML documents compile-time
errors and uses advanced type-level features to realise compile-time
computations.

### Concepts of the library:

The core of the library is that the HTML elements are represented on the type
level. This approach helps to compose them with each other and perform
compile-time analysis of the resulting composition. Each HTML part you write is
a Haskell value with the type-level information on what is inside.

### Pros

1. A purely Haskell backend person can __smoothly switch to writing frontend__
   now! And they won't complain about it, as the pretty attractive design in
   terms of Haskell is quite straightforward.
2. No surprises, the killer feature of this library is __Type-safety__. And that
   could be really helpful. The library kindly points out your semantical
   mistakes in HTML. For example, you won't be able to confuse table rows and
   table columns by a silly mistake:

   _HTML:_
   ```html
   <td><tr></tr><tr></tr></td>
   ```

   _Code:_
   ```haskell
   td_ (tr_ "a" # tr_ "b")
   ```

   _Error:_
   ```
   ('Tr is not a valid child of 'Td)
   ```

   Moreover, you won't be able to put any block elements into inline ones and
   get weird results, your code just won't compile: `<p> anyBlockElemInside </p>`
3. Very __fast HTML generation__. This is the part where implementation on types
   pays off. See these benchmarking numbers
   [here](https://github.com/knupfer/type-of-html#performance).
   It was possible to achieve such results due to the type-level compiler features
   and optimizations.
4. __Compiler optimizations:__ I decided to move it into a separate point as
   this is the kind of optimizations that are sometimes helpful to the user code
   (for example, inlining nested empty `div`s).
5. __HTML5 support.__ I would not state that it is fully supported as I didn't
   find this information, but from what I saw the library provides all elements,
   tags and attributes that could be needed for an average task.
6. Different __rendering functions__ for your needs. Works with `Builder` that
   could make it really fast if you need to manipulate with HTML later. Also
   escaping is provided by default.
7. The library is __lightweight__, specifically, it depends only on boot
   libraries + the `double-conversion` library which itself depends on boot
   libraries only.

### Cons

1. __Compilation time__. This is the most noticeable downside for me and my old
   laptop :( Due to the heavy type-level abuse plus the inability to annotate
   type signatures (see the next point), the compilation time is drastically
   increased. Also, remember the compiler optimizations I was describing in the
   Pros previously? Guess what, they can hit you from the other side too. They
   affect compile-time as well, and sacrificing the optimizations at all doesn't
   work for me in my project.
2. I gave up pretty quickly on functions top-level type signatures, as it is
   just __impossible to write type signatures__. It is a big deal due to the
   range of data types of different complexity we are using in the project. Some
   type signatures are the only way to tell the compiler the type of the element
   (e.g. phantom parameters). So, in a blink of an eye, I found myself turning
   on `{-# OPTIONS_GHC -Wno-missing-signatures #-}` (and my inner Haskeller
   crying inside). The explanation is simple if you understand the nature of the
   library: every single element, tag, etc. is represented in its type. So if
   you write

   ```html
   <div class="link"><a href="#foo">Foo</a></div>
   ```

   It all is going to be in your type:

   ```haskell
   (:@:)
       'Div ('ClassA := [Char])
           ((:@:) 'A ('HrefA := [Char]) [Char])
   ```

   > 🤯 _Disclaimer:_ Do NOT try to imagine the type of an intermediate HTML
   > document at home.
3. You __won't be able to use `OverloadedStrings`__, sorry. This is related to
   the previous point. Such limitation is not only annoying but also is creating
   some troubles due to the fact that we are using some other libraries that use
   polymorphic types.
4. Because of the type-safety, some really __hacky tricks__ are needed to __fool
   the compiler__. Yes, to fool the compiler, that is definitely needed.

   Let's do some type puzzles starting with the simple one. What if you need to have
   some element only on condition? In `if` conditional statements you should
   have the same types in both cases, but how to do that if types depend on what
   is inside the HTML? The solution here is to use `Maybe` (this solution is
   actually described in the README)

   ```haskell
   if p then Just (p_ "Tada!") else Nothing
   ```

   The other tricky example which we actually spend some time on solving is the
   following: based on some given `Maybe` you have to return one `li` (list)
   element on `Nothing`, or a bunch of `li`s based on the `Just` value. The
   first thought is using Haskell `list []` for that. But, actually, that won't
   work if you need to return different `li` elements in the list:

   ```haskell
   -- WRONG!
   [ li_ "foo"
   , li_ ("foo" # strong "bar")
   ]
   ```

   These elements can not be in one list as they have different types!
   So lists are a no-go in here, and the cleverer trick is to use `Either`. As
   the HTML elements are easily composable with the `#` operator of the library,
   we can return `Left` or `Right` in the described case. And, as you can
   imagine, the tricks are becoming more involved when you need to handle more
   than two different cases and introduce some deeply nested logic.

5. Most of the time __compiler errors are not helpful__ at all and appear in the
   wrong place rather than the real problem. Check this one out:

   <img width="1105" alt="Screenshot 2020-06-09 at 13 37 31" src="https://user-images.githubusercontent.com/8126674/84194474-f9bcc080-aa94-11ea-857f-8a6b6415628e.png">

   See this picture of 1/1000 of the error lines about types mismatch.
   To clarify, I used polymorphic string on the line ~150 in a separate
   function, and I get absolutely not relevant error on the line 84 that says
   something about HashSet, which could be really confusing.
6. It is impossible to move common parts in separate functions sometimes. Type
   inference strikes again. As it could not infer the polymorphic enough type,
   it would fail as soon as you would use it inside one scope with the different
   types.

### Summary

`type-of-html` is a nice, fast, safe and clever library. It will pay off if you
need a lot of HTML generation on the fly. However, it is not working out well
for small, standalone, one-time generation projects and trade-offs are too high.

##### My usage comments

The library was quite easy to integrate, I was able to see results almost
straight away (no need for a long set-up). I was confused first with the issues
with types when `OverloadedStrings` were on. Documentation status is good. But I
was sometimes spending and wasting a lot of time on error messages that knocked
me down and distracted from the real errors in code.

## blaze

__Source:__ [jaspervdj/blaze-html](@github)

__Documentation:__  [blaze-html](@hackage)

__Description:__ A blazingly fast HTML combinator library for the Haskell
programming language. It embeds HTML templates in Haskell code for optimal
efficiency and composability.

### Concepts of the library

In the centre of this library is the Monadical HTML type that allows you to
compose elements really smoothly. By virtue of helpful type-classes and handy
instances, it is quite straightforward to compose elements and use the library
as an eDSL.

### Pros

1. The library is __lightweight__ in a similar way to `types-of-html`. It
   depends on boot or very lightweight libraries.
2. Blaze states that it is _blazingly_ __fast__. And you can see it by the
   benchmarks provided [here](https://jaspervdj.be/blaze/benchmarks.html).
   Even though it concedes to the previous library, it is still sufficiently
   swift.
3. `Blaze` provides an extremely __Composable__ API, including composable
   attributes additionally to elements.
4. It allows to __factor out code__ easily, to __refactor__ and generally
   __maintain__ the source code in a healthy way. Neat for writing complicated
   functions
5. Owing to a nice eDSL, it is easy to __read code__ for both back and front
   developers.
6. `blaze` takes advantage of the __`OverloadedStrings`__ extension, so you can
   comfortably operate with any type of the string you have in your project
   without any additional overhead.
7. __Maturity__ of the library is a plus as well. It also provides full support
   of __HTML5__ (and additionally HTML4 in case you need it).
8. In addition to the great support of elements, the library also provides an
   __extensible interface__ for the tricky stuff you have in mind.
9. Different rendering functions. Works with Lazy `ByteString`.
10. There is a way to create __Haskell code from HTML__, which is not compulsory
    but a pleasant bonus.

### Cons

1. When converting text values to HTML, you need to call `toHtml` function
   explicitly in different places.
2. Less type-safe than `type-of-html` analogue. You won't see little helping
   errors like: "the semantic is wrong, you really don't want to put this `div`
   inside of the `span` here".
3. And some nitpicking. As all attributes work with the special `AttributeValue`
   type (not `String` or `Text`), the only way sometimes to specify this value
   is by using its `IsString` instance. However, as we have `Text` almost
   everywhere, we need to use `fromString . toString` composition everywhere.

   For example:

   ```haskell
   a ! A.href (fromString $ toString $ "#" <> myText) $ ...
   ```

### Summary

The library is very easy to handle for any level of Haskell developers. I think
that it is suitable for both small and big HTML generation purposes. It is
flexible in the use cases. Also, it doesn't have such an impact on your
compile-time, and small changes don't require the complete recompilation (which
is handy during the development).

##### My usage comments

The library was quite easy to integrate, it also does not require any long and
boring set up, and you can see results in no time. I was transitioning my ready
Haskell HTML code written in `type-of-html` and what I noticed is that the code
became much cleaner. The ability to combine `$` and parentheses frees your hands
makes you more flexible on code alignment. Also, some opportunities for the code
factoring out were unblocked (which were impossible due to type inference issues
with `type-of-html`).

## mustache

__Source:__ [JustusAdam/mustache](@github)

__Documentation:__ [mustache](@hackage)

__Description:__ Allows parsing and rendering template files with mustache
markup. See the mustache
[language reference](http://mustache.github.io/mustache.5.html).

### Concepts of the library

This library is very different from the previous two candidates as it is
conceptually not the HTML library, strictly speaking. It is based on the
templating system with the separate syntax for manipulating data in the given
template. And this template could be anything, including the HTML page.


As this is not the ultimate comparison of all Haskell HTML libraries, but rather
the experience report on the tool search for the concrete issue resolution, I
think that it is fair to include the first candidate we had in mind for the
task.

### Pros

1. __Not 100% Haskell__, therefore, it has a lesser entry barrier for those with
   more HTML experience and less Haskell experience.
2. The library is __easy to adopt__ if you were using the plain HTML and now
   want to do something more sophisticated.
3. Good for multiple usages in one go: when you need to read the template one
   time and substitute it with the different variables.
4. The format has a nice feature of the __templates combining__, that helps to
   arrange lots of HTML in a tidy and comfortable way.
5. You can change HTML parts in the template and __rerender HTML immediately__
   without waiting for the compilation to finish.

### Cons

1. __Not 100% Haskell__, therefore requires more wide knowledge of the stack, in
   our case HTML knowledge.
2. The library does not provide any `Generic` mechanics, so it forces you to
   write quite __a lot of boilerplate__.
3. There is __no type-safety__ and runtime guarantee. Runtime errors are sadly
   possible. And there is a chance that the template won't be rendered as
   expected (could miss some values).
4. In most of the cases, you need on-the-fly files reading and template
   matching. This leads to too many __error-prone__ places to watch out.
5. The __abilities are limited by the `mustache` format__, not Haskell
   capabilities. This means that you could quickly get short on flexibility on
   factoring out, etc.
6. `mustache` is the new and maybe not-familiar format. This creates a
   __learning curve__ which could require an __investment of time__.
7. The Haskell library is __not lightweight__ and depends on a lot of huge
   libraries in order to provide instances.
8. I personally noticed the __lack of documentation on the templating part__.
   For example, by only looking at the library I could not make it work, which
   is the indicator that it could be improved a bit. Luckily, I found somewhere
   else the code that was using the `object` function that helped me to use some
   primitive values in templates.

### Summary

The library is an example of a nicely done markup language API implementation in
Haskell.
I already have the experience of working with the library in production before,
so it has proven itself to be mature enough and production-ready. Though the
previous use-case was very different (we were composing user emails).

In the first place, I was looking at using `mustache` because `criterion` –
Haskell benchmarking library – is using templates for their HTML report
creations. However, soon enough I realised how different the use cases are.
Though `mustache` fits perfectly to the `criterion` workflow that is usually
used as a library, not as an external tool, it is not giving us enough
flexibility and advantages, if we want to distribute our tool as a single
binary.

##### My usage comments

It is not that straightforward to start using the library. It also requires a
lot of set-ups beforehand: you need to create the template, write down the
template reading function, recover from errors, etc. The documentation does a
poor job of explaining how to start with the library from A to Z. HTML is not
what I write that frequently, so I didn't feel comfortable to work with that. As
nobody, who is going to maintain the code, doesn't have such skills as well,
this was a downside for us.

Besides, the library requires to write a lot of
not-so-type-safe boilerplate. The tool we are working at is WIP and changes
frequently, which means that we would need to maintain the boilerplate as well,
and it is a bit of overhead. Another sign was the runtime exceptions we should
take care of. As I highlighted, it should work smoothly on users machines, and
with that in mind, we should somehow have a way to provide all the template
files and handle cases with file and other `IO` Exceptions that can happen on
users' machines.

## Conclusion

You saw that all the mentioned libraries are so different and yet each of them
has its own place to shine. I have tasted all of the above libraries, and even
though I am a huge fan of type-safety-for-the-best-experience, in my case the
most type-safe solution wasn't the best. We decided to stick to `blaze-html`,
and it is working like a charm so far. My laptop (which is really old, but still
has it!) is really grateful for this decision. It died during compilation few
times when I was working with `type-of-html` as it requires really hardcore type
inference from the compiler at _EVERY_ small change.

In the end, my advice would be to watch out the cons and consider the pros,
projecting it on your use case, and be okay with giving up additional
type-safety when it is not crucial.

> Note again, I truly enjoyed all the tested libraries. I think that developers
> and maintainers are doing a great job there, and I want to say thank you all
> for your time and hard work! 💖
