package Test::TestHarness;

use TAP::Harness;
use Exporter;

=head1 NAME

Test::TestHarness - Run (test) tests from within tests to test if they suceed or fail

=head1 SYNOPSIS

  use Test::More tests => 1;
  use Test::TestHarness;

  my $res = runtest("my_tests", "pass"); # if this file is t/test.t, then it will run t/my_tests/pass.t
  is($pass->status, "PASS");

=head1 DESCRIPTION

  This module was written to be an easy way to figure out if a test
  passes or fails. It's for when Test::Builder::Tester isn't flexible
  enough.

=head1 FUNCTIONS

=head2 runtests

  Shorthand for "new" which "catfile"s together the parameters, adds
  ".t" to the end, and assumes that the path is starting from the
  "dirname" of the caller.

=head2 new

  Takes one argument, the full path to the test file. This will
  actually run the tests and set up the Test::TestHarness object
  for testing against.

=head2 status

  Get the status. Should either be PASS, FAIL, or NOTESTS.

=head2 time

  Get the number of seconds it took to execute the tests.

=cut

our $VERSION = '0.01';

our @EXPORT = qw/runtest/;
our @ISA = qw/Exporter TAP::Harness/;

sub _bailout {
  my ( $self, $result ) = @_;
  my $explanation = $result->explanation;
  return;
}

use TAP::Parser::Aggregator;

use warnings;
use strict;

use Test::More;
use Test::Builder::Tester;

use Carp;

sub new {
  my $class = shift;
  my $testfile = shift;
  croak("Couldn't find: $testfile") if(!-e $testfile);
  my $self = {};
  bless $self, $class;
  $self->_initialize( { lib => \@INC, verbosity => -3 });
  my $aggregator = TAP::Parser::Aggregator->new;
  $aggregator->start();
  $self->aggregate_tests( $aggregator, $testfile );
  $aggregator->stop();
  $self->{status} = $aggregator->get_status();
  $self->{time} = $aggregator->elapsed->[0];
  $self->{aggregator} = $aggregator;
  return $self;
}

use File::Spec;
use File::Basename;

sub runtest {
  my $end = pop;
  my ($package, $filename, $line) = caller;
  my $testfile = File::Spec->catfile(File::Basename::dirname($filename), @_, $end . ".t");
  croak("Couldn't find: $testfile") if(!-e $testfile);
  return Test::TestHarness->new($testfile);
}

sub time {
  my $self = shift;
  return $self->{time};
}

sub status {
  my $self = shift;
  return $self->{status};
}

1;
