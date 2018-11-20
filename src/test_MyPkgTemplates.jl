using Test
using MyPkgTemplates
import PkgTemplates: Template

@test MyPkgTemplates.public() isa Template
@test MyPkgTemplates.public(dir=".") isa Template
@test MyPkgTemplates.private() isa Template
@test MyPkgTemplates.private(dir=".") isa Template
