# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl WWW-Mailinator.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 2;
BEGIN { use_ok('WWW::Mailinator') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $mailbox = WWW::Mailinator->new();
ok(defined($mailbox))
