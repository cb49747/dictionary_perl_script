#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Words qw(getwords);

my @test_dict = ('Arrows', 'carrots', 'give', 'me');
my $alert;

## create a test dictionary file.
open (my $fh, '>', 'dict.txt') or warn("could not create dict.txt.  Some test may fail because of this.");
	foreach my $i (@test_dict) { print $fh "$i\n"; }
close $fh;
     
say "Running Tests... ";
     
use Test::Simple tests => 10;
     
## check to see program still runs if sequence file can not be opened.
ok( ($alert) = getwords('dict.txt', 'test/sequence.txt', 'words.txt') );
ok( $alert eq 'could not open file test/sequence.txt for writing.' );
## check to see program still runs if words file can not be opened.
ok( ($alert) = getwords('dict.txt', 'test/sequence.txt', 'test/words.txt') );
ok( $alert eq 'could not open file test/words.txt for writing.' );
## check to see program still runs if dictionary file can not be opened.
ok( ($alert) = getwords('', 'sequence.txt', 'words.txt') );
ok( $alert eq 'could not open file ' );
## check to see program alerts success with all good variables.
ok( ($alert) = getwords('dict.txt', 'sequence.txt', 'words.txt') );
ok( $alert eq 'success' );
## check that data was actually written to the sequence and words file.
ok(-s "sequence.txt" > 0);
ok(-s "words.txt" > 0);

say "Removing test files...";
unlink "sequence.txt";
unlink "words.txt";
unlink "dict.txt";

## check to see test files were removed.
if (-e "sequence.txt") { say "Could not remove test file sequence.txt.  You may want to manually remove it."; }
else { say "Test file sequence.txt has been removed."; }
if (-e "words.txt") { say "Could not remove test file words.txt.  You may want to manually remove it."; }
else { say "Test file words.txt has been removed."; }
if (-e "dict.txt") { say "Could not remove test file dict.txt.  You may want to manually remove it."; }
else { say "Test file dict.txt has been removed."; }

### future plans right some sub routines to actually read files for correct data from test dictionary ###
