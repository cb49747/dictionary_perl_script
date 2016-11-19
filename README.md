# dictionary_perl_script
-------------------------
Words.pm Perl Module
by Chris Burger
-------------------------

-------------------------
--     DESCRIPTION     --
-------------------------
A simple perl script to read a dictionary file and find unique 4 letter sequences

A Perl module that will read a dictionary file and then generate two output files.  The first, a file of sequences and a second 
file of words.  The sequence file will contain every sequence of 4 letters (case insensitive) that appears only once in the 
dictionary file.  The sequence and word file will contain one entry per line and each file will match.  i.e. the sequence on 
line 10 of the sequence file will come from the word on line 10 of the word file.

-------------------------
--  USE INSTRUCTIONS   --
-------------------------
This module takes 3 arguments, a dictionary file, a sequence output file, and a words output file.
It will return a status message, and hash ref of all the data.

The status message will display success if there are no errors.  Other wise the status message will display the error.

To use place the file Words.pm in a directory listed in your @inc var.  You can also run Words_test.pl to test if the 
module is working properly.

-------------------------
--     SAMPLE USE      --
-------------------------

use Words qw(getwords);

my ($message, $hash_ref) = getwords($input_file, $output_sequence_file, $output_words_file);

-------------------------
--   Files Included    --
-------------------------
Words.pm

Words_test.pl

word_example.pl

readme.md
