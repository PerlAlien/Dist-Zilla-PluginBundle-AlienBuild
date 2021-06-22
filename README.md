# Dist::Zilla::PluginBundle::AlienBuild ![linux](https://github.com/PerlAlien/Dist-Zilla-PluginBundle-AlienBuild/workflows/linux/badge.svg)

A minimal Dist::Zilla plugin bundle for Aliens

# SYNOPSIS

In your dist.ini:

```
[@AlienBuild]
```

# DESCRIPTION

This [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) plugin bundle extends the [\[@Starter\]](https://metacpan.org/pod/Dist::Zilla::PluginBundle::Starter) bundle to work with
[Alien::Build](https://metacpan.org/pod/Alien::Build) system.  In particular, it sets the minimum required Perl to that required by [Alien::Build](https://metacpan.org/pod/Alien::Build) and
uses the [\[AlienBuild\]](https://metacpan.org/pod/Dist::Zilla::Plugin::AlienBuild), which updates your `Makefile.PL` and prereqs based on
the provided [alienfile](https://metacpan.org/pod/alienfile).  This bundle does not currently support [Module::Build](https://metacpan.org/pod/Module::Build) (though it may in the future)
or [Module::Build::Tiny](https://metacpan.org/pod/Module::Build::Tiny) (which is fundamentally incapable of supporting the [Alien](https://metacpan.org/pod/Alien) concept).  Only revision 5
of [\[@Starter\]](https://metacpan.org/pod/Dist::Zilla::PluginBundle::Starter) is currently supported, future revisions may be added in the
future.

This is the default configuration for this bundle:

```
[GatherDir]
[MetaYAML]
[MetaJSON]
[License]
[Pod2Readme]
[PodSyntaxTests]
[Test::ReportPrereqs]

[Test::Compile]
xt_mode = 1

[MakeMaker]
[Manifest]
[PruneCruft]

[PruneFiles]
filename = README.pod

[ManifestSkip]
[RunExtraTests]
[TestRelease]
[ConfirmRelease]
[UploadToCPAN]

[MetaNoIndex]
directory = t
directory = xt
directory = inc
directory = share
directory = eg
directory = examples

[MetaProvides::Package]
inherit_version = 0

[ShareDir]
[ExecDir]

[Prereqs / AlienBuildMinimumPerl]
-phase = runtime
perl = 5.008004

[AlienBuild]
:version = 0.31
alienfile_meta = 1
```

# SEE ALSO

- [Dist::Zilla::MinitingProfile::AlienBuild](https://metacpan.org/pod/Dist::Zilla::MinitingProfile::AlienBuild)

    Minting profile to create a new Alien dist.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
