use ExtUtils::MakeMaker;
WriteMakefile
(
          'NAME'             => 'Test::Timeout',
          'AUTHOR'           => ['Jonathan Stowe <jns@gellyfish.co.uk>'],
          'VERSION_FROM'     => 'lib/Test/Timeout.pm',
          'ABSTRACT_FROM'    => 'lib/Test/Timeout.pm',
          'LICENSE'          => 'perl', 
          'MIN_PERL_VERSION' => '5.10.1',
          'INSTALLDIRS'      => 'site',
          'EXE_FILES'        => [],
          'PL_FILES'         => {}
)
;
