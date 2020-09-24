---
title: Haskell Aliases
description: The collection of the Haskell build tools command aliases that optimise my workflows.
tags: haskell, build tools
---

I know from experience that building average-sized Haskell projects could be
frustrating to watch and wait to terminate.

![](/images/blog/haskell-aliases/waiting-haskell-build.jpg)

To be more productive and not waste that much time on Twitter while waiting for
packages to complete building, or not to spend hours investigating obvious
mistakes, I am usually trying to optimise my commands to my local usage. I can
spend my time better, and get more fruitful results in less time, so I am using
some specific options to assist with that. But memorising all of them and typing
out each time is a tedious task. So, I have created lots of different aliases
for various build-tool commands and forgot about this problem for a while.

I was collecting and refining proper command options through years, and here I
want to share them with you, so you can also use them on a daily basis, or give
me a few pieces of advice on how I can improve my workflows even further.

> To copy-paste all the mentioned commands in a usable straightaway form, go to
> the [final section](#copy-pasteable) of the post.

## Cabal

Most of the time, I am using [the Cabal build tool](https://www.haskell.org/cabal/)
locally to manage my builds, tests, execution and other Haskell project-specific
things. So let's start with these commands.

> Note: all commands assume that you have `cabal-install` version at least 3.0
> installed
> (the version that doesn't require `new-` or `v2-` prefixes in your command, as
> it already defaults to that. You may require prefixes for other earlier
> versions).

With Cabal, from time to time you need to know some additional things that are
not enabled by default, to make it work the best for you. And the specific parts
of the documentation are not always that easy to discover.

For example, I had some hard times understanding how to make my tests execute
with plainly the `cabal test` command. Sometimes it doesn't build and run tests.
Turned out that some of the design choices made in the more latest versions were
affecting the behaviour of this command. The solution to that was either to add
the `tests: true` into the `cabal.project` file, or specify a special CLI flag:

```haskell
cabal test --enable-tests
```

![](/images/blog/haskell-aliases/tom-begging.jpg)


So, let's get started with my simple Cabal aliases.

> Here and later I will share some lines from my `~/.zshrc` file. You can add
> the same code into your `~/.bashrc` or similar config file that you use.

As I said, I use Cabal for the Haskell project building. For the compiler
versioning management (I use [GHC](https://www.haskell.org/ghc/)), I am using
the wonderful [`ghcup` tool](https://www.haskell.org/ghcup/), which has a lot of
useful features such as installation/uninstallation of GHC versions, cabal
upgrade, etc., and as from just recently it even helps with the IDE
integrations.

First, I need to make sure that I have all the tools and necessary storages in
`PATH`:

```
export PATH="$PATH:$HOME/.local/bin:$HOME/.ghcup/bin"
```

#### Build

The build command I use the most looks like this:

```bash
alias cbuild="cabal build
    --enable-tests
    --enable-benchmarks
    --write-ghc-environment-files=always
    -O0"
```

And I simply execute `$ cbuild` (or `$ cbuild all` for multi-library/package
projects) a lot.

The command also builds the `test` and `benchmark` stanzas altogether.

I personally don't experience any issues with the GHC environment files, so I
create them by default with the `--write-ghc-environment-files=always` option.
On the contrary, this option saves me when I am working with `doctest`.
`doctest` requires having environment files in order to function properly.
Otherwise, it produces weird errors, which is not that easy to resolve and spot
the problem of the _env_ files in there:

```haskell
src/Relude/Container/Reexport.hs:45:1: error:
Could not find module ‘Data.HashSet’
Use -v (or `:set -v` in ghci) to see a list of the files searched for.
   |
45 | import Data.HashSet (HashSet)
   | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Test suite relude-doctest: FAIL
```

> You may notice the
> [`-O0` GHC option](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/using-optimisation.html#ghc-flag--O0)
> in all my commands, which turns off all the optimisations produced by GHC. I
> recommend to use it only locally in order to speed up build times. However, in
> some cases, it could drastically decrease runtimes or can lead to an erroneous
> behaviour. So be mindful of when you want to apply that. But if you do want to
> build without optimizations, make sure to add the `-O0` option to each command
> that builds your project. Otherwise, you will observe the rebuilds of your
> Haskell packages due to changed optimizations scheme.

I also often use even more optimised building commands specifically for my
Hakyll projects. As I do not own a powerful laptop, sometimes it is too hard for
it to build such projects so that it freezes, and I need to restart it again and
again. So I use the `cbuild` command in the following way:

```shell
$ cbuild -j1
```

Eventually, I got tired of the inability to work on my laptop when I need to
build the website projects, so I
[fixed all the dependencies](https://github.com/vrom911/vrom911.github.io/blob/106e692d5d42928ac3a4ab0af370e20a0e17074e/cabal.project.freeze)
with the `cabal freeze` command. At the moment, my website project is built
instantly.

#### Test

I already told the story about the `cabal test` command. So here is what I am
using currently to build and run tests:

```bash
alias ctest="cabal test
    --enable-tests
    --test-show-details=direct
    -O0"
```

I was lacking the colourful, streaming testing output before, but I was given
the advice to use the `--test-show-details=direct` option which helps with that.

Below you can see the default output of the `cabal test` command, running on a
package with multiple test suites without using the `--test-show-details` flag:

```haskell
Running 1 test suites...
Test suite relude-test: RUNNING...
Test suite relude-test: PASS
Test suite logged to:
/Users/relude/dist-newstyle/build/x86_64-osx/ghc-8.8.3/relude-0.7.0.0/t/relude-test/test/relude-0.7.0.0-relude-test.log
1 of 1 test suites (1 of 1 test cases) passed.
Running 1 test suites...
Test suite relude-doctest: RUNNING...
Loaded package environment from /Users/relude/.ghc.environment.x86_64-darwin-8.8.3
Loaded package environment from /Users/relude/.ghc.environment.x86_64-darwin-8.8.3
Test suite relude-doctest: PASS
Test suite logged to:
/Users/relude/dist-newstyle/build/x86_64-osx/ghc-8.8.3/relude-0.7.0.0/t/relude-doctest/test/relude-0.7.0.0-relude-doctest.log
1 of 1 test suites (1 of 1 test cases) passed.
```

As you see it is hard to get something concrete from here.

But even with this option on, I still miss the clear final result of tests
(passed or failed). This is especially valuable when you have multiple test
stanzas and run them all together. It would be helpful to have the visually
highlighted result and a summary conclusion of all suites at the end of the
output.

#### Benchmark

The benchmarks running command is a really straightforward one. Nothing fancy,
just good old `x --enable-x`:

```bash
alias cbench="cabal bench
    --enable-benchmarks
    -O0"
```

#### Run

The running command is quite innocent and added only for the sake of consistency
of my commands:

```bash
alias crun="cabal run -O0"
```

This command builds the package first and then runs a specified executable. If
you have only one executable in your package, you can avoid specifying its name,
and `crun` will choose it unambiguously.

#### Install

I also have the `cinstall` command to install Haskell tools easily, but before
going into details, here are a few thoughts and warnings about the "install" in
Haskell.

<u>__Do not install libraries globally!__</u> Like, *never*. It is never ever needed
with modern Cabal.

I often see people experiencing weird and annoying issues due to the fact they
have installed globally some packages that are used as a dependency in their
project. And when people ask anything about `install` command my immediate
reaction would be: "DO NOT do that".

Don't get me wrong, I am not against the command per se, I use it too! My
concern is about a very often misuse of the installation process, which messes
up with the global environment and leads to incorrect plan construction, which
could make completely valid dependencies version plans invalid.

Of course, I wouldn't be completely honest if I won't specify situations in
which I do install myself, and these are completely reasonable use-cases for
installation:

* Installation of the tools from Hackage that are not going to be used as
  dependencies, e.g. `HLint`, `stylish-haskell`, `stan`.
* Installation of the local tools that you are developing. Though I have some
  concerns about this one, and personally I use `build` + `cp` the executable
  into my `.local/bin` folder, as in some cases, local installation could break
  some things.

In all other cases, try to avoid the `install` command.

Now, after the huge and noticeable disclaimer, it is safe to share the
`cinstall` command itself:

```bash
alias cinstall="cabal install
    --installdir=/home/USERNAME/.local/bin
    --overwrite-policy=always
    --install-method=copy"
```

And you can use it like this, to install Haskell tools:

```shell
$ cinstall stylish-haskell
```

#### REPL

Another common thing I use all the time is the `crepl` command which runs the
Haskell REPL (GHCi) with some pre-configured stuff for me. I am usually using
REPL for debugging some functions, etc. So I want to have the `pretty-simple`
package in scope in order to print data types nicely and get more out of the
REPL debugging. I use `pretty-simple` as it is a neat library that can output
any data types in the nice formatted way, which is exactly what I need to
visually inspect the data during inspections.

In my global `~/.ghc/ghci.conf` config I have the following line:

```haskell
:set -interactive-print=Text.Pretty.Simple.pPrint
```

And I bring `pretty-simple` into each invocation of REPL using the following
alias:

```bash
alias crepl="cabal repl --build-depends pretty-simple"
```

And I can utilise this command on its own, or with some other options specified.
For example, if I need to add more packages into the scope and use them from
insider GHCi, I can run it like this:

```shell
$ crepl -b aeson -b text
```

#### Documentation and Hackage

I care a lot about good documentation in my packages, so I check it locally
whenever I introduce a new Haddock description.

To produce documentation, I simply run the `cdoc` command defined as follows:

```bash
alias cdoc="cabal haddock --enable-documentation"
```

I am also a Hackage maintainer, with lots of packages that I need to keep my eye
on. To ease the process of the Hackage library release workflow,
[Dmitrii](https://kodimensional.dev) and I came up with a few useful aliases and
bash functions for that:

```bash
alias cdist="cabal sdist"

function cupload() {
    cabal upload "$1" -u vrom911
}

alias cdochackage="cabal haddock --enable-documentation --haddock-for-hackage"

function cupload-doc() {
    cabal upload -d "$1" --publish -u vrom911
}
```

In short, I first create a tarball of the package to upload to Hackage, then I
upload it. Then to check the candidate and publish if everything looks okay.

We also prefer to manually build the documentation that could go on Hackage, as
there are usually some issues with that on the service. Doing it by hands is
easy and creates the docs available at Hackage immediately. The procedure is the
same: create tarball + upload it to Hackage.

#### Other meta

From time to time I need to update my local Hackage index database in order to
get access to the newer versions of the packages. This is my `cupdate`:

```bash
alias cupdate="cabal update"
```

And, of course, in the life of every Haskell engineer comes the moment where you
have to clean up messed-up `dist` and `dist-newstyle` folders — meta information
created by Cabal and used for builds:

```bash
alias cclean="cabal clean"
```

## Stack

Let's now see some aliases for another Haskell build tool —
[Stack](https://docs.haskellstack.org/en/stable/README/). To tell you the truth,
I am not that frequent user of Stack recently, though I was one before.
Nevertheless, I still tend to check that any project I am working at is
buildable with both build tools Cabal and Stack. Usually, I have CI checking the
build with Stack each time and use it myself only sometimes.

But yet, I have go-to aliases, that help in situations, where you are starting
to forget the best ways of using the tool.

So, first of all, I have the autocompletion available for me:

```bash
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"
```

> The first two lines are `zsh` specific, `bash` users may only need the last
> line.

And I have two types of the build:

* A standard one:

    ```bash
    alias sbuild="stack build
        -j 2
        --test
        --bench
        --no-run-tests
        --no-run-benchmarks"
    ```
* A fast one:

    ```bash
    alias fbuild="stack build
        --fast
        -j 2
        --test
        --bench
        --no-run-tests
        --no-run-benchmarks"
    ```

I am also very happy to see the Stack feature of the output colouring
customization. Though I am not using it a lot currently, I tried to play with it
once, and if you a more frequent Stack user than I am, I recommend to
[check it out as well](https://docs.haskellstack.org/en/stable/yaml_configuration/#stack-colors).

I do not have any other stack aliases, basically because most of the commands I
use work quite well out of the box for me, e.g.

```shell
$ stack test
```

So, I do not create any aliases, as it is not required to keep any additional
options or tricks in mind for that.

## Copy-pasteable

To summarise all that I described, here are all the mentioned settings put
together, so you can easily copy-paste it and use them for your needs.

```bash
# Haskell
export PATH="$PATH:$HOME/.local/bin:$HOME/.ghcup/bin"

# Cabal

alias cbuild="cabal build --enable-tests --enable-benchmarks --write-ghc-environment-files=always -O0"
alias ctest="cabal test --enable-tests --test-show-details=direct -O0"
alias cbench="cabal bench --enable-benchmarks -O0"
alias crun="cabal run -O0"
alias cinstall="cabal install --installdir=/home/USERNAME/.local/bin --overwrite-policy=always --install-method=copy"
alias cclean="cabal clean"
alias cupdate="cabal update"
alias crepl="cabal repl --build-depends pretty-simple"
alias cdoc="cabal haddock --enable-documentation"
alias cdochackage="cabal haddock --enable-documentation --haddock-for-hackage"
alias cdist="cabal sdist"

function cupload() {
    cabal upload "$1" -u vrom911
}

function cupload-doc() {
    cabal upload -d "$1" --publish -u vrom911
}

# Stack

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"

alias sbuild="stack build        -j 2 --test --bench --no-run-tests --no-run-benchmarks"
alias fbuild="stack build --fast -j 2 --test --bench --no-run-tests --no-run-benchmarks"
```

Bon appétit!
