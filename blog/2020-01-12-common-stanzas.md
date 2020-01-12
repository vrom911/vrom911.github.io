---
title: Common stanzas
description: This post is about one specific feature of Cabal (Haskell build tool) — common stanzas.
tags: haskell, cabal, build-tools, dhall
---

When creating a project in [Haskell](https://www.haskell.org) you *usually*
explicitly or implicitly deal with the `.cabal` files, no matter which build
tool you prefer. In this post, I would like to discuss one specific feature of
[Cabal][cabal] — [common stanzas][common-stanza], explain its mission and
demonstrate how it could be used, which problems it helps to avoid, and also
mention some widely used alternatives.

## Terminology

Before going into detail about the feature itself I think it could be useful to
speak a bit about the `cabal` configuration format, declare all the definitions
and explain the structure of the `.cabal` file, so everybody could follow what
common stanzas bring to the table. If you are using Cabal on a daily basis or
fairly proficient with the syntax and the concepts of Cabal, you can skip to the
next section. If you are not a frequent Cabal user, I think that this section
might be useful anyway as it is generally valuable to keep up with what you are
dealing with even if it is not apparent usage.

### What is the cabal file

In Haskell, you can play with your ideas directly in REPL using `ghci` or by
putting your code into a single file. You simply need to create a file with the
`.hs` extension, and then you can compile and run it with `ghc` and `runhaskell`
commands. However, when it comes to some bigger ideas, you want to create a
project to structure your code in a more modular way or to create a reusable
library. Project is not as elementary as a `.hs` file and to handle extra
complexity you need a build tool. For build tool to work correctly with your
project, there is a need to know some details about your code and goals for the
package beforehand. For those purposes, you are required to create a
`your-project-name.cabal` file (hereafter I will refer to such files as simply
`.cabal` files), which literally contains the technical description of your
project, including meta-information about it, dependencies, some other advanced
Haskell configurations and much more.

> ❗ __Note:__ you better name the Cabal file with the same name as the name of your
> package. It's not crucial for the Cabal (the tool), however, some of the
> dependent tools may not work without this restriction to be kept (e.g. Hackage
> won't let you upload such package).

> 💡 _Interesting fact:_ packages are not part of the Haskell language, rather they
> are a feature provided by the combination of Cabal and GHC (and several other
> Haskell implementations).

Let's talk a bit more concrete about the structure of the `cabal` file and its
application for your project.

### Cabal files structure

Most of the time you don't create the `.cabal` file from scratch. Using `init`
[commands](https://www.haskell.org/cabal/users-guide/developing-packages.html#using-cabal-init)
of the build tools (or some [programmes specialised on scaffolding](@github(kowainik):summoner)),
you can get a reasonable default project configuration, and all you have to do
is to modify it slightly as needed. Despite that, let's look into a detailed
view of the file to understand it better.

Cabal uses special syntax that is parsed by the `Cabal`
[library](@hackage:Cabal) and used by other build tools as well. The `.cabal`
file is divided into sections and each one of them consists of the fields with
name and value that are related to those sections semantically. The field name
(case insensitive) and the value (case sensitive) are separated by the `:`
symbol.

The full specification can be found here:

 * [Cabal format description](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-desc)

### General fields

The first section in the file is the general-purpose package describing part.
This section is also called ["package properties"](https://www.haskell.org/cabal/users-guide/developing-packages.html#package-properties).
It must always start with the field `cabal-version` in which you should specify
the version of Cabal format you're using in your package configuration:

```haskell
cabal-version:       3.0
```

This is important as the Cabal specification does change with the time and that
makes the version of the tool essential for parsing the file. The version number
you specify will affect both compatibility and behaviour.

Besides that, this section is the right place for properties like `name`,
`version`, `author`, some extra meta information sources, like `LICENSE`,
`README`, `CHANGELOG`, and many more that should be established once and for the
package as a whole.

### Stanzas

Aside from the basic package information, In your project, you can have:

 * [Libraries](https://www.haskell.org/cabal/users-guide/developing-packages.html#library)
   + Public library — external API that could be used by other projects.
   + Internal library — internal API only in the scope of your project.
 * [Executables](https://www.haskell.org/cabal/users-guide/developing-packages.html#executables)
   — a runnable standalone programme.
 * [Test suites](https://www.haskell.org/cabal/users-guide/developing-packages.html#test-suites)
   — runnable special executable for package tests.
 * [Benchmark suites](https://www.haskell.org/cabal/users-guide/developing-packages.html#benchmarks)
   — runnable special executable to compare the performance.
 * [Foreign libraries](https://www.haskell.org/cabal/users-guide/developing-packages.html#foreign-libraries)
   — system libraries.
 * [Configurations sections](https://www.haskell.org/cabal/users-guide/developing-packages.html#configurations)
   — the place to introduce all flags that can be included in other sections.
 * [Source repositories](https://www.haskell.org/cabal/users-guide/developing-packages.html#source-repositories)
   — source revision control repository for a package.
 * [Custom setup scripts](https://www.haskell.org/cabal/users-guide/developing-packages.html#custom-setup-scripts)
   — establish the way to work with custom `Setup.hs` files.

and all these elements in any number and combination. This is up to you to
select the suitable parts for your goal and glue them together in one project.
Each piece from the list above is called **stanza**.


> 💡 If you are curious about the word `stanza` as I was, it is a [literary term](@w:Stanza)
> that means a grouped set of lines within a poem. Thinking more about it, the
> word fits well with the arrangement of the `cabal` file's concept.

Every stanza is a separate section in the project's `cabal` file. Most of the
fields that could be used in stanzas are shared but there are some special ones
that could be used only in the stanzas they belong to.

### Why so much boilerplate

Each stanza has so many fields in common and most of the time the greatest part
of them is absolutely identical from stanza to stanza as it contains the common
rules you are establishing across the package.

It is usually fields like

 * `default-language` which is always set consistently in all stanzas to
   `Haskell2010` (or `Haskell98`)
 * `default-extensions` as most of the time you use pretty much the same
   extensions across the modules that can include such useful ones as
   `DeriveFunctor` and `GeneralizedNewtypeDeriving`
 * most of the `ghc-options`, as it is quite handy to have `-Wall` in the whole
   package
 * some `build-dependencies`, at least all the stanzas would share the same
   `base` dependency in most of the cases

Moreover, when you have more than one stanza of the same type they usually also
share lots of data. For instance, test suites can share a lot of dependencies,
options etc.

So, why do we need to repeat ourselves? Here is where `common stanzas` come in
handy. They form a new type of stanzas and have a particular goal in mind.

## Common Stanzas

Now when we have a uniform understanding of terms related to `.cabal` files like
`stanza`, `cabal fields` I will operate with them to explain the `common
stanzas` feature.

As I mentioned earlier, by design there are a lot of fields that can be used in
every stanza. As the values of these fields can intersect a lot we end up
writing a lot of identical (or similar) fields in each stanza. We are repeating
ourselves again and again, which can lead to a maintenance problem in the future
when we need to change all such common parts at once. The problem of the code
duplication is the fundamental problem of programming. Common stanzas feature is
one of the approaches towards that direction that is specific to the `.cabal`
file.

To summarise, common stanzas feature expands `.cabal` files format to allow
extracting common parts into a separate group, so a user can reuse it later in
other parts of the settings.

### Technical description

Common stanza is another type of stanzas that can contain the information to be
shared in other stanzas by manually including it in them.

At the moment common stanzas can include only _build information fields_ inside.
Here is the full list of the fields that can be used:

 * [build-depends](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-build-depends)
 * [other-modules](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-other-modules)
 * [hs-source-dirs](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-hs-source-dirs)
 * [default-extensions](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-default-extensions)
 * [other-extensions](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-other-extensions)
 * [build-tool-depends](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-build-tool-depends)
 * [buildable](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-buildable)
 * [ghc-options](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-ghc-options)
 * [ghc-prof-options](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-ghc-prof-options)
 * [ghc-shared-options](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-ghc-shared-options)
 * [includes](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-includes)
 * [install-includes](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-install-includes)
 * [include-dirs](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-include-dirs)
 * [c-sources](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-c-sources)
 * [cxx-sources](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-cxx-sources)
 * [asm-sources](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-asm-sources)
 * [cmm-sources](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-cmm-sources)
 * [js-sources](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-js-sources)
 * [extra-libraries](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-extra-libraries)
 * [extra-ghci-libraries](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-extra-ghci-libraries)
 * [extra-bundled-libraries](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-extra-bundled-libraries)
 * [extra-lib-dirs](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-extra-lib-dirs)
 * [cc-options](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-cc-options)
 * [cpp-options](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-cpp-options)
 * [cxx-options](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-cxx-options)
 * [cmm-options](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-cmm-options)
 * [asm-options](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-asm-options)
 * [ld-options](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-ld-options)
 * [pkgconfig-depends](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-pkgconfig-depends)
 * [frameworks](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-frameworks)
 * [extra-frameworks-dirs](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-extra-frameworks-dirs)
 * [mixins](https://www.haskell.org/cabal/users-guide/developing-packages.html#pkg-field-mixins)

### How to use

Common stanzas have to be defined before you can use it in other sections, so
the best place to put your common stanzas is after the general information and
before the first stanza of your package. Common stanza primarily is a stanza, so
it should be a section of the cabal file starting with the special keyword.

The syntax should be as follows: use the keyword `common` to indicate the
definition of the common stanza, give the meaningful name by which you will
refer to it in other stanzas, list all the necessary fields you want to include.

```haskell
common my-first-common-stanza
  build-depends:    base ^>= 4.13
```

When the common stanzas are ready, you need to specify them in the stanzas where
you want to include them. For that, you need to use the `import` field and the
name of the common stanza defined earlier.

```haskell
library
  import:        my-first-common-stanza
  build-depends: text ^>= 1.2.4.0
```

> ❗ __Important:__ the `import` of common stanzas must be the first thing in
> your stanza. If you are using conditionals, it should be the first thing in
> each case (if you need it in there), however, be aware that the feature works
> in conditionals starting with `Cabal-3.0`.

You can import any amount of common stanzas in one stanza. To do that you can
just separate all the names with commas (`,`).

Another important fact is that you can use common stanzas inside the common
stanzas by applying the same rules of common stanzas. So if you have the
following common stanzas:

```haskell
common common-base
  build-depends:    base ^>= 4.13

common common-options
  ghc-options:    -Wall

common common-import
  import:         common-base
  ghc-options:    -Wall
```
Then the two following library stanzas are going to be identical:

```haskell
library a
  import:   common-base, common-options

library b
  import:   common-import
```

### Compatibility

Common stanzas is a relatively new feature, which means you need to know when
you can use it depending on the compiler and the tool version you have in your
project.

Common stanzas were [first released](@github(haskell):cabal/pull/4751) in
`Cabal-2.2` (on Mar 8, 2018). `Stack` has started supporting this feature since
[v1.7.1](https://docs.haskellstack.org/en/v1.7.1/ChangeLog/) which was released
on Apr 28, 2018. As Stack uses `Cabal` library version tightened to the GHC
version of the corresponding LTS, for the `Stack` end-user these dates mean that
starting from the GHC-8.4.1 version. LTS 12.* or later you can include common
stanzas in your package.

## Common stanzas in action

For ~~entertaining~~learning purposes, let's take an ordinary cabal file, which
clearly needs some refactoring, and apply earlier common stanzas rules to
prettify the file.

> In order to highlight only the parts that really matter for readability, I
> will skip some information in the post's code snippets and replace it with
> `...` dots. However, worry not! I also created
> [a project on GitHub](@github(vrom911):common-stanzas-example) to reflect
> the process we are going to go through here. I will link to relevant files in
> the corresponding place.

Here is what we start with: the package with one library, one executable stanza
and two test suites.


```haskell
----------------------------------------------------------------------------
-- General package information
----------------------------------------------------------------------------
cabal-version:       2.2
name:                common-stanzas-example
version:             0.0.0.0
description:         Example project to demonstrate the common stanzas feature
...

----------------------------------------------------------------------------
-- Source repository set up
----------------------------------------------------------------------------
source-repository head
  type:                git
  location:            https://github.com/vrom911/common-stanzas-example.git

----------------------------------------------------------------------------
-- Library stanza
----------------------------------------------------------------------------
library
  hs-source-dirs:      src
  exposed-modules:     CommonStanzasExample
  build-depends:       base ^>= 4.13.0.0
  ghc-options:         -Wall
                       ...
  default-language:    Haskell2010
  default-extensions:  ConstraintKinds
                       ...

----------------------------------------------------------------------------
-- Executable stanza
----------------------------------------------------------------------------
executable common-stanzas-example
  hs-source-dirs:      app
  main-is:             Main.hs
  build-depends:       base ^>= 4.13.0.0
                     , common-stanzas-example
  ghc-options:         -Wall
                       -threaded
                       -rtsopts
                       -with-rtsopts=-N
                       ...
  default-language:    Haskell2010
  default-extensions:  ConstraintKinds
                       ...

----------------------------------------------------------------------------
-- Test suite # 1
----------------------------------------------------------------------------
test-suite test-suite-1
  type:                exitcode-stdio-1.0
  hs-source-dirs:      test
  main-is:             Spec1.hs
  build-depends:       base ^>= 4.13.0.0
                     , common-stanzas-example
                     , hedgehog ^>= 1.0
                     , hspec ^>= 2.7.1
  ghc-options:         -Wall
                       -threaded
                       -rtsopts
                       -with-rtsopts=-N
                       ...
  default-language:    Haskell2010
  default-extensions:  ConstraintKinds
                       ...

----------------------------------------------------------------------------
-- Test suite # 2
----------------------------------------------------------------------------
test-suite test-suite-2
  type:                exitcode-stdio-1.0
  hs-source-dirs:      test
  main-is:             Spec2.hs
  build-depends:       base ^>= 4.13.0.0
                     , common-stanzas-example
                     , hedgehog ^>= 1.0
                     , hspec ^>= 2.7.1
  ghc-options:         -Wall
                       -threaded
                       -rtsopts
                       -with-rtsopts=-N
                       ...
  default-language:    Haskell2010
  default-extensions:  ConstraintKinds
                       ...
```

> 💻 This `cabal` file can be found [here](@github(vrom911):common-stanzas-example/blob/e09a9bd585cf392d49f126965218387a3a1fd4e9/common-stanzas-example.cabal).

As this is a multi-stanzas package, it is expected that there are so many
duplicated fields among any of them. What first catches the eye is a lot of
repetition in `ghc-options`, `default-extensions`, and similar purpose fields,
that establish some common rules and settings of your whole package.

Let's extract them into a common stanza with the straight name `common-options`.

```haskell
common common-options
  build-depends:       base ^>= 4.13.0.0

  ghc-options:         -Wall
                       ...

  default-language:    Haskell2010
  default-extensions:  ConstraintKinds
                       ...
```

And we can import it in every stanza in order to remove repetition from them:

```haskell
----------------------------------------------------------------------------
-- Library stanza
----------------------------------------------------------------------------
library
  import:              common-options
  hs-source-dirs:      src
  exposed-modules:     CommonStanzasExample

----------------------------------------------------------------------------
-- Executable stanza
----------------------------------------------------------------------------
executable common-stanzas-example
  import:              common-options
  hs-source-dirs:      app
  main-is:             Main.hs
  build-depends:       common-stanzas-example
  ghc-options:         -threaded
                       -rtsopts
                       -with-rtsopts=-N

----------------------------------------------------------------------------
-- Test suite # 1
----------------------------------------------------------------------------
test-suite test-suite-1
  import:              common-options
  type:                exitcode-stdio-1.0
  hs-source-dirs:      test
  main-is:             Spec1.hs
  build-depends:       common-stanzas-example
                     , hedgehog ^>= 1.0
                     , hspec ^>= 2.7.1
  ghc-options:         -threaded
                       -rtsopts
                       -with-rtsopts=-N

----------------------------------------------------------------------------
-- Test suite # 2
----------------------------------------------------------------------------
test-suite test-suite-2
  import:              common-options
  type:                exitcode-stdio-1.0
  hs-source-dirs:      test
  main-is:             Spec2.hs
  build-depends:       base ^>= 4.13.0.0
                     , common-stanzas-example
                     , hedgehog ^>= 1.0
                     , hspec ^>= 2.7.1
  ghc-options:         -threaded
                       -rtsopts
                       -with-rtsopts=-N
```

> 💻 This transformation can be seen [in this commit](@github(vrom911):common-stanzas-example/commit/5fd93956166e9d82d085646ee0631614b6a97628).

But wait, I still see that test suites share some more common information which
can be isolated as well. For that, we can create another common stanza
`common-tests`.

```haskell
common common-tests
  import:              common-options
  hs-source-dirs:      test
  build-depends:       common-stanzas-example
                     , hedgehog ^>= 1.0
                     , hspec ^>= 2.7.1
  ghc-options:         -threaded
                       -rtsopts
                       -with-rtsopts=-N
```

This will reduce the test section to the minimum:

```haskell
test-suite test-suite-1
  import:              common-tests
  type:                exitcode-stdio-1.0
  main-is:             Spec1.hs

test-suite test-suite-2
  import:              common-tests
  type:                exitcode-stdio-1.0
  main-is:             Spec2.hs
```

> 💻 This transformation can be seen [in this commit](@github(vrom911):common-stanzas-example/commit/22956111a3292791fa70771c251ef4b5c7009a37).

Looks much cleaner now!

> ❗ __Note:__ you can object that I repeat `type` field in test stanzas and this
> is a good candidate for common stanzas, however, we should not forget that
> `type` is the special field and doesn't belong to build information fields
> that as we know are supposed to be used in common stanzas.

## Alternatives

Inability to share data in `cabal` files was a common and a bit annoying issue
for many people. So it is not a secret that some other hacks and tools were used
to overcome this difficulty before the feature was implemented. In this section,
I am going to highlight a few alternative means people have used (and some of
them still do) to segregate common parts.

> ❗ Note that I am not an expert in the further mentioned tools as I am not a
> frequent user of those. The examples I am showing are for demonstration
> purposes and could be not the most efficient or common way. For the advanced
> information about any further tools, you should question the official
> documentation.

### Hpack

[Hpack](@github(sol):hpack) is the tool which was created as an alternative to
Cabal format. `Hpack` is based on YAML which implies the YAML's native ability
of reusability. YAML has [anchors](http://yaml.org/spec/1.1/#anchor/syntax)
(`&`), [aliases](http://yaml.org/spec/1.1/#alias/syntax) (`*`) and
[merge keys](http://yaml.org/type/merge.html) (`<<`) to define fields which is
handy for sharing common parts of the code.

🕑 Example time! In order to provide the fairest comparison, we are going to write the example from the [Common stanzas in action](#common-stanzas-in-action) section and write it in the Hpack syntax. First, let's put `common-options` and `common-tests` into `common.yaml` file, that can be reused in the main `hpack`'s file.

> 💻 _Reminder:_ You can review this `cabal` file [here](@github(vrom911):common-stanzas-example/blob/e09a9bd585cf392d49f126965218387a3a1fd4e9/common-stanzas-example.cabal).

```yaml
# common.yaml
- &common-options
  dependencies:
    - name: base
      version: "^>= 4.13.0.0"
  ghc-options:
    - -Wall
    - ...

  default-extensions:
    - ConstraintKinds
    - ...

- &common-tests
  <<: *common-options

  source-dirs: test
  dependencies:
    - name: common-stanzas-example-hpack
    - name: hedgehog
      version: "^>= 1.0"
    - name: hspec
      version: "^>= 2.7.1"

  ghc-options:
    - -threaded
    - ...
```

In Hpack, an analogue of `your-package-name.cabal` is the `package.yaml` file.
It looks very similar to the `cabal` file by structure, though there are few
distinctions, different field names, or absence of some fields. Anyway,
isomorphic to our cabal file from the example, Hpack's file, that uses its
variation of `common stanzas`, can look like this:

```yaml
# package.yaml
_common: !include "common.yaml"

verbatim:
  cabal-version: 2.2
name: common-stanzas-example-hpack
version: '0.0.0.0'
description: "Example project to demonstrate the common stanzas feature"
...

github: vrom911/common-stanzas-example

# Including `common-options` to every stanza here.
<<: *common-options

library:
  source-dirs: src

executables:
  common-stanzas-example-hpack:
    source-dirs: app
    main: "Main.hs"

    dependencies:
      - name: "common-stanzas-example-hpack"

    ghc-options:
      - -threaded
      - -rtsopts
      - -with-rtsopts=-N

tests:
    test-suite-1-hpack:
      <<: *common-tests
      main: Spec1.hs
      other-modules: []

    test-suite-2-hpack:
      <<: *common-tests
      main: Spec2.hs
      other-modules: []
```

If you install `Hpack` and run `hpack` command on this `package.yaml` you will
see the generated `cabal` file. Luckily for you, I have already done that and
included it to the repository, so you can check that out immediately. I won't
include the whole code in the post as it looks pretty much similar to the
initial `cabal` file we had before moving to common stanzas.

> 💻 Hpack introduction and the generated `.cabal` file can be seen
> [in this commit](@github(vrom911):common-stanzas-example/commit/7aec6511e1c900fd944cf244d6d5898c560fc57e).

### Dhall-to-Cabal

Instead of writing you package information in Cabal syntax, another option is to
use [Dhall configurational language](https://dhall-lang.org/) to describe all
necessary information and then generate the `.cabal` file using
[dhall-to-cabal](https://github.com/dhall-lang/dhall-to-cabal) tool. Impressive!

Let's use the same old example and see how `Dhall` can help us with the `cabal`
information duplication reduction. For consistency sake, I will also create the
`common-options` and `common-tests` which are just variables in `Dhall`.


First of all, I "import" two preexisting Dhall modules that have all the needed
functionality for `cabal` syntax mimic. They are called `prelude` and `types`,
and wherever you see the `prelude.blah` or `types.blah` that means that I'm
calling the corresponding functions from there.

Along the way, I have also created a few additional and handy variables for
packages: `base`, `common-stanzas-example` and `executable-ghc-options`. And
finally, here is how Dhall `common-stanzas` could look like:

```dhall
let common-options =
    { compiler-options = prelude.defaults.CompilerOptions //
        { GHC = [ "-Wall", ...] : List Text
        }
    , default-extensions =
        [ types.Extension.ConstraintKinds True
        , ...
        ]
    , default-language = Some types.Language.Haskell2010
    }

let common-tests = common-options //
    { hs-source-dirs = [ "test" ]
    , build-depends =
         [ base
         , common-stanzas-example
         , { package = "hedgehog"
           , bounds = prelude.majorBoundVersion (prelude.v "1.0")
           }
         , ...
         ]
    , compiler-options = executable-ghc-options
    }
```

I am using Dhall's records merge operation `//` and list concatenation `#` to
update and collapse common information with the specific to stanzas data, as the
whole `.cabal` file info is just a record in Dhall. Here are specific fields of
the record just to show the usage of the common stanzas. To see the valid Dhall
code, please refer to the `common-stanzas-example.dhall` file in the repository.

```dhall
-- Library stanza
library = Some
  ( λ(config : types.Config) →
  prelude.defaults.Library // common-options //
      { build-depends = [ base ]
      , hs-source-dirs = [ "src" ]
      , exposed-modules = [ "CommonStanzasExample" ]
      }
  )

-- Executable stanza
executables =
  [ { name = "common-stanzas-example"
    , executable = λ(config : types.Config) →
      prelude.defaults.Executable // common-options //
          { hs-source-dirs = [ "app" ]
          , main-is = "Main.hs"
          , build-depends =
              [ base
              , common-stanzas-example
              ]
          , compiler-options = executable-ghc-options
          }
    }
  ]

-- Test suite # 1
test-suites =
  [ { name = "test-suite-1"
    , test-suite = λ(config : types.Config) →
      prelude.defaults.TestSuite // common-tests //
          { type = types.TestType.exitcode-stdio { main-is = "Spec1.hs" }
          , hs-source-dirs = [ "test" ]
          }
    }
...
```

When we have an efficient Dhall file in our hands we can use `dhall-to-cabal` to
create the `.cabal` file to make sure that this is still the same Cabal file we
had in the beginning:

```shell
dhall-to-cabal common-stanzas-example.dhall
```

> 💻 As always, I have already created one for you. And check this commit to see the described work: [Dhall commit](@github(vrom911):common-stanzas-example/commit/7aec6511e1c900fd944cf244d6d5898c560fc57e).

## Real-world examples

In this section, to fixate the understanding, I want to show a few examples of
common stanzas in the wild.

1. A basic example, showing how to use the same version of `base`, extensions
   and GHC flags across all stanzas:
   * [kowainik/tomland common stanza](@github(kowainik):tomland/blob/d9b7a1dc344e41466788fe00d0ea016f04629ade/tomland.cabal#L46-L71)
2. A similar example, but more complicated with the usage of mixin for custom
   prelude [relude]():
   * [kowainik/summoner common stanza](@github(kowainik):summoner/blob/60de4f2f087e5bd2beaad9253e7eded731cfbaaf/summoner-cli/summoner.cabal#L48-L80)
3. An example of using several common stanzas:
   * [kowainik/co-log common stanzas](@github(kowainik):co-log/blob/e9e475b3f64f58d015d1bcde055729534286a9a9/co-log/co-log.cabal#L33-L67)

## Conclusion

Common stanzas is a useful, long-awaited feature that is very easy to integrate
into your project today. With this post, I wanted to share how satisfying it
could be to cut out all your shared parts and make your project `.cabal` file
less verbose and easy to maintain. Despite the fact that this feature seems
obvious to me, I don't see it as often as I expected it to be in the wild. That
motivated me to create this post with some examples as the addition to the
official docs (not the replacement though).

If you still have any questions about the feature, or you have noticed that I am
missing something important that can help others to understand common stanzas
better, please contact me without hesitation.


[cabal]: https://www.haskell.org/cabal/
[common-stanza]: https://www.haskell.org/cabal/users-guide/developing-packages.html#common-stanzas
