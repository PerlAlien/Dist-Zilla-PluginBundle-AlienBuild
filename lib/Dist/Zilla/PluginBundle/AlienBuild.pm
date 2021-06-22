use strict;
use warnings;
use 5.020;
use experimental qw( postderef );

package Dist::Zilla::PluginBundle::AlienBuild {

  use Moose;
  use namespace::autoclean;

  # ABSTRACT: A minimal Dist::Zilla plugin bundle for Aliens

  __PACKAGE__->meta->make_immutable;
}

1;


