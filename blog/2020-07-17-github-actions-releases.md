---
title: Haskell binaries release with GitHub Actions
description: How to create Haskell releases with binary assets using a simple GitHub Actions workflow.
tags: haskell, github, github-actions
---

If you are using the [GitHub](https://github.com/) platform for your projects, then you
probably have already heard of [GitHub Actions](@gh(features):actions)
Continuous Integration (CI) available there out of the box. This is relatively
new and yet already a popular and quite convenient way to set up your workflows
as well. In case you did not have the chance to play with it, but would love to
give it a try with your Haskell projects, there is the
[blog post by Dmitrii](https://kodimensional.dev/github-actions) that can help
with that.

However, CI is not the only use case for GitHub Actions. In this post, I would
like to share the workflow that allows creating releases at GitHub with the
build binaries (ready executable files) for your Haskell tools.

## Why binary?

When it comes to Haskell tools distribution, the most common option is usually
to install whatever you want from [Hackage](https://hackage.haskell.org/) or
[Stackage](https://www.stackage.org/). That is when the package is available
there. If it is not the recommended way is to clone the project and build &
install it locally.

This is not enough for several reasons. First of all, it assumes that the person
who would use your tool should know at least a little bit of Haskell. And
secondly, they should have some Haskell build tool installed on the machine they
would like to use it on. Both of the assumptions could be false simultaneously.

For those reasons, there is the third distribution way – providing binaries. In
that case, the user is capable of installing your tool wherever they want
without any additional effort by downloading a file and putting it under the
convenient location.

## What we want

Now when we understand why the binaries release could be useful, let's first
discuss what the workflow should do for us.

As soon as the tag with the `v*`-like name is created, the workflow should be
triggered and start producing binaries. It should create a draft release at
GitHub and upload built assets of the specified operating system and maybe GHC
version. This is an overall goal. But let's get into more detail on the
low-level plan.

The workflow has two separate jobs:

1. To create a draft release with the given name that is linked to the tag that
   triggered the event.
2. To build the requested binaries, strip them (and maybe do more) and then
   upload to the created already draft release

With that in mind see the overall picture of the process schematically
illustrated at the following image:

![GitHub Actions Release Workflow](https://user-images.githubusercontent.com/8126674/87802363-00371880-c849-11ea-82c7-81681bc02206.png)

Now as we have a plan, we can deep down to its internals.

## Create a release

This job is quite straightforward. It requires three easy steps each of which is
accomplished with the existing GitHub action:

 1. Check out the project. Here we use [actions/checkout](@gh) – the standard
    action that gives the workflow access to the repository it is working with.
    It also creates you the workspace where you would be able to do whatever you
    want during this workflow (but only permitted things).
 2. Create a release. Here we use [actions/create-release](@gh) – the standard
    action that creates the release at GitHub. This action has some
    configurations that you can tune to your needs. We are making a draft
    release with the `Release TAG_NAME` title.
 3. Write the release URL into the file in the shared workspace. This is needed
    due to the fact that the jobs can not share the outputs, so we write it down
    to read later as we would need to know where to upload artifacts. Here we
    use [actions/upload-artifact](@gh) – the action that is used to share some
    data via uploads.

## Create binaries

After the release is created by the previous job, we want to upload binaries to
it. For that, first, we should create a build strategy. What we can specify is
the matrix of environment settings used for each asset build: operating systems,
GHC versions, Cabal versions, any other data you find important at this point.
Due to the specifics of the projects I initially created the workflow for (it is
[Stan](@gh(kowainik):stan), we have 3 platforms and 2 GHC versions in our matrix
and we also excluded the windows for one of the GHC versions which gives us 3 x
2 - 1 = 5 assets in total.

For each matrix item the following steps are taken:

1. Checkout code. See the first step in the previous job. This gives us access
   to the same workspace.
2.  Set up a Haskell environment. Here we use [actions/setup-haskell](@gh) to
    have GHC and Cabal available for the next steps.
3. Freeze and Restore cache. First we `cabal freeze` the dependencies and cache
   that instead, so we could have the cached dependencies not build if no
   versions were changed. We are using [actions/cache](@gh) for caching.
4. Build the executable. We specify the directory where to install the
   executable in order to easy access to that folder:
   `cabal install exe:stan --install-method=copy --overwrite-policy=always --installdir=dist`
5. *[Windows specific]* Add the `.exe` suffix to the binary.
6. Set the path to the executable into the `BINARY_PATH` environment variable.
   We know exactly where it is, as we specified it earlier.
7. Strip the binary. The Haskell exe could be very heavy, it never hurts to
   light it a bit.
8. Read the URL of the release using the created file with it during the
   previous job. We use [actions/download-artifact](@gh) – action to get files.
9. Upload the asset With the help of [actions/upload-release-asset](@gh) – the
   action that actually uploads our binary to the release by the given URL. You
   can also set the names the way you want it to be.

## Example of the total Action workflow

And to summarise all the detailed explanation here is an example script that can
also be found in the
[Stan repository on GitHub](@gh(kowainik):stan/blob/7088f13c1b3c081e1b2375ddf00a7f9e9c7f535c/.github/workflows/release.yml).

> 📦 The example release itself is also available in the
> [Stan releases](@gh(kowainik):stan/releases/tag/v0.0.1.0).

```yaml
name: Release

on:
  # Trigger the workflow on the new 'v*' tag created
  push:
    tags:
      - "v*"

jobs:
  create_release:
    name: Create Github Release
    runs-on: ubuntu-latest
    steps:
      - name: Check out code
        uses: actions/checkout@v2

      - name: Create Release
        id: create_release
        uses: actions/create-release@v1.1.1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github.ref }}
          draft: true
          prerelease: false

      - name: Output Release URL File
        run: echo "${{ steps.create_release.outputs.upload_url }}" > release_url.txt
      - name: Save Release URL File for publish
        uses: actions/upload-artifact@v1
        with:
          name: release_url
          path: release_url.txt

  build_artifact:
    needs: [create_release]
    name: ${{ matrix.os }}/GHC ${{ matrix.ghc }}/${{ github.ref }}
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macOS-latest, windows-latest]
        ghc:
          - "8.8.3"
          - "8.10.1"
        cabal: ["3.2"]
        exclude:
          - os: windows-latest
            ghc: 8.8.3

    steps:
      - name: Check out code
        uses: actions/checkout@v2

      - name: Set tag name
        uses: olegtarasov/get-tag@v2
        id: tag
        with:
          tagRegex: "v(.*)"
          tagRegexGroup: 1

      - name: Setup Haskell
        uses: actions/setup-haskell@v1.1.1
        id: setup-haskell-cabal
        with:
          ghc-version: ${{ matrix.ghc }}
          cabal-version: ${{ matrix.cabal }}

      - name: Freeze
        run: |
          cabal freeze

      - name: Cache ~/.cabal/store
        uses: actions/cache@v1
        with:
          path: ${{ steps.setup-haskell-cabal.outputs.cabal-store }}
          key: ${{ runner.os }}-${{ matrix.ghc }}-${{ hashFiles('cabal.project.freeze') }}

      - name: Build binary
        run: |
          mkdir dist
          cabal install exe:stan --install-method=copy --overwrite-policy=always --installdir=dist

      - if: matrix.os == 'windows-latest'
        name: Set extension to .exe on Windows
        run: echo "::set-env name=EXT::.exe"

      - name: Set binary path name
        run: echo "::set-env name=BINARY_PATH::./dist/stan${{ env.EXT }}"

      - name: Strip binary
        run: strip ${{ env.BINARY_PATH }}

      - name: Load Release URL File from release job
        uses: actions/download-artifact@v1
        with:
          name: release_url

      - name: Get Release File Name & Upload URL
        id: get_release_info
        run: |
          echo "::set-output name=upload_url::$(cat release_url/release_url.txt)"

      - name: Upload Release Asset
        id: upload-release-asset
        uses: actions/upload-release-asset@v1.0.1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ steps.get_release_info.outputs.upload_url }}
          asset_path: ${{ env.BINARY_PATH }}
          asset_name: stan-${{ steps.tag.outputs.tag }}-${{ runner.os }}-ghc-${{ matrix.ghc }}${{ env.EXT }}
          asset_content_type: application/octet-stream
```

## What is next?

To conclude this write up, I would like to mention that while being
straightforward and flexible, the workflow has some space for improvements. Here
are at least a few things that we are planning to upgrade in there:

- [ ] Statically linked binaries
- [ ] Use [`upx`](https://upx.github.io/) for compressing binaries even further
- [ ] Create a workflow template for producing releases
- [ ] Add support of this feature to [Summoner](@gh(kowainik):summoner)) —
      Haskell scaffolding tool

## Acknowledgement

I want to thank [Dmitrii Kovanikov](https://kodimensional.dev/) for his kindness
and patience when sharing with me his knowledge about GitHub Actions. You are
the best!
