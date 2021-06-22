use Test2::V0 -no_srand => 1;
use Test::DZil;
use Path::Tiny qw( path );
use Test::File::ShareDir::Module { 'Dist::Zilla::MintingProfile::AlienBuild' => 'profiles' };

subtest 'basic' => sub {

  my $tzil = Minter->_new_from_profile(
    [ AlienBuild => 'default' ],
    { name => 'Alien-libfoo' },
    { global_config_root => 'corpus/dist_zilla_mintingprofile_alienbuild' },
  );

  $tzil->mint_dist;

  my $mint_dir = path($tzil->tempdir)->child('mint');
  my $iter = $mint_dir->iterator({ recurse => 1 });
  my @found_files;
  while (my $path = $iter->()) {
    push @found_files, $path->relative($mint_dir)->stringify if -f $path;
  }

  is [sort @found_files], [qw(
    dist.ini
    lib/Alien/libfoo.pm
  )], 'minted the correct files';

};

done_testing;
