module MyTemplate

using PkgTemplates: Codecov, CompatHelper, Dependabot, Documenter, Git, GitHubActions, License, TagBot, Template, Tests

import ..FlexibleLicense
import ..TestsInSrc

"""
    template(kwargs...)

PkgTemplate templates the way I configure 'em.

Assumes use of GitHub.
Turns on services (various GitHubActions and others) if `services`.
Turns on free-for-open-source services if `services` and `!is_proprietary`.
Marks all rights reserved by owner if `is_proprietary`.
Sets up testing to look for *_test.jl files within src directory.
"""
function template(;
    dir::String,
    is_pkg::Bool,
    is_proprietary::Bool,
    services::Bool,
    github_actions_kwargs=(;),
    owner::Union{Nothing,String}=nothing,
    min_julia_version::VersionNumber=v"1.6",
)
    license_name = is_proprietary ? "UNLICENSED" : "MIT"

    plugins = Any[
        Git(; manifest=!is_pkg, ssh=true),
        !License,
        FlexibleLicense(; owner, name=license_name),
        Tests(; file=TestsInSrc.TEMPLATE_PATH, project=false, aqua=true, jet=true),
    ]

    if !services
        push!(plugins, !CompatHelper, !Dependabot, !GitHubActions, !TagBot)

        if is_pkg
            push!(plugins, Documenter{NoDeploy}())
        end
    else
        if !is_pkg
            push!(plugins, !TagBot)
        end

        @info """The GitHub Actions 'Documentation' job will not trigger gh-pages deploys until you
        (having admin rights) have manually pushed to the created 'gh-pages' branch at least once."""

        push!(plugins, Documenter{GitHubActions}(), GitHubActions(; github_actions_kwargs...))

        # Codecov is free for open-source projects
        if !is_proprietary
            push!(plugins, Codecov())

            @info """Using coverage plugins, don't forget to manually add your API tokens as secrets,
            as described [here](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets#creating-encrypted-secrets)."""
        end
    end

    Template(;
        dir,
        plugins,
        julia=min_julia_version,
    )
end

function pkg(;
    is_pkg=true,
    is_proprietary=true,
    services=true,
    kwargs...
)
    template(; is_pkg, is_proprietary, services, kwargs...)
end

function app(;
    is_pkg=false,
    is_proprietary=true,
    services=true,
    kwargs...
)
    template(; is_pkg, is_proprietary, services, kwargs...)
end

function scratch(;
    dir="~/code/scratch",
    is_pkg=false,
    is_proprietary=true,
    services=false,
    kwargs...
)
    template(; dir, is_pkg, is_proprietary, services, kwargs...)
end

end # module
