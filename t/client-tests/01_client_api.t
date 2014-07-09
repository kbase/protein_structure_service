#
# test KBaseProteinStructure client api 
#
use strict;
use Test::More;
use Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient;
use FindBin;
use lib "$FindBin::Bin/../lib";
use prot_struct_test_utils;

#my $url = "http://140.221.85.122:7088";

print "$0 begins.\n";
print "url is [$service_url]\n";
my $psc = Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient->new( $service_url );

ok( defined( $psc ), "Got something" );

isa_ok( $psc, "Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient", 
              "object class checks out" );

can_ok( $psc, ( 'lookup_pdb_by_md5', 'lookup_pdb_by_fid' ) );
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

done_testing();
print "$0 ends.\n";

