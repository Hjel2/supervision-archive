#! /usr/bin/perl

use strict;
use warnings;
use File::Fetch;

print "Enter course name (abbreviated version is OK):\n";
my $course = <STDIN>;
chomp $course;
$course or die "ABORTING: Course name not supplied\n";

print "Enter supervision number:\n";
my $svnum = <STDIN>;
chomp $svnum;
$svnum or die "ABORTING: Supervision number not supplied\n";

print "Enter supervisor CRSID:\n";
my $svrcrsid = <STDIN>;
chomp $svrcrsid;
$svrcrsid or die "ABORTING: Supervisor CRSID not supplied\n";

print "Default infofile y?:\n";
my $infoq = <STDIN>;
chomp $infoq;
$infoq or die "ABORTING: Supervisor CRSID not supplied\n";

# Create course directory if it does not already exist
# Converts to lowercase to reduce "accidental misses" of the folder
my $coursedir = lc("${course}");
mkdir $coursedir;

# Create supervision directory
my $dirname = "$coursedir/sv${svnum}";
mkdir $dirname or die "ABORTING: Directory '$dirname' already exists\n";

# Copy work.tex from template directory, inserting supervisor CRSID.
open my $fh, '<', 'template/perSV_mywork.tex' or die "ABORTING: cannot open template. $!\n";
read $fh, my $tmplte, -s $fh;
close $fh;

$tmplte =~ s/\$\$SUPERVISOR_CRSID\$\$/$svrcrsid/;
open $fh, '>', "$dirname/work.tex" or die "ABORTING: cannot create new work.tex. $!\n";
print $fh $tmplte;
close $fh;

if ($infoq eq 'y'){
  open my $ih, '<', 'template/infofile.tex' or die "ABORTING: cannot open infofile. $!\n";
  read $ih, my $info, -s $ih;
  close $ih;

  $info =~ s/\$\$TRIPOS\$\$/CST Part IA/;
  $info =~ s/\$\$COURSE\$\$/$course/;
  $info =~ s/\$\$SVNUM\$\$/$svnum/;
  open $ih, '>', "$dirname/infofile.tex" or die "ABORTING: cannot create new infofile.tex. $!\n";
  print $ih $info;
  close $ih;
  system("C:/Users/hjela/OneDrive/Documents/supervisions/$coursedir/sv${svnum}/infofile.tex");
  # if you have requested a default infofile this will open it
}

# Download supervisor's prefs file.
my $svrprefurlstem = 'https://kudos.chu.cam.ac.uk/rest/supervisions/SVRpref';
my $ff = File::Fetch->new(uri => "$svrprefurlstem/$svrcrsid");
my $fname = $ff->fetch(to => './template/prefs') or die "ABORTING: cannot download prefs file. ${ff->error}\n";
rename $fname, "$fname.tex";

# Done.
print "\nDone!\n";
print "Now download the 'infofile.tex' from https://kudos.chu.cam.ac.uk/\n";
print "and enter your supervision work into $dirname/work.tex\n";

system("C:/Users/hjela/OneDrive/Documents/supervisions/$coursedir/sv${svnum}/work.tex");
# this opens the work.tex file so you can start working straight away
