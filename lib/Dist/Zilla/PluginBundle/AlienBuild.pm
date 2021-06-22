use strict;
use warnings;
use 5.020;

package Dist::Zilla::PluginBundle::AlienBuild {

  use Moose;
  use experimental qw( postderef signatures );
  with 'Dist::Zilla::Role::PluginBundle::Easy',
    'Dist::Zilla::Role::PluginBundle::Config::Slicer',
    'Dist::Zilla::Role::PluginBundle::PluginRemover';
  use Ref::Util qw( is_plain_coderef );
  use namespace::autoclean;

  # ABSTRACT: A minimal Dist::Zilla plugin bundle for Aliens

  my %revisions = (
    1 => [
      'GatherDir',
      'MetaYAML',
      'MetaJSON',
      'License',
      'Pod2Readme',
      'PodSyntaxTests',
      'Test::ReportPrereqs',
      [ 'Test::Compile' => { xt_mode => 1 }],
      sub { $_[0]->pluginset_installer },
      'Manifest',
      ['PruneFiles' => { filename => ['README.pod'] }],
      'ManifestSkip',
      'RunExtraTests',
      # plugin_release_management?
      'TestRelease',
      'ConfirmRelease',
      # plugin_releasers
      ['MetaNoIndex' => { directory => [qw( t xt inc share eg examples )] } ],
      # metaprovides
      # execdir
      ['Prereqs' => { -phase => 'runtime', perl => '5.008004' } ],
    ],
  );

  my %allowed_installers = map { $_ => 1 } qw( MakeMaker MakeMaker::Awesome );

=head1 PROPERTIES

=head2 installer

=cut

  has installer => (
    is      => 'ro',
    lazy    => 1,
    default => sub { $_[0]->payload->{installer} // 'MakeMaker' },
  );

=head2 revision

=cut

  has revision => (
    is => 'ro',
    lazy => 1,
    default => sub { $_[0]->payload->{revision} // 1 },
  );

  sub pluginset_installer ($self) {
    my $installer = $self->installer;
    die "Unsupported installer $installer\n"
      unless $allowed_installers{$installer};
    return "$installer";
  }

  sub configure ($self) {
    my $name = $self->name;
    my $revision = $self->revision;
    die "Unknown [$name] revision specified: $revision"
      unless exists $revisions{$revision};
    my @plugins = $revisions{$revision}->@*;

    foreach my $plugin (@plugins)
    {
      if(is_plain_coderef $plugin)
      {
        $self->add_plugins($plugin->($self));
      }
      else
      {
        $self->add_plugins($plugin);
      }
    }
  }

  __PACKAGE__->meta->make_immutable;
}

1;


