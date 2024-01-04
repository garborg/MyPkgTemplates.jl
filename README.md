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
# Create template.
# See `MyPkgTemplates.{pkg,app,scratch}` -- with scenario-specific defaults for terse template generation.
t = MyPkgTemplates.template(
    dir="~/code/dir",
    is_pkg=true,
    is_proprietary=true,
    owner="Yoyodyne, Inc.", # optionally override your git user.name as owner
    services=true, # should GitHub Actions, Codecov, etc. be included
    min_julia_version=v"1.6",
)

# Generate package
t("MyPkg.jl")
```
