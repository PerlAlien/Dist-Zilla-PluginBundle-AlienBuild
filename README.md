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
uses the [\[AlienBuild\]](https://metacpan.org/pod/Dist::Zilla::Plugin::AlienBuild) plugin, which updates your `Makefile.PL` and prereqs based on
the provided [alienfile](https://metacpan.org/pod/alienfile).  This bundle does not currently support [Module::Build](https://metacpan.org/pod/Module::Build) (though it may in the future)
or [Module::Build::Tiny](https://metacpan.org/pod/Module::Build::Tiny) (which is fundamentally incapable of supporting the [Alien](https://metacpan.org/pod/Alien) concept).  Only revision 5
of [\[@Starter\]](https://metacpan.org/pod/Dist::Zilla::PluginBundle::Starter) is currently supported, future revisions may be added in the
future.  This plugin bundle will also use [\[AlienBase::Doc\]](https://metacpan.org/pod/Dist::Zilla::Plugin::AlienBase::Doc) to provide some
minimal documentation boilerplate for your alien if the ["alien\_name"](#alien_name) property is provided and the appropriate
template variables are in your `.pm` file.

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

# PROPERTIES

In addition to the properties supported by [\[@Starter\]](https://metacpan.org/pod/Dist::Zilla::PluginBundle::Starter), this bundle has these
properties:

- alien\_clean\_install

    Sets the [clean\_install property on Alien::Build::MM](https://metacpan.org/pod/Alien::Build::MM#clean_install).

- alien\_name

    If provided then the [\[AlienBase::Doc\]](https://metacpan.org/pod/Dist::Zilla::Plugin::AlienBase::Doc) plugin will be used to generate basic
    documentation for your alien.

- alien\_see\_also

    Specifies modules that should be listed in the `SEE ALSO` section of the documentation.  See the
    [see\_also property in \[AlienBase::Doc\]](https://metacpan.org/pod/Dist::Zilla::Plugin::AlienBase::Doc#see_also).  If this property is
    set you need to also provide ["alien\_name"](#alien_name).

- alien\_type

    Specifies the type of alien.  See the [type property in \[AlienBase::Doc\]](https://metacpan.org/pod/Dist::Zilla::Plugin::AlienBase::Doc#type).
    If this property is set you need to also provide ["alien\_name"](#alien_name).

# SEE ALSO

- [Alien](https://metacpan.org/pod/Alien)

    The Alien concept documentation.

- [Alien::Build](https://metacpan.org/pod/Alien::Build)

    The [Alien::Build](https://metacpan.org/pod/Alien::Build) framework for creating aliens.

- [alienfile](https://metacpan.org/pod/alienfile)

    The recipe system used by [Alien::Build](https://metacpan.org/pod/Alien::Build).

- [Dist::Zilla::MinitingProfile::AlienBuild](https://metacpan.org/pod/Dist::Zilla::MinitingProfile::AlienBuild)

    Minting profile to create a new Alien dist.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
