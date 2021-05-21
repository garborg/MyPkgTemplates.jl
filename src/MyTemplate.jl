module MyTemplate

# TODO: [Develop](https://invenia.github.io/PkgTemplates.jl/dev/user/#PkgTemplates.Develop)
# TODO: [Consider giving test its own project](https://invenia.github.io/PkgTemplates.jl/dev/user/#PkgTemplates.Tests)
# TODO: [Benchmark](https://github.com/invenia/PkgTemplates.jl/issues/86)
# TODO: [Hooks](https://github.com/invenia/PkgTemplates.jl/issues/11)

using PkgTemplates: Codecov, Documenter, Git, GitHubActions, License, Template, Tests, TravisCI

import ..FlexibleLicense
import ..TestsInSrc

"""
    template(kwargs...)

PkgTemplate templates the way I configure 'em.

Assumes use of GitHub.
Turns on free-for-open-source services if `!is_proprietary`.
Turns on GitHub services and marks all rights reserved by owner if `is_proprietary`.
Sets up testing to look for *_test.jl files within src directory.
"""
function template(;
    parent_dir::String,
    is_pkg::Bool,
    is_proprietary::Bool,
    owner::Union{Nothing,String}=nothing,
    min_julia_version::VersionNumber=v"1.6",
    platforms=(; linux=true, osx=false, windows=false, x64=true, x86=false, arm64=false),
)
    test_arm = platforms.arm64
    @assert !is_proprietary || !test_arm

    gh_platforms = (; filter(kv -> first(kv) != :arm64, pairs(platforms))...)

    @info """The GitHub Actions 'Documentation' job will not trigger gh-pages deploys until you
    (having admin rights) have manually pushed to the created 'gh-pages' branch at least once."""

    # TODO: "UNLICENSED" or "Proprietary"?
    license_name = is_proprietary ? "UNLICENSED" : "MIT"

    plugins = Any[
        Git(; manifest=!is_pkg, ssh=true),
        Documenter{GitHubActions}(),
        GitHubActions(; gh_platforms...),
        !License,
        FlexibleLicense(; owner, name=license_name),
        Tests(; file=TestsInSrc.TEMPLATE_PATH, project=false),
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

    if !is_proprietary
        push!(plugins, Codecov())
    end

    Template(;
        dir=parent_dir,
        plugins=plugins,
        julia=min_julia_version,
    )
end

end # module
