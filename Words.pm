package Words;

use strict;
use warnings;
use 5.010;

=pod
 
=head1 My word parsing and comparing module
 
This script needs to have 3 parameters. A dictionary file, the sequence output file, and the words output file.
It will read the dictionary file and then take all 4 char sequences from all words in the file.  It will then 
compare those sequences and save only the ones that happen once.  writing the sequences in one file and their
coresponding words in the other.
Usage is this.

use Words qw(getwords);

my ($message, $hash_ref) = getwords($input_file, $output_sequence_file, $output_words_file);
 
=cut

use Exporter qw(import);
our @EXPORT_OK = qw(getwords);

sub getwords {
	
### get input variables
my $input_file 				= $_[0];
my $output_sequence_file 	= $_[1];
my $output_words_file 		= $_[2];


my $alert;
my $file_open_error;
my @dictionary=();

### open up dictionary file and add data to array.
if ( open (my $fh, '<', $input_file) ) {
	chomp(@dictionary = <$fh>);
	close $fh;	
}
else {
	$alert = "could not open file " . $input_file;
}



my %data=();
my %doubles=();

### for each word in the array grab 4 letter sequences and store that sequence in a hash with the whole word as value
### if the 4 letter key allready exists than store in a 2nd hash.
foreach my $i (@dictionary) {
	if (length $i < 4) { next; }
	for (unpack '(a4X3)' . (length($i)-3), $i) {
		if ($data{lc $_}) { $doubles{lc $_} = $i; }
		else { $data{lc $_} = $i; }
	} 
}

### for every key in the 2nd hash (doubles) delete that key from main data hash as we don't want keys found more than once.
for (keys %doubles) { delete $data{$_}; }

### set main data hash to a reference.
my $data_ref = \%data;

### open two file handles one for keys (sequences) and one for values (words), cycle thru the main data hash printing the 
### keys (sequences) to one file and the values (words) to another.  since hashes are not orderd must print both files at 
### same time to keep things in sync.  Close both file handles when done.
open (my $osfh, '>', $output_sequence_file) or do { $file_open_error = "could not open file " . $output_sequence_file . " for writing."; };
open (my $owfh, '>', $output_words_file) or do { $file_open_error = "could not open file " . $output_words_file . " for writing."; };

	if($file_open_error) { $alert = $file_open_error; }
	else {
		while( my( $key, $value ) = each %data ){
			print $osfh "$key\n";
			print $owfh "$value\n";
		}		
	}
	
close $osfh;
close $owfh;

if (-e $output_sequence_file && -e $output_words_file && !$alert) { $alert = "success"; }

### return main data hash to calling program.  Not necessary, but nice if programs wants to do something else with it.
return ($alert, $data_ref);
	
}

1;