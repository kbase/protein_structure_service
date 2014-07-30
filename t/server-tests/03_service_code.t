#
# test service perl module (unit test?)
#

use strict;
use Test::More;
use Bio::KBase::KBaseProteinStructure::KBaseProteinStructureImpl;
use FindBin;
use lib "$FindBin::Bin/../lib";
use prot_struct_test_utils;

print "$0 begins.\n";

#
# There's a problem here, not sure how to handle.  This really should have
# the environment variable $KB_DEPLOYMENT_CONFIG set to point to the deploy.cfg
# file beforehand.  If the environment variable isn't set, the Impl module code 
# currently defaults to looking in a hard-coded directory name for the pdb auxiliary 
# files, but thats kind of ugly.  
#
my $pss = Bio::KBase::KBaseProteinStructure::KBaseProteinStructureImpl->new();

ok( defined( $pss ), "KBaseProteinStructureImpl constructor returned non-null" );

isa_ok( $pss, "Bio::KBase::KBaseProteinStructure::KBaseProteinStructureImpl", 
              "got a KBaseProteinStructureImpl object" );

can_ok( $pss, ( 'lookup_pdb_by_md5', 'lookup_pdb_by_fid', 'lookup_pdb_by_seq' ) );

#
# check the returned data structure for an MD5 lookup
#
check_md5_data_struct( $pss );

#
# check the returned structure for a  FID lookup
#
check_fid_data_struct( $pss );

#
# data_checks
#
check_md5_examples( $pss );

check_fid_examples( $pss );

check_seq_examples( $pss );

done_testing();

print "$0 ends.\n";