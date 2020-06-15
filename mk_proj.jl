"""
# Overview

Assumes use of GitHub.
Turns on free-for-open-source services if `!is_proprietary`.
Turns on GitHub services and marks all rights reserved by owner if `is_proprietary`.
Sets up testing to look for *_test.jl files within src directory.
"""

# TODO: [Develop](https://invenia.github.io/PkgTemplates.jl/dev/user/#PkgTemplates.Develop)
# TODO: [Consider giving test its own project](https://invenia.github.io/PkgTemplates.jl/dev/user/#PkgTemplates.Tests)
# TODO: [Benchmark](https://github.com/invenia/PkgTemplates.jl/issues/86)
# TODO: [Hooks](https://github.com/invenia/PkgTemplates.jl/issues/11)

### Config

parent_dir = "~/src/github/garborg"
is_pkg = true
is_proprietary = false
overriding_owner = "Yoyodyne, Inc."::Union{Nothing,String}
# If meant for broad distribution, add cross-platform testing
platforms = (; linux=true, osx=false, windows=false, x64=true, x86=false, arm64=false)
# If meant for broad distribution, consider LTS (1.0) support
min_julia_version = v"1.4" 

### end Config

# Templating

using PkgTemplates
using MyPkgTemplates

test_arm = platforms.arm64
@assert !is_proprietary || !test_arm

gh_platforms = (; filter(kv -> first(kv) != :arm64, pairs(platforms))...)

@info """The GitHub Actions 'Documentation' job will not trigger gh-pages deploys until you
(having admin rights) have manually pushed to the created 'gh-pages' branch at least once."""

plugins = [
    Git(; manifest=!is_pkg, ssh=true),
    Documenter{GitHubActions}(),
    GitHubActions(; gh_platforms...),
    Tests(; file=TestsInSrc.TEMPLATE_PATH, project=false)
]

if test_arm
    # n.b. In addition to TravisCI, DroneCI also supports arm64 (and more) and is also free for open source projects
    push!(plugins, TravisCI(;
        osx=false,
        windows=false,
        x64=false,
        arm64=true,
        coverage=false,
    ))
end

if is_proprietary
    push!(plugins, License(; path=AllRightsReserved.TEMPLATE_PATH))
else
    push!(plugins, Codecov())
end

kwargs = overriding_owner === nothing ? () : (:authors => [overriding_owner],)
t = Template(;
    dir=parent_dir,
    plugins=plugins,
    julia=min_julia_version,
    kwargs...
)
