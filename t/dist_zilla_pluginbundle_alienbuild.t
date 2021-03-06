use Test2::V0 -no_srand => 1;
use Dist::Zilla::PluginBundle::AlienBuild;
use Path::Tiny qw( path );
use Test::DZil;
use experimental qw( postderef );

foreach my $revision (5, 'default') {

  subtest "revision = $revision" => sub {

    subtest 'defaults' => sub {

      my $tzil = Builder->from_config(
        { dist_root => 'does-not-exist' },
        {
          add_files => {
            path('source', 'dist.ini') => simple_ini({ version => '0.01' },
              ['@AlienBuild', $revision eq 'default' ? () : { revision => $revision }],
            ),
            path('source', 'lib', 'Alien', 'libfoo.pm') => "package Alien::libfoo;\nour \$VERSION = '0.01';\n1",
            path('source', '.git', 'this-should-get-pruned') => "",
            path('source', 'README.pod') => "prune me\n",
            path('source', 'Changes') => "{{\$NEXT}}\n  - Initial version\n",
            path('source', 'alienfile') => 'use alienfile;',
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
        alienfile
        dist.ini
        lib/Alien/libfoo.pm
        t/00-report-prereqs.dd
        t/00-report-prereqs.t
        xt/author/00-compile.t
        xt/author/pod-syntax.t
      )], 'built the correct files';

      is(
        [grep { $_->name eq 'Makefile.PL' } $tzil->files->@*],
        [object {
          call content => !match qr/'?clean_install' => 1/;
        }],
        'Makefile.PL is good',
      );

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
        'meta is good',
      );
    };

    subtest 'clean install' => sub {

      my $tzil = Builder->from_config(
        { dist_root => 'does-not-exist' },
        {
          add_files => {
            path('source', 'dist.ini') => simple_ini({ version => '0.01' },
              ['@AlienBuild', { alien_clean_install => 1, $revision eq 'default' ? () : (revision => $revision) }],
            ),
            path('source', 'lib', 'Alien', 'libfoo.pm') => "package Alien::libfoo;\nour \$VERSION = '0.01';\n1",
            path('source', '.git', 'this-should-get-pruned') => "",
            path('source', 'README.pod') => "prune me\n",
            path('source', 'Changes') => "{{\$NEXT}}\n  - Initial version\n",
            path('source', 'alienfile') => 'use alienfile;',
          },
        },
      );

      $tzil->build;

      is(
        [grep { $_->name eq 'Makefile.PL' } $tzil->files->@*],
        [object {
          call content => match qr/'?clean_install' => 1/;
        }],
        'Makefile.PL is good',
      );

    };

    subtest 'alien doc' => sub {


      my $tzil = Builder->from_config(
        { dist_root => 'does-not-exist' },
        {
          add_files => {
            path('source', 'dist.ini') => simple_ini({ version => '0.01' },
              ['@AlienBuild', { alien_name => 'foo', alien_type => ['tool','library'], $revision eq 'default' ? () : (revision => $revision) }],
            ),
            path('source', 'lib', 'Alien', 'libfoo.pm') => "package Alien::libfoo;\nour \$VERSION = '0.01';\n# ALIEN SYNOPSIS\n# ALIEN DESCRIPTION\n# ALIEN SEE ALSO\n1",
            path('source', '.git', 'this-should-get-pruned') => "",
            path('source', 'README.pod') => "prune me\n",
            path('source', 'Changes') => "{{\$NEXT}}\n  - Initial version\n",
            path('source', 'alienfile') => 'use alienfile;',
          },
        },
      );

      $tzil->build;

      my($pm) = grep { $_->name eq 'lib/Alien/libfoo.pm' } $tzil->files->@*;
      my $pm_content = defined $pm ? $pm->content : '';

      like $pm_content, qr/=head1 SYNOPSIS/;
      like $pm_content, qr/=head1 DESCRIPTION/;
      like $pm_content, qr/=head1 SEE ALSO/;

    };
  };

}

done_testing;
