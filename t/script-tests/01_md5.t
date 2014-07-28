#
# test prst-lookup-pdb-by-md5.pl using Test::Cmd
#
#  usage:  perl 01_md5.t   [--perl_interp=/kb/runtime/bin/perl]
#                          [--url=https://kbase.us/services/protein_structure_service]
#                          [--bindir=scripts]
#                          [--help]
#
use strict;
use Test::More;
use Test::Cmd;
use Getopt::Long;
use FindBin;
use lib "$FindBin::Bin/../lib";
use prot_struct_test_utils;     # defines $service_url

my $prog='prst-lookup-pdb-by-md5';

my $usage_msg="usage:  perl 01_md5.t   [--perl_interp=/kb/runtime/bin/perl]\n" .
              "                        [--url=https://kbase.us/services/protein_structure_service]\n" .
              "                        [--bindir=scripts]\n" .
              "                        [--help]\n";

my $perl_interp = '/kb/runtime/bin/perl';
my $url         = $service_url;
my $bindir      = "scripts";
my $help        = "";
GetOptions( "perl_interp=s" => \$perl_interp,
            "url=s"         => \$url,
            "bindir=s"      => \$bindir,
            "help"          => \$help
          ) || die $usage_msg;

if ( $help )
   {
    print $usage_msg;
    exit;
   }

print "$0 starts.\n";
print "url is [$url]\n";

my $t = Test::Cmd->new( prog        => "$bindir/$prog.pl", 
                        workdir     => '', 
                        interpreter => $perl_interp
                      );
ok( $t, "creating Test::Cmd object for md5 test" );

$t->run( args => "--url=$url", stdin => <<EndOfInput );
f50a2d83cd0a3b1aa7b76ffcd4dedf40
EndOfInput

ok( $? == 0, "Running $prog" );
print $t->stderr;
my @output = $t->stdout;
my @expected = (
"f50a2d83cd0a3b1aa7b76ffcd4dedf40	2ht1		0	86.62	411\n",
"f50a2d83cd0a3b1aa7b76ffcd4dedf40	1pvo		0	86.36	418\n",
"f50a2d83cd0a3b1aa7b76ffcd4dedf40	1xpu		0	86.36	418\n",
"f50a2d83cd0a3b1aa7b76ffcd4dedf40	1xpr		0	86.36	418\n",
"f50a2d83cd0a3b1aa7b76ffcd4dedf40	1pv4		0	86.36	418\n",
"f50a2d83cd0a3b1aa7b76ffcd4dedf40	1xpo		0	86.36	418\n",
"f50a2d83cd0a3b1aa7b76ffcd4dedf40	3ice		0	86.36	418\n",
"f50a2d83cd0a3b1aa7b76ffcd4dedf40	3l0o		0	54.48	413\n"
 );

is_deeply( \@output, \@expected, "output checks" );
print @output;

$t->run( args => "--url=$url", stdin => <<EndOfInput );
55cf059bb4bc9d3e3ecdae6e3ab0fac2
EndOfInput

ok( $? == 0, "Running $prog again" );
print $t->stderr;
my @output = $t->stdout;
my @expected = (
"55cf059bb4bc9d3e3ecdae6e3ab0fac2	3s5w		0	100	234\n",
"55cf059bb4bc9d3e3ecdae6e3ab0fac2	3s61		0	100	234\n",
"55cf059bb4bc9d3e3ecdae6e3ab0fac2	4b67		0	40.74	243\n",
"55cf059bb4bc9d3e3ecdae6e3ab0fac2	4b66		0	40.74	243\n",
"55cf059bb4bc9d3e3ecdae6e3ab0fac2	4b69		0	40.74	243\n",
"55cf059bb4bc9d3e3ecdae6e3ab0fac2	4b63		0	40.74	243\n",
"55cf059bb4bc9d3e3ecdae6e3ab0fac2	4b65		0	40.74	243\n",
"55cf059bb4bc9d3e3ecdae6e3ab0fac2	4b64		0	40.74	243\n",
"55cf059bb4bc9d3e3ecdae6e3ab0fac2	4b68		0	40.74	243\n"
);
is_deeply( \@output, \@expected, "output checks" );
print @output;

done_testing();
print "$0 ends.\n";



