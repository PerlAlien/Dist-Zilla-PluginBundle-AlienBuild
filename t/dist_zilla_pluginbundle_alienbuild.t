use Test2::V0 -no_srand => 1;
use Dist::Zilla::PluginBundle::AlienBuild;
use Path::Tiny qw( path );
use Test::DZil;

subtest 'revision = 1' => sub {

  my $tzil = Builder->from_config(
    { dist_root => 'does-not-exist' },
    {
      add_files => {
        path('source', 'dist.ini') => simple_ini({ version => '0.01' },
          ['@AlienBuild' => { revision => 1 }],
        ),
        path('source', 'lib', 'Alien', 'libfoo.pm') => "package Alien::libfoo;\nour \$VERSION = '0.01';\n1",
        path('source', '.git', 'this-should-get-pruned') => "",
        path('source', 'README.pod') => "prune me\n",
        path('source', 'Changes') => "{{\$NEXT}}\n  - Initial version\n",
      },
    },
  );

  $tzil->build;

  my $build_dir = path($tzil->tempdir)->child('build');
  my @found_files;
  my $iter = $build_dir->iterator({ recurse => 1 });
  while (my $path = $iter->())
  {
    push @found_files, $path->relative($build_dir)->stringify if -f $path;
  }

  is [sort @found_files], [qw(
    Changes
    LICENSE
    MANIFEST
    META.json
    META.yml
    Makefile.PL
    README
    dist.ini
    lib/Alien/libfoo.pm
    t/00-report-prereqs.dd
    t/00-report-prereqs.t
    xt/author/00-compile.t
    xt/author/pod-syntax.t
  )], 'built the correct files';

  my $meta = $tzil->distmeta;

  is(
    $meta,
    hash {
      field version => '0.01';
      field prereqs => hash {
        field runtime => hash {
          field requires => hash {
            field perl => '5.008004';
            etc;
          };
          etc;
        };
        etc;
      };
      etc;
    },
  );

};

done_testing;
