#! /usr/bin/perl

use strict;
use warnings;
use File::Fetch;

print "Enter course name:\n";
my $course = <STDIN>;
chomp $course;
$course or die "ABORTING: Course name not supplied\n";

print "Enter number of supervisions:\n";
my $svnum = <STDIN>;
chomp $svnum;
$svnum or die "ABORTING: Number of supervisions not supplied\n";

mkdir $course;

for (my $i = 1; $i <= $svnum; $i++){
    # Create directory.
    my $dirname = "${course}/sv${i}";

    if (!(mkdir $dirname)){
        print "WARNING: Directory '$dirname' already exists so has been skipped!\n";
        next;
    }

    # Copy work.tex from template directory, inserting supervisor CRSID.
    open my $fh, '<', 'template/perSV_mywork.tex' or die "ABORTING: cannot open template!\n";
    read $fh, my $tmplte, -s $fh;
    close $fh;
    open $fh, '>', "$dirname/work.tex" or die "ABORTING: cannot create new work.tex!\n";
    print $fh $tmplte;
    close $fh;
}

# Done.
print "\nDone!\n";
print "Now download the 'infofile.tex' from https://kudos.chu.cam.ac.uk/\n";
print "and enter your supervision work into $dirname/work.tex\n";
