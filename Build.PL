use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::Timeout',
    license             => 'perl',
    dist_author         => 'Ryan Niebur <ryanryan52@gmail.com>',
    dist_version        => '0.01',
    dist_abstract       => 'Limit the amount of time tests can take',
    requires => {},
    build_requires => {
          'Test::TestHarness' => 0
        },
    add_to_cleanup      => [ 'Test-Timeout-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
