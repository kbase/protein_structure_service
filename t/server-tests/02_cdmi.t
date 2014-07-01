#
# check the connection to the Central Store
#

use strict;
use Test::More;
use Bio::KBase::CDMI::CDMIClient;

print "$0 begins.\n";

my $cdmi = Bio::KBase::CDMI::CDMIClient->new_for_script();

ok( defined( $cdmi ), "CDMIClient constructor returned non-null" );

isa_ok( $cdmi, "Bio::KBase::CDMI::Client", "got a CDMIClient object" );

can_ok( $cdmi, ( 'get_relationship_Produces', 'get_entity_ProteinSequence' ) );

# should we add a few test calls for known data?  (will db data ever vary
# and cause an unintended failure?)

done_testing();
print "$0 ends.\n";
