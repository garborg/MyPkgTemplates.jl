# MyPkgTemplates

Uses [PkgTemplates](https://github.com/invenia/PkgTemplates.jl) to create packages scaffolded my way.

[src/MyTemplate.jl](src/MyTemplate.jl) provides a decent overview of configuration options to `PkgTemplates.Template`s.

### Installation

```julia
# press ']' at an empty prompt in the julia repl to activate pkg mode, then:
add https://github.com/garborg/MyPkgTemplates.jl.git
```

### Usage

```julia
using MyPkgTemplates

t = MyPkgTemplates.template(
    parent_dir="~/code/dir",
    is_pkg=true,
    is_proprietary=true,
    owner="Yoyodyne, Inc.", # optionally override your git user.name as owner
    services=true, # should GitHub Actions, Travis, Codecov, etc. be included
    # Consider cross-platform testing, if doing anything cross-platform that's succeptible to os quirks
    platforms=(; linux=true, osx=false, windows=false, x64=true, x86=false, arm64=false),
    min_julia_version=v"1.6",
)

MyPkgTemplates.generate("MyPkg", t)
```
