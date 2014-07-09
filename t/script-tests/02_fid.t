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

my $t = Test::Cmd->new( prog        => 'scripts/$prog.pl', 
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
"kb|g.0.peg.424	4g89		0	90.09	232\n");


is_deeply( \@output, \@expected, "output checks" );
print @output;

$t->run( args => "--url=$service_url", stdin => <<EndOfInput );
kb|g.0.peg.3150
EndOfInput

ok( $? == 0, "Running $prog again" );
print $t->stderr;
my @output = $t->stdout;
my @expected = (
"kb|g.0.peg.3150	1usk		0	99.71	346\n",
"kb|g.0.peg.3150	1usg		0	99.71	346\n",
"kb|g.0.peg.3150	1usi		0	99.71	346\n",
"kb|g.0.peg.3150	2lbp		0	98.84	346\n",
"kb|g.0.peg.3150	1z16		0	78.9	346\n",
"kb|g.0.peg.3150	1z18		0	78.9	346\n",
"kb|g.0.peg.3150	1z17		0	78.9	346\n",
"kb|g.0.peg.3150	1z15		0	78.9	346\n",
"kb|g.0.peg.3150	2liv		0	78.61	346\n"
);
is_deeply( \@output, \@expected, "output checks" );
print @output;

done_testing();
print "$0 ends.\n";



