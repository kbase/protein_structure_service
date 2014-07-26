#
# test prst-lookup-pdb-by-fid.pl using Test::Cmd
#

use strict;
use Test::More;
use Test::Cmd;
use FindBin;
use lib "$FindBin::Bin/../lib";
use prot_struct_test_utils;     # defines $service_url

my $prog='prst-lookup-pdb-by-fid';


my $bin  = "scripts";

print "$0 starts.\n";
print "service_url is [$service_url]\n";
#$service_url = "http://140.221.67.170:7088";

my $t = Test::Cmd->new( prog        => "scripts/$prog.pl", 
                        workdir     => '', 
                        interpreter => '/kb/runtime/bin/perl'
                      );
ok( $t, "creating Test::Cmd object for fid test" );

$t->run( args => "--url=$service_url", stdin => <<EndOfInput );
kb|g.0.peg.424
EndOfInput

ok( $? == 0, "Running $prog" );
print $t->stderr;
my @output = $t->stdout;
my @expected = (
"kb|g.0.peg.424	3o4v		0	100	232\n",
"kb|g.0.peg.424	3df9		0	100	232\n",
"kb|g.0.peg.424	1nc3		0	100	232\n",
"kb|g.0.peg.424	1y6r		0	100	232\n",
"kb|g.0.peg.424	1z5p		0	100	232\n",
"kb|g.0.peg.424	1nc1		0	100	232\n",
"kb|g.0.peg.424	1jys		0	100	232\n",
"kb|g.0.peg.424	1y6q		0	100	232\n",
"kb|g.0.peg.424	1z5n		0	99.57	232\n",
"kb|g.0.peg.424	1z5o		0	99.57	232\n",
"kb|g.0.peg.424	4f3c		0	95.69	232\n",
"kb|g.0.peg.424	4f2w		0	95.69	232\n",
"kb|g.0.peg.424	4f3k		0	95.69	232\n",
"kb|g.0.peg.424	4f2p		0	95.69	232\n",
"kb|g.0.peg.424	4f1w		0	95.69	232\n",
"kb|g.0.peg.424	4g89		0	90.09	232\n",
"kb|g.0.peg.424	3dp9		0	60.43	230\n",
"kb|g.0.peg.424	4qez		0	56.82	220\n",
"kb|g.0.peg.424	4gmh		0	54.63	227\n",
"kb|g.0.peg.424	3bl6		0	54.59	229\n",
"kb|g.0.peg.424	3eei		0	49.56	228\n",
"kb|g.0.peg.424	4kn5		0	42.34	222\n",
"kb|g.0.peg.424	1zos		0	41.48	229\n",
"kb|g.0.peg.424	3mms		0	41.48	229\n",
"kb|g.0.peg.424	4g41		0	41.48	229\n",
"kb|g.0.peg.424	4l0m		0	38.46	234\n",
"kb|g.0.peg.424	4jos		0	36.4	228\n",
"kb|g.0.peg.424	4jwt		0	36.24	229\n",
"kb|g.0.peg.424	3nm6		0	34.76	233\n",
"kb|g.0.peg.424	3nm5		0	34.76	233\n",
"kb|g.0.peg.424	3nm4		0	34.76	233\n",
"kb|g.0.peg.424	4ojt		0	34.76	233\n",
"kb|g.0.peg.424	4ffs		0	34.76	233\n",
"kb|g.0.peg.424	4bmx		0	34.33	233\n",
"kb|g.0.peg.424	4p54		0	34.33	233\n",
"kb|g.0.peg.424	4bn0		0	33.91	233\n",
"kb|g.0.peg.424	4bmz		0	33.91	233\n",
"kb|g.0.peg.424	4bmy		0	33.91	233\n"
);


is_deeply( \@output, \@expected, "output checks" );
print @output;

$t->run( args => "--url=$service_url", stdin => <<EndOfInput );
kb|g.0.peg.2909
EndOfInput

ok( $? == 0, "Running $prog again" );
print $t->stderr;
my @output = $t->stdout;
my @expected = (
"kb|g.0.peg.2909	1cs0	(B,D,F,H)	1	100	382\n",
"kb|g.0.peg.2909	1kee	(B,D,F,H)	1	100	382\n"
);
is_deeply( \@output, \@expected, "output checks" );
print @output;

done_testing();
print "$0 ends.\n";



