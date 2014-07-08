#!/usr/bin/perl
use strict;
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;

=head1 NAME

prst-lookup-pdb-by-fid - find Protein Data Bank (PDB) structure ids whose protein sequences 
match coding sequences of KBase sequences specified by feature (or CDS) ids.

=head1 SYNOPSIS

prst-lookup-pdb-by-fid [--url=http://kbase.us/services/protein_structure_service]  < geneIDsList

=head1 DESCRIPTION

Use this to determine any PDB sequences matches to KBase coding sequence features.

=head2 Documentation for underlying call

    For each in a given list of KBase protein feature ids, the service
    first checks the PDB protein sequences for exact matches, using
    MD5 keys, and if found, reports those.  If no exact matches are
    found, a blastp search of the PDB sequences is conducted.
    Currently, any hits with more than 70% identity with an alignment
    length of %90 of the KBase sequence are reported.

=head2 Output columns

       pdb_id       - PDB identifier
       chains       - if KBase sequence only matches some of the chains in the PDB entry, 
                      those chains are reported.
       exact        - 1 if exact match was found, 0 otherwise 
       percent_id   - % identity of match
       align_length - alignment length of match (aa)
    

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

 echo "kb|g.1.peg.5084" | prst-lookup-pdb-by-fid
 prst-lookup-pdb-by-fid --help
 prst-lookup-pdb-by-fid --version
 

=head1 VERSION

0.01

=cut

use Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient;

#my $service_url = "http://kbase.us/services/protein_structure";
#my $service_url = "http://localhost:7088";
my $service_url = "http://140.221.85.122:7088";

my $usage = "Usage: $0 [--help --version] [--url=$service_url]  < fid_list \n";

my $url        = $service_url;
my $help       = '';
my $version    = '0.01';
my $verbose    = '';

GetOptions( "help"       => \$help,
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

print "performing lookup_pdb_by_fid\n" if ( $verbose );
my $pdb_match_records = $psc->lookup_pdb_by_fid( \@input );
if ( $verbose )
   {
    print "back from lookup_pdb_by_fid\n";
    print Dumper( $pdb_match_records );
   }

# print hits
my @fields = ( 'pdb_id', 'chains', 'exact', 'percent_id', 'align_length'  );

foreach my $fid ( @input )
   {
    print "$fid is $fid\n" if ( $verbose );

    if ( my $matchl = $pdb_match_records->{$fid} )
       {
       	foreach my $match ( @{$matchl} )
       	   { print join( "\t", $fid, map( $match->{$_}, @fields ) ), "\n"; }
       }
   }
print "program $0 ends.\n" if ( $verbose );


                                 ###############
                                 # Subroutines #
                                 ###############

sub  help_then_exit
   {
    pod2usage( -verbose => 2 );
    exit(0);
   }


sub  version_then_exit
   {
    print "$0 version $version\n";
    #print "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.\n";
    #print "This is free software: you are free to change and redistribute it.\n";
    #print "There is NO WARRANTY, to the extent permitted by law.\n";
    print "\n";
    print "Programmer: Sean McCorkle\n";
   }
