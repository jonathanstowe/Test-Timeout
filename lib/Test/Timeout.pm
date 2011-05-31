package Test::Timeout;

my $do_end_test = 0;
my $timeout;
my $failed = 0;

use Test::More;
use Test::Builder;

our $VERSION = '0.01';

=head1 NAME

Test::Timeout - Limit the amount of time tests can take

=head1 SYNOPSIS

  use Test::More tests => 2; # add an extra test to your plan
  use Test::Timeout timeout => 2; # number of seconds

  # this test will fail and the test suite will stop running after 2 seconds
  sleep(10);
  pass("Whee");

=head1 DESCRIPTION

Sometimes perl modules get "stuck". The tests should take this into
account and test to make sure that it doesn't happen. Test::Timeout
makes this trivial by limiting the amount of time the test can run.

=head1 FUNCTIONS

=head2 import

This takes a hash, with a required named "timeout" which is the number
of seconds to limit the test to.

=head1 TODO

=over 1

=item Need to implement syntax like Time::Out (that would just fail instead of exiting):

  timeout 180 => sub {
    sleep(200);
  }

=back

=cut

my $Test = Test::Builder->new;
my $PID = $$;

sub import {
  my $self = shift;
  my %hash = @_;
  if(!defined($hash{timeout}) or $hash{timeout} == 0) {
#    return
    die("Test::Timeout requires a timeout arguement");
  }
  $do_end_test = 1;
  $timeout = $hash{timeout};
  $SIG{ALRM} = \&_fail_miserably;
  alarm($timeout);
#  goto &Exporter::import;
}

sub _fail_miserably {
  $failed = 1;
  fail("Took longer than $timeout seconds");
  $Test->BAIL_OUT("Took too long");
}

sub _all_done {
  return 0 if $$ != $PID;
  pass("Didn't take longer than $timeout seconds") if($failed == 0);
}

sub END {
  if($do_end_test) {
    _all_done();
  }
}
