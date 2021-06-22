use 5.020;
use strict;
use warnings;
use Dist::Zilla::PluginBundle::AlienBuild;
use Config::INI::Reader;
use Path::Tiny qw( path );
use File::Temp qw( tempdir );
use Test2::Mock;
use experimental qw( signatures );

BEGIN {  @INC = map { ref($_) ? $_ : path($_)->absolute->stringify } @INC }

my $nl = 0;
my $in_config;

if($ARGV[0] eq '--default')
{
  $in_config = {};
}
else
{
  die "run from the directory with the dist.ini file" unless -r 'dist.ini';
  $in_config = Config::INI::Reader->read_file('dist.ini')->{'@AlienBuild'};
}

die "unable to find [\@AlienBuild] in your dist.ini" unless defined $in_config;

my $intercept = Test2::Mock->new(
  class => 'Dist::Zilla::PluginBundle::AlienBuild',
  override => [
    add_plugins => sub ($self, @plugins) {
      foreach my $plugin (map { ref $_ ? [@$_] : [$_] } @plugins)
      {
        my %config = ref $plugin->[-1] eq 'HASH' ? %{ pop @$plugin } : ();
        my($moniker, $name) = @$plugin;

        print "\n" if $nl && %config;
        if(defined $name)
        {
          print "[$moniker / $name]\n";
        }
        else
        {
          print "[$moniker]\n";
        }

        foreach my $k (sort keys %config)
        {
          my $v = $config{$k};
          $v = [ $v ] unless ref $v;
          print "$k = $_\n" for @$v;
        }

        if(%config)
        {
          print "\n";
          $nl = 0;
        }
        else
        {
          $nl = 1;
        }
      }
    }
  ],
);

my $bundle = Dist::Zilla::PluginBundle::AlienBuild->new(
  name    => '@AlienBuild',
  payload => $in_config,
);

$bundle->configure;

chdir(Path::Tiny->rootdir);
