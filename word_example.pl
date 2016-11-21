#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Words qw(getwords);
use Data::Dumper;
use File::Slurp;
use CGI qw(:standard); 
use CGI::Carp qw ( fatalsToBrowser );

$CGI::POST_MAX = 1024 * 1000;

## read in cgi variables and set defaults if empty
my $upload_filehandle = upload("dictionary_file");
my $dictionary_file = param('dictionary_file') || 'dictionary_default.txt';
my $sequence_file = param('sequence_file') || 'sequence.txt';
my $words_file = param('words_file') || 'words.txt';
my $action = param('action');
my $random_number = 1 + int rand(9999);

## check if a dictionary file has been uploaded if so save it.
if ($dictionary_file ne 'dictionary_default.txt' && $upload_filehandle) {
	$dictionary_file = 'output_files/' . $dictionary_file . '.' . $random_number . '.txt';
	open ( UPLOADFILE, ">$dictionary_file" ) or die "$!";
	while ( <$upload_filehandle> )  {
		print UPLOADFILE;
	}
	close UPLOADFILE;
}

## set file save path and add random number and .txt to end of sequence and words file.
$sequence_file = 'output_files/' . $sequence_file . '.' . $random_number . '.txt';
$words_file = 'output_files/' . $words_file . '.' . $random_number . '.txt';

print "Content-type: text/html\n\n";

if ($action eq 'upload') {
	
	### get success or error message and then data if needed.
	my ($message, $hash_ref) = getwords($dictionary_file, $sequence_file, $words_file); 
	
	### remove uploaded dictionary file as we do not need it anymore.
	if ($dictionary_file ne 'dictionary_default.txt') { unlink $dictionary_file; }
	
	my $html_data = read_file( 'template/word_example_done.html' );
	
	$html_data =~ s/<!--###GetSequenceFileLink###-->/$sequence_file/g;
	$html_data =~ s/<!--###GetWordsFileLink###-->/$words_file/g;

	print $html_data;
}
else {

	my $html_data = read_file( 'template/word_example.html' );

	#open (my $fh, '<', $template_file) or warn( 'Can not open template file.' );
	#	my $html_data = <$fh>;
	#close $fh;	

	print $html_data;
}

exit;