#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Words qw(getwords);
use Data::Dumper;

### set your vars
my $input_file 				= 'dictionary.txt';
my $output_sequence_file 	= 'output_sequence.txt';
my $output_words_file 		= 'output_words.txt';

### get success or error message and then data if needed.
my ($message, $hash_ref) = getwords($input_file, $output_sequence_file, $output_words_file); 

print Dumper($hash_ref);

say $message;

exit;