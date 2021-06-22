use strict;
use warnings;
use 5.020;

package Dist::Zilla::MintingProfile::AlienBuild {

  use Moose;
  with 'Dist::Zilla::Role::MintingProfile::ShareDir';
  use namespace::autoclean;

  # ABSTRACT: A minimal Dist::Zilla minting profile for Aliens

  __PACKAGE__->meta->make_immutable;
}

1;
