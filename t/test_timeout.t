use Test::More tests => 4;

use Test::TestHarness;

my $pass = runtest("timeout_tests", "pass");
ok($pass->time <= 2);
is($pass->status, "PASS");

my $fail = runtest("timeout_tests", "fail");
ok($fail->time <= 2);
is($fail->status, "FAIL");

