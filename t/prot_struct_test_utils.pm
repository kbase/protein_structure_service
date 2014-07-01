package prot_struct_test_utils;

use strict;
use Test::More;
use Exporter;
use vars qw( $VERSION  @ISA @EXPORT );

$VERSION = 0.1;
@ISA = qw( Exporter );
@EXPORT = qw( check_matches_structure );

sub  check_matches_structure
   {
    my $mat = shift;

    my @fields = ( 'pdb_id', 'chains', 'exact', 'percent_id', 'align_length'  );

    print "check matches structure\n";
    isa_ok( $mat, 'HASH', "mat" );
    my @matkeys = keys( %{$mat} );

    foreach my $mk ( keys( %{$mat} ) )
       {
        isa_ok( $mat->{$mk}, 'ARRAY', "$mk results" );
        foreach my $mrec ( @{$mat->{$mk}} )
           {
            isa_ok( $mrec, 'HASH', "mrec" );
            is( keys( %{$mrec} ), 5, "mrec has 5 fields" );
            foreach my $k ( @fields )
               {
               	ok( defined( $mrec->{$k}), "  $k is present" );
               }
           }
       }
    print "check matches structure finished\n";

   }


1;