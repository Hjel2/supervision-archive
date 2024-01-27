#! /usr/bin/perl

use strict;
use warnings;
use File::Fetch;

print "Enter filename:\n";
my $fname = <STDIN>;
chomp $fname;
$fname or die "ABORTING: file name not supplied\n";

# Copy work.tex from template directory, inserting supervisor CRSID.
open my $fh, '<', 'templatenst/perSV_mywork.tex' or die "ABORTING: cannot open template. $!\n";
read $fh, my $tmplte, -s $fh;
close $fh;

open $fh, '>', "$fname.tex" or die "ABORTING: cannot create new work.tex. $!\n";
print $fh $tmplte;
close $fh;

system("C:/Users/hjela/OneDrive/Documents/supervisions/nstmaths/$fname.tex");
# this opens the work.tex file so you can start working straight away
