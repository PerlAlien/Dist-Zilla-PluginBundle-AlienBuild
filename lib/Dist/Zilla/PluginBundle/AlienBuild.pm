use strict;
use warnings;
use 5.020;

package Dist::Zilla::PluginBundle::AlienBuild {

  use Moose;
  use Test2::Mock;
  use experimental qw( postderef signatures );
  extends 'Dist::Zilla::PluginBundle::Starter';
  use PerlX::Maybe;
  use namespace::autoclean;

  # ABSTRACT: A minimal Dist::Zilla plugin bundle for Aliens

  my %allowed_installers = map { $_ => 1 } qw( MakeMaker MakeMaker::Awesome );

  has '+revision' => (
    default => sub ($self) { $self->payload->{revision} // 5 },
  );

  sub pluginset_installer ($self) {
    my $installer = $self->installer;
    die "Unsupported installer $installer\n"
      unless $allowed_installers{$installer};
    return "$installer";
  }

  around mvp_multivalue_args => sub ($orig, $self) {
    my @mvp = $self->$orig;
    (@mvp, 'alien_type', 'see_also');
  };

  around configure => sub ($orig, $self) {
    die "Only revision 5 is currently supported"
      unless $self->revision <= 5;

    my @plugins;

    {
      my $intercept = Test2::Mock->new(
        class => __PACKAGE__,
        override => [
          add_plugins => sub ($self, @new) {
            push @plugins, @new;
          },
        ],
      );

      $self->$orig;
    }

    my %ab = (
      ':version' => '0.31',
      alienfile_meta => 1,
    );

    if($self->payload->{alien_clean_install})
    {
      $ab{clean_install} = 1;
    }

    push @plugins,
      ['Prereqs', 'AlienBuildMinimumPerl' => { -phase => 'runtime', perl => '5.008004' } ],
      ['AlienBuild' => \%ab ];

    if($self->payload->{alien_name})
    {
      unshift @plugins,
        ['AlienBase::Doc', {
          maybe name     => $self->payload->{alien_name},
          maybe type     => $self->payload->{alien_type},
          maybe see_also => $self->payload->{alien_see_also},
        }];
    }
    elsif($self->payload->{alien_type} || $self->payload->{alien_see_also})
    {
      die "The alien_type and alien_see_also properties require the alien_name property to be set";
    }

    foreach my $plugin (@plugins)
    {
      $self->add_plugins($plugin);
    }
  };

  __PACKAGE__->meta->make_immutable;
}

1;

=head1 SYNOPSIS

In your dist.ini:

 [@AlienBuild]

=head1 DESCRIPTION

This L<Dist::Zilla> plugin bundle extends the L<[@Starter]|Dist::Zilla::PluginBundle::Starter> bundle to work with
L<Alien::Build> system.  In particular, it sets the minimum required Perl to that required by L<Alien::Build> and
uses the L<[AlienBuild]|Dist::Zilla::Plugin::AlienBuild> plugin, which updates your C<Makefile.PL> and prereqs based on
the provided L<alienfile>.  This bundle does not currently support L<Module::Build> (though it may in the future)
or L<Module::Build::Tiny> (which is fundamentally incapable of supporting the L<Alien> concept).  Only revision 5
of L<[@Starter]|Dist::Zilla::PluginBundle::Starter> is currently supported, future revisions may be added in the
future.  This plugin bundle will also use L<[AlienBase::Doc]|Dist::Zilla::Plugin::AlienBase::Doc> to provide some
minimal documentation boilerplate for your alien if the L</alien_name> property is provided and the appropriate
template variables are in your C<.pm> file.

This is the default configuration for this bundle:

# EXAMPLE: example/revision5_default.ini

=head1 PROPERTIES

In addition to the properties supported by L<[@Starter]|Dist::Zilla::PluginBundle::Starter>, this bundle has these
properties:

=over 4

=item alien_clean_install

Sets the L<clean_install property on Alien::Build::MM|Alien::Build::MM/clean_install>.

=item alien_name

If provided then the L<[AlienBase::Doc]|Dist::Zilla::Plugin::AlienBase::Doc> plugin will be used to generate basic
documentation for your alien.

=item alien_see_also

Specifies modules that should be listed in the C<SEE ALSO> section of the documentation.  See the
L<see_also property in [AlienBase::Doc]|Dist::Zilla::Plugin::AlienBase::Doc/see_also>.  If this property is
set you need to also provide L</alien_name>.

=item alien_type

Specifies the type of alien.  See the L<type property in [AlienBase::Doc]|Dist::Zilla::Plugin::AlienBase::Doc/type>.
If this property is set you need to also provide L</alien_name>.

=back

=head1 SEE ALSO

=over 4

=item L<Alien>

The Alien concept documentation.

=item L<Alien::Build>

The L<Alien::Build> framework for creating aliens.

=item L<alienfile>

The recipe system used by L<Alien::Build>.

=item L<Dist::Zilla::MinitingProfile::AlienBuild>

Minting profile to create a new Alien dist.

=back

=cut
