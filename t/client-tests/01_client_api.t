#
# test KBaseProteinStructure client api 
#
#  options:  --url=https://kbase.us/services/protein_structure_service
#
use strict;
use Test::More;
use Getopt::Long;
use Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient;
use FindBin;
use lib "$FindBin::Bin/../lib";
use prot_struct_test_utils;


print "$0 begins.\n";
#my $url = "http://localhost:7088";
my $url = $service_url;

GetOptions( "url=s"      => \$url,
           ) or die "bad option\n$0: [--url=https://kbase.us/services/protein_structure_service]";

print "url is [$service_url]\n";
my $psc = Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient->new( $url );

ok( defined( $psc ), "Got something" );

isa_ok( $psc, "Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient", 
              "object class checks out" );

can_ok( $psc, ( 'lookup_pdb_by_md5', 'lookup_pdb_by_fid', 'lookup_pdb_by_seq' ) );
#
# check the returned data structure for an MD5 lookup
#
check_md5_data_struct( $psc );

#
# check the returned structure for a  FID lookup
#
check_fid_data_struct( $psc );

#
# data_checks
#
check_md5_examples( $psc );

check_fid_examples( $psc );

check_seq_examples( $psc );

done_testing();
print "$0 ends.\n";

