---
title: Write yourself a lens
description: Where I describe the process of implementing basic lens functions.
tags: haskell, lens
---

## Introduction

Recently I have been working on implementing basic lens ideas in the
[`relude`][relude] custom prelude library. The process was very valuable for me
and I feel that now I understand lens concepts better when I encountered their
internals. That motivated me to create this brief post to share my experience
and describe what I learned from that adventure.

> Note, that this is neither a tutorial nor the official documentation of the
> [`lens`][lens] package. I've put relevant links at the bottom of the post for
> those who are interested in reading more on this topic.

### Why lenses in the custom prelude

This is a very reasonable question. And I see more than one reason to do that.

* Sooner or later in your application, you will need to use some lenses and for
  that, you have to add a dependency to your `.cabal` file. And if you decide to
  use `lens` it is quite a fat dependency. Even if you decide to use `microlens`
  – a much lighter alternative to `lens` and fully compatible with it – it is
  still an extra dependency. Libraries themselves might expose lens-compatible
  interface without depending on any lens packages due to the magic behind lens
  (explained later in the post).
* Most of the time you need very basic lens operators: a setter, a getter and
  the composition of different lenses.
* Sometimes you want to just play with lenses without doing any extra
  configuration steps.

These are reasons to want lenses within touch, but as maintainers of a
lightweight alternative prelude, we don’t want to impose any lens packages on
our users. This brings us to the decision of implementing our own lenses inside
`relude`.

### How it should work

`relude` encourages users enthusiasm and eagerness to explore. That’s why
`relude` uses the approach with the [`Extra.*` modules](@github(kowainik):relude/tree/master/src/Relude/Extra) which
are not exported by default, so it is quite easy to bring something new and let
users decide whether to use it or not without spoiling the global namespace.
This method is also applied to the implementation of `lens`. To use lenses from
`relude` you can just add the following import:

```haskell
import Relude.Extra.Lens
```

Moreover, this approach doesn't spoil your project that already has a dependency
on the `lens` or `microlens` library, you just don’t export this extra module.

Besides, there is another cool bonus. The fact that `Lens'` is a type alias
gives us the compatibility with the `lens` package itself. This means that
`Lens'` from `relude` is absolutely the same type that `Lens'` from `lens` or
`microlens` package. So, if later you decide to migrate to one of the libraries,
all that you need to do is to add the required library to the dependencies list
and change the `import` to the corresponding module name of the chosen library.
All functions would work as expected without any breakages.

## What is lens

I am not going to bring up the complicated definition with some theory-category
terms. In simple words, lens is a combination of data getters and setters. If
lens would be defined as a data type it could look like this:


```haskell
data Lens' s a = Lens'
    { view :: s -> a
    , set  :: s -> a -> s
    }

```

However, the real implementation uses a smarter representation that will be
described in the following section.

## Implementing lens

I want to clarify that I didn't come to this implementation on my own. Lenses is
the topic I eventually bumped up into from time to time, so I had the intuition
in which direction I should move to solve this puzzle.


> Note, that we would examine the `Lens' s a` type here instead of the `Lens s t
> a b`. In fact, most of the time you don’t need the latter one, so it’s fair to
> operate with `Lens'`. Moreover, `Lens'` is the special case of `Lens` which
> you can see from the definition:
>
> ```haskell
> type Lens' s a = Lens s s a a
> ```

First of all, let's look at the type we would work with. Here is the definition:

```haskell
type Lens' s a = forall f. Functor f => (a -> f a) -> s -> f s
           │ │
           │ └──── the type of the value inside of the structure
           │
           └───── the type of the whole structure
```

The striking part in the definition is the `forall` on the right side. This is
actually a crucial moment. The ability to use any `Functor` there gives the
power to choose the proper one at the right moment to achieve our goals. This is
going to be our strategy in writing functions and operators.

But first, let's implement a helper function that creates lenses for our data
types. It should, by given getter and setter functions, construct the required
lens. Let's write down the type:

```haskell
lens :: (s -> a) -> (s -> a -> s) -> Lens' s a
```

After expanding the definition of the  `Lens'` type alias we get:

```haskell
lens :: (Functor f) => (s -> a) -> (s -> a -> s) -> (a -> f a) -> s -> f s
lens getter setter f s = ...
```

Let's get to the implementation. If we write down the variables on the left
side, we can see how we can get the value of type `f s` from all that we have.

We can start from the easy part: take `s` as it's the only constant we have.
Using `getter` we can get `a` from `s`. By applying the `f` function we can
construct a value of type `f a` from `a` and here we can use `setter` to get `f s`
from. Sounds awful, but this is how you usually deal with functions: just
apply them in the right order to get the result you need. Step by step:

```haskell
s                         :: s
getter s                  :: a
f (getter s)              :: f a
setter s                  :: a -> s
(<$>)                     :: (a -> s) -> f a -> f s
setter s <$> f (getter s) :: f s
```

Putting this all together we get:

```haskell
lens getter setter f s = setter s <$> f (getter s)
```

Great! Now we have a helper to build our own lenses.

The next step is to implement a getter function. In `lens` terminology it is
called `view`. By given lens and the whole data type, it should return the
smaller type. We can express this in type signature this way:

```haskell
view :: Lens' s a -> s -> a
```

The initial step of solving this one is to understand what the final result we
expect and what tools we have to achieve that. The final result is clear – it is
the smaller part of the whole data type not wrapped into any functor. Speaking
about tools, let's have a look at the `Lens'` data type again:

```haskell
type Lens' s a = forall f. Functor f => (a -> f a) -> s -> f s
```

You can see that the final result produced by the work of the `Lens'` is the
object wrapped into some functor. And here comes the fun part I was talking
about earlier. Because this Functor is not fixed, we have the power to choose
the one that suits us the most. Okay, we actually need the functor that won't
change the object at all and will just return a value. Let's look at the
standard [Functor instances in the base library][functor] to choose the most
suitable instance. Recall, that we are implementing the getter, so name
[`Const`](@hackage:base-4.12.0.0/docs/Data-Functor-Const.html#t:Const)
sounds good in these conditions. Let's check it out:

```haskell
newtype Const a b = Const { getConst :: a }

instance Functor (Const m) where
    fmap _ (Const v) = Const v
```

Looks like we can use it! Let's try. We need a function of type `a -> Const a a`.
This is just a constructor of `Const`. Also, we need to remember to unwrap
it in the end because the lens gives us `Const s`. And the `getConst` function
returns us the type `a`:

```haskell
view :: Lens' s a -> s -> a
view l s = getConst $ l Const s
```

It compiles! We will check how it all works in the following section.

Now it is time for the setter. `set` function should take the lens, the new
value and the whole object and return the renewed object with the specified
field changed. As usual, let's start with writing down the type signature:

```haskell
set :: Lens' s a -> a -> s -> s
```

We are already experienced in implementing functions that work with lens and
know that it is all about choosing the correct functor. This time we actually
want to change the value inside the functor and to return the whole data not
wrapped into anything. Let's check [the list][functor] again. Aha, look what I
found:
[Identity](@hackage:base-4.12.0.0/docs/Data-Functor-Identity.html#t:Identity)


```haskell
newtype Identity a = Identity { runIdentity :: a }

instance Functor Identity where
    fmap f (Identity x) = Identity $ f x
```

It seems that it suits our case. We just need to create a function of type
`a -> Identity a`. At first glance, it seems like we can just use the `Identity`
constructor:

```haskell
-- WRONG IMPLEMENTATION!!!
set l a s = runIdentity $ l Identity s
```

But wait, we are not using a variable with name `a` at all! This is suspicious,
taking into consideration the goal that this function is pursuing. We want the
value of the type `a` to be changed to the given one. So we need to somehow
change the `a` value, no matter what the value it had before. Sounds like the
[`const`](@hackage:base-4.12.0.0/docs/Prelude.html#v:const)
function:

```haskell
set l a s = runIdentity $ l (const (Identity a)) s
```

We are going to verify later that this implementation is actually correct.


> **Exercise:** try to implement the `over` function which has the type:
> ```haskell
> over :: Lens' s a -> (a -> a) -> s -> s
> ```


When using lenses you deal with the operators most of the time. So let's
introduce the operator forms of the functions above for the sake of convenience:

```haskell
-- view
infixr 4 ^.
(^.) :: s -> Lens' s a -> a
-- set
infixr 4 .~
(.~) :: Lens' s a -> a -> s -> s
```

We are ready to go! Now we can see how it all works in the following paragraph.

## Using lens

In this section, I want to show that all that we wrote above works and try to
reason about _how_ it works and why it makes sense.

There is no point in using lenses if you don't have data. So, let's start by
creating the definitions for data types:


```haskell
data Haskeller = Haskeller
    { haskellerName       :: Text
    , haskellerExperience :: Int
    , haskellerKnowledge  :: Knowledge
    } deriving (Show)

data Knowledge = Knowledge
    { kSyntax         :: Bool
    , kMonads         :: Bool
    , kLens           :: Bool
    , kTypeLevelMagic :: Bool
    , kNix            :: Bool
    } deriving (Show)
```

And I’m going to create a sample data.

```haskell
me :: Haskeller
me = Haskeller
    { haskellerName = "Veronika"
    , haskellerExperience = 2
    , haskellerKnowledge = Knowledge
        { kSyntax = True
        , kMonads = True
        , kLens = True
        , kTypeLevelMagic = True
        , kNix = False
        }
    }
```

Everything is settled, we can create the lenses and test how our `lens` function
works:

```haskell
nameL :: Lens' Haskeller Text
nameL = lens getter setter
  where
    getter :: Haskeller -> Text
    getter = haskellerName

    setter :: Haskeller -> Text -> Haskeller
    setter h newName = h { haskellerName = newName }
```

Using the same approach we can create other lenses:

```haskell
experienseL :: Lens' Haskeller Int
knowledgeL  :: Lens' Haskeller Knowledge
```

Let's assume that we have lenses for the `Knowledge` data type as well.

```haskell
syntaxL, monadsL, lensL, typeLevelMagicL, nixL
    :: Lens' Knowledge Bool
```

Then we can use the composition property of the lenses and create the one for
nested fields:


```haskell
kLensL :: Lens' Haskeller Bool
kLensL = knowledgeL . lensL
```

As we now have lenses to work with, I can't wait to try them. The first step is
to get the name from the data type.

```haskell
ghci> me ^. nameL
"Veronika"
```

If you want to access fields of nested data structures, you can create a
separate lens by composing existing ones, or you can compose them on-the-fly:

```haskell
ghci> me ^. kLensL
True
ghci> me ^. knowledgeL . lensL
True
```

No extra parenthesis required due to properly chosen operator precedence.

Let's look closer and try to understand what is going on using the
[equational reasoning][er] approach

```haskell
  me ^. nameL
= view nameL me
-- using definition of `view`
-- view l s = getConst $ l Const s
= getConst $ nameL Const me
-- using definition of `nameL`
= getConst $ (lens haskellerName (\h n -> h {haskellerName = n})) Const me
-- using definition of `lens`
-- lens getter setter = \f s -> setter s <$> f (getter s)
= getConst $ (\n -> me {haskellerName = n}) <$> Const (haskellerName me)
-- applying `haskellerName` function
= getConst $ (\n -> me {haskellerName = n}) <$> Const "Veronika"
-- using Functor instance for Const
-- instance Functor (Const m) where fmap _ (Const v) = Const v
= getConst $ Const "Veronika"
= "Veronika"
```

After we convinced ourselves that getter part of lens works as expected, we can
try to change the value through lenses:

```haskell
ghci> me & nameL .~ "vrom911"
Haskeller { haskellerName = "vrom911", ... }
```

To give the context of how it works, check out the type of
[`&`](@hackage:base-4.12.0.0/docs/Data-Function.html#v:-38-)
operator:


```haskell
(&) :: a -> (a -> b) -> b
```

And then the whole picture:

```haskell
me                      :: Haskeller
nameL                   :: Lens' Haskeller Text
(&)                     :: Haskeller -> (Haskeller ->  Haskeller) -> Haskeller
(.~)                    :: Lens' Haskeller Text -> Text -> Haskeller -> Haskeller
nameL .~ "vrom911"      :: Haskeller -> Haskeller
me & nameL .~ "vrom911" :: Haskeller
```

The good thing about operators, you can easily compose them:

```haskell
ghci> me
    & nameL .~ "somebody else"
    & experienceL .~ 42
    & knowledgeL . nixL .~ True
```

> **Exercise:** try to use the [equational reasoning][er] technique to see how the
> `set` function works. Take `set nameL “newName” me` as the starting point.



## Conclusion

Apparently, the `lens` package itself is much deeper than the above
implementation. So, if you are interested in more details, you can spend a few
days meditating on the original code in there. The goal of this writing was to
help you to start your adventure into the magical forest of lenses and to get
more prepared for the real lenses.

That's all I wanted to share, I hope, that you understand lenses a bit better
now

```haskell
you & kLensL .~ True
```

## Links

As promised, some links:

* [relude: Lens Hackage page](@hackage:relude-0.5.0/docs/Relude-Extra-Lens.html)
* [relude: Lens source code](@github(kowainik):relude/blob/master/src/Relude/Extra/Lens.hs)
* [`lens` package][lens]
* [`microlens` package](@hackage:microlens)
* [lens tutorial](@hackage:lens-tutorial-1.0.3/docs/Control-Lens-Tutorial.html)
* [School of Haskell lens tutorial](https://www.schoolofhaskell.com/school/to-infinity-and-beyond/pick-of-the-week/a-little-lens-starter-tutorial)
* [Wiki Lenses](https://en.wikibooks.org/wiki/Haskell/Lenses_and_functional_references)
* [Lens over tea](https://artyom.me/lens-over-tea-1)
* [Equational reasoning][er]

[relude]: https://github.com/kowainik/relude
[lens]: http://hackage.haskell.org/package/lens
[functor]: https://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html#t:Functor
[er]: http://www.haskellforall.com/2013/12/equational-reasoning.html
