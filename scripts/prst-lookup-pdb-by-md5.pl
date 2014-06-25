#!/usr/bin/perl
use strict;
use Data::Dumper;
use Getopt::Long;
=head1 NAME

prst-lookup-pdb-by-md5 - find PDB structure matches by sequence

=head1 SYNOPSIS

prst-lookup-pdb-by-md5 [--url=http://kbase.us/services/ontology_service] [--domain_list=biological_process,molecular_function,cellular_component] [--evidence_code_list=IEA]  [--test_type=hypergeometric] < geneIDsList

=head1 DESCRIPTION

Use this to determine any PDB sequences

=head2 Documentation for underlying call

    For a given list of kbase protein MD5 ids, look for exact matches in PDB sequences, or barring that, look for near matches with blastp.  Reports matches in order of sequence similarity and structure resolution.

    TODO describe any optional parameters - similariy cutoffs, etc

=head1 OPTIONS

=over 6

=item B<-u> I<[http://kbase.us/services/protein_structure_service]> B<--url>=I<[http://kbase.us/services/protein_structure_service]>
url of the server

=item B<-h> B<--help>
prints help, then exits

=item B<--version>
print version, then exits

=item B<--verbose>
prints verbose output for debugging.


=back

=head1 EXAMPLE

 echo "af1975d214436f018b10a0c161867236" | prst-lookup-pdb-by-md5
 prst-lookup-pdb-by-md5 --help
 prst-lookup-pdb-by-md5 --version
 

=head1 VERSION

0.1

=cut

use Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient;

#my $service_url = "http://kbase.us/services/protein_structure";
#my $service_url = "http://localhost:7088";
my $service_url = "http://140.221.85.122:7088";

my $usage = "Usage: $0 [--help --version] [--url=$service_url]  < MD5_list \n";

my $url        = $service_url;
my $help       = '';
my $version    = '';
my $verbose    = '';

GetOptions("help"       => \$help,
           "version"    => \$version,
           "url=s"      => \$url,
           "verbose"    => \$verbose,
           ) or die $usage;

if ( $help )
   { help_then_exit(); }
elsif ( $version )
   { version_then_exit(); }
die $usage unless @ARGV == 0;

print "url is $url\n" if ( $verbose );

# establish connection to service

my $psc = Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient->new($url);
print "have psc $psc\n" if ( $verbose );

# read input MD5s all at once
my @input = <STDIN>;
my $istr = join(" ", @input);
$istr =~ s/[,]/ /g;
@input = split /\s+/, $istr;

print "performing lookup_pdb_by_md5\n" if ( $verbose );
my $pdb_match_records = $psc->lookup_pdb_by_md5( \@input );
if ( $verbose )
   {
    print "back from lookup_pdb_by_md5\n";
    print Dumper( $pdb_match_records );
   }

# print hits
#my @fields = ( 'pdb_id', 'chains', 'resolution', 'exact', 'percent_id', 'align_len'  );
my @fields = ( 'pdb_id', 'chains', 'exact', 'percent_id', 'align_len'  );

foreach my $md5 ( @input )
   {
    print "md5 is $md5\n" if ( $verbose );

    if ( my $matchl = $pdb_match_records->{$md5} )
       {
       	foreach my $match ( @{$matchl} )
       	   { print join( "\t", $md5, map( $match->{$_}, @fields ) ), "\n"; }
       }
   }
print "program $0 ends.\n" if ( $verbose );


                                 ###############
                                 # Subroutines #
                                 ###############

sub  help_then_exit
   {
    print <<EndOfDescription;
    DESCRIPTION
         For a given list of KBase MD5 protein ids, return PDB ids where the protein sequence is an exact or close match.
EndOfDescription
	print "$usage\n";
	print "\n";
	print "General options\n";
    #print "\t--url=[http://kbase.us/services/ontology_service]\t\turl of the server\n";
	print "\t--help\t\tprint help, then exit\n";
	print "\t--version\t\tprint version, then exit\n";
	print "\t--verbose\t\tverbose messages\n";
	print "\n";
	print "Examples: \n";
	print "\n\n";
    print "\techo f50a2d83cd0a3b1aa7b76ffcd4dedf40 | $0\n";
	print "\n";
	print "Report bugs to Sean McCorkle mccorkle\@bnl.gov\n";
	exit(0);
   }

sub  version_then_exit
   {
	print "$0 version 0.1\n";
	#print "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.\n";
	#print "This is free software: you are free to change and redistribute it.\n";
	#print "There is NO WARRANTY, to the extent permitted by law.\n";
	print "\n";
	print "Programmer: Sean McCorkle\n";
	exit(0);
   }

