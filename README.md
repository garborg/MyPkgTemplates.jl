# MyPkgTemplates

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://garborg.github.io/MyPkgTemplates.jl/stable)
[![Latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://garborg.github.io/MyPkgTemplates.jl/latest)
[![Build Status](https://travis-ci.com/garborg/MyPkgTemplates.jl.svg?branch=master)](https://travis-ci.com/garborg/MyPkgTemplates.jl)
[![Codecov](https://codecov.io/gh/garborg/MyPkgTemplates.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/garborg/MyPkgTemplates.jl)
[![Coveralls](https://coveralls.io/repos/github/garborg/MyPkgTemplates.jl/badge.svg?branch=master)](https://coveralls.io/github/garborg/MyPkgTemplates.jl?branch=master)

Uses [PkgTemplates](https://github.com/invenia/PkgTemplates.jl) to create packages with basic scaffolding.
Provides two package template generators, one for private repos and one for public repos. See [src/plugin](src/plugin) for examples of creating custom plugins for `PkgTemplates`.

### Installation

```julia
# press ']' at an empty prompt in the julia repl to activate pkg mode, then:
add https://github.com/garborg/MyPkgTemplates.jl.git
```

### Usage

```julia
using MyPkgTemplates
t = MyPkgTemplates.public()
MyPkgTemplates.generate("MyPublicPkg", t)
```

or

```julia
using MyPkgTemplates
t = MyPkgTemplates.private(
    host="bitbucket.org"
    owner="Acme Corporation"
)
MyPkgTemplates.generate("MyPrivatePkg", t)
```
