# Config

# TODO: license
# TODO: org info
# TODO: [Develop](https://invenia.github.io/PkgTemplates.jl/dev/user/#PkgTemplates.Develop)
# TODO: [Tests](https://invenia.github.io/PkgTemplates.jl/dev/user/#PkgTemplates.Tests)
# TODO: [Benchmark](https://github.com/invenia/PkgTemplates.jl/issues/86)
# TODO: [Hooks](https://github.com/invenia/PkgTemplates.jl/issues/11)
parent_dir = "."
is_pkg = true
is_private = false
is_travis = false
platforms = (; linux=true, osx=false, windows=false, x64=true, x86=false #=, arm64=false=#)

# Templating

using PkgTemplates

@assert !is_private || !is_travis
@assert is_travis || !hasproperty(platforms, :arm64)

ci_type = if is_travis
    TravisCI
else
    @info """The GitHub Actions 'Documentation' job will not trigger gh-pages deploys
    until you have manually pushed to the created 'gh-pages' branch at least once."""
    GitHubActions
end

plugins = [
    Git(; manifest=!is_pkg, ssh=true),
    Documenter{ci_type}(),
    ci_type(; platforms...),
]

if !is_private
    push!(plugins, Codecov())
end

t = Template(
    dir=parent_dir,
    plugins=plugins,
)
