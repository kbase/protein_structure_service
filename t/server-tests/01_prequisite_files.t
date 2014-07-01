#
# check that prequisite local files and programs are in place.
#

use strict;
use Test::More;

my $filedir = "/kb/deployment/services/KBaseProteinStructure/pdb";

my @files = ( 'pdb_md5_prot.phr',  # BLASTP indices
              'pdb_md5_prot.psq',
              'pdb_md5_prot.pin', 
              'pdb.md5.tab'        # maps MD5 to PDB id
            );
my @programs = ( 'blastp' );

print "$0 starts.\n";

ok( -d $filedir, "directory check of $filedir\n" );

foreach my $f ( @files )
   { ok( -e "$filedir/$f", "check $filedir/$f" ); }

foreach my $p ( @programs )
   { isnt( `which $p`, '', "check program $p" ); }

done_testing();

print "$0 ends.\n";
