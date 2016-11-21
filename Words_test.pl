#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Words qw(getwords);

my @test_dict = ('Arrows', 'carrots', 'give', 'me', 'qwertyuiop', 'qqqqq', 'aaaaa', 'zzzzz', 'asd', 'zxcv', 'fghj', 'bnmj', 'tyui');
my @sequence=();
my @words=();
my $alert;

## create a test dictionary file.
open (my $fh, '>', 'dict.txt') or warn("could not create dict.txt.  Some test may fail because of this.");
	foreach my $i (@test_dict) { print $fh "$i\n"; }
close $fh;
     
say "Running Tests... ";
     
use Test::Simple tests => 13;
     
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
## check that test sequence data is correct
ok(checkSequenceData() > 0);
## check that test words data is correct
ok(checkWordsData() > 0);
## check that test sequence and word files are in sync.
ok(checkFileOrder() > 0);


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

sub checkSequenceData {
	
	my $msg = 0;
	### open up sequence file and add data to array.
	
	my %sequence_data = (
		'qwer' => '1',
		'carr' => '1',
		'zxcv' => '1',
		'rows' => '1',
		'erty' => '1',
		'rtyu' => '1',
		'uiop' => '1',
		'wert' => '1',
		'give' => '1',
		'rots' => '1',
		'rrow' => '1',
		'yuio' => '1',
		'rrot' => '1',
		'bnmj' => '1',
		'fghj' => '1',
	);
		
	open (my $fh, '<', 'sequence.txt') or warn('Could not open file sequence.txt');
	chomp(@sequence = <$fh>);
	close $fh;	
	
	### check to see if sequence file has correct number of records in it.  if so check for valid data, remember arrays start with 0 so use 14..
	if ( $#sequence == 14 ) {
		$msg = 1; ## set to 1 because success for record count.
		foreach my $s (@sequence) {
			if ( $sequence_data{$s} ) { next; } ## this is correct so just move to next sequence.
			else { $msg = 0; last; } ## this is wrong so reset msg and end the scan as any further results do not matter, the check has failed
		} 
		 
	}
	
	return $msg;

}

sub checkWordsData {
	
	my $msg = 0;
	### open up sequence file and add data to array.
	
	my %words_data = (
		'qwertyuiop'	=> '6',
		'carrots' 		=> '3',
		'Arrows' 		=> '2',
		'zxcv' 			=> '1',
		'give' 			=> '1',
		'bnmj' 			=> '1',
		'fghj' 			=> '1',
	);
	
	open (my $fh, '<', 'words.txt') or warn('Could not open file words.txt');
	chomp(@words = <$fh>);
	close $fh;	
	
	### check to see if words file has correct number of records in it.  if so check for valid data, remember arrays start with 0 so use 14..
	if ( $#words == 14 ) {
		
		$msg = 1; ## set to 1 because success for record count.
		
		my %words_count=();
		foreach my $w (@words) {
			if ($words_count{$w}) { $words_count{$w}++; }
			else { $words_count{$w} = 1; }
		} 
		
		foreach my $key ( keys %words_count ) {
			if ( $words_count{$key} == $words_data{$key} ) { next; } ## this is correct so just move to next word.
			else { $msg = 0; last; } ## this is wrong so reset msg and end the scan as any further results do not matter, the check has failed
		}
 
	}
	
	return $msg;

}

sub checkFileOrder {
	
	## set initial msg to 1 as we will set to 0 on fail.
	my $msg = 1;
	
	for (my $i = 0; $i <= $#sequence; $i++) {
		
		if (index($words[$i], $sequence[$i]) != -1) { next; } ## this is correct so just move to next sequence.
    	else { $msg = 0; last; } ## this is wrong so set msg to 0 and end the scan as any further results do not matter, the check has failed
	} 
	
	return $msg;
}
