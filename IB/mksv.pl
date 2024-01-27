#! /usr/bin/perl

use strict;
use warnings;
use File::Fetch;

print "Enter course name:\n";
my $course = <STDIN>;
chomp $course;
$course = lc($course);
$course or die "ABORTING: Course name not supplied\n";

print "Enter supervision number:\n";
my $svnum = <STDIN>;
chomp $svnum;
$svnum or die "ABORTING: Supervision number not supplied\n";

mkdir $course;

# Create directory.
my $dirname = "${course}/sv${svnum}";
mkdir $dirname or die "ABORTING: Directory '$dirname' already exists\n";

# Copy work.tex from template directory, inserting supervisor CRSID.
open my $fh, '<', 'template/blank.tex' or die "ABORTING: cannot open template. $!\n";
read $fh, my $tmplte, -s $fh;
close $fh;
open $fh, '>', "$dirname/work.tex" or die "ABORTING: cannot create new work.tex. $!\n";
print $fh $tmplte;
close $fh;

# Done.
print "\nDone!\n";

system("C:/Users/hjela/OneDrive/Documents/supervisions/$dirname/work.tex");

exit();
