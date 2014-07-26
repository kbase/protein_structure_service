package prot_struct_test_utils;

use strict;
use Test::More;
use Exporter;
use vars qw( $VERSION  @ISA @EXPORT );

$VERSION = 0.1;
@ISA = qw( Exporter );
@EXPORT = qw( check_matches_structure
              check_md5_data_struct 
              check_fid_data_struct
              check_md5_examples
              check_fid_examples
              $service_url
              $deploy_dir );

#our $service_url = "http://140.221.85.122:7088";
#our $service_url = "http://localhost:7088";
our $service_url = "https://kbase.us/services/protein_structure_service";
our $deploy_dir = "/kb/deployment/services/protein_structure_service";

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


sub  check_md5_data_struct
   {
    my $pss = shift;
    my $mat = $pss->lookup_pdb_by_md5( [ 'af1975d214436f018b10a0c161867236' ] );

    ok( defined( $mat ), "got a result" );

    check_matches_structure( $mat );
   }

sub  check_fid_data_struct
   {
    my $pss = shift;
    my $mat = $pss->lookup_pdb_by_fid( [ 'kb|g.0.peg.424' ] );

    ok( defined( $mat ), "got a result" );

    check_matches_structure( $mat );
   }

my $md5_example1 = {
          'f50a2d83cd0a3b1aa7b76ffcd4dedf40' => [
                                                  {
                                                    'percent_id' => '86.62',
                                                    'pdb_id' => '2ht1',
                                                    'exact' => 0,
                                                    'align_length' => 411,
                                                    'chains' => ''
                                                  },
                                                  {
                                                    'percent_id' => '86.36',
                                                    'pdb_id' => '1pvo',
                                                    'exact' => 0,
                                                    'align_length' => 418,
                                                    'chains' => ''
                                                  },
                                                  {
                                                    'percent_id' => '86.36',
                                                    'pdb_id' => '1xpu',
                                                    'exact' => 0,
                                                    'align_length' => 418,
                                                    'chains' => ''
                                                  },
                                                  {
                                                    'percent_id' => '86.36',
                                                    'pdb_id' => '1xpr',
                                                    'exact' => 0,
                                                    'align_length' => 418,
                                                    'chains' => ''
                                                  },
                                                  {
                                                    'percent_id' => '86.36',
                                                    'pdb_id' => '1pv4',
                                                    'exact' => 0,
                                                    'align_length' => 418,
                                                    'chains' => ''
                                                  },
                                                  {
                                                    'percent_id' => '86.36',
                                                    'pdb_id' => '1xpo',
                                                    'exact' => 0,
                                                    'align_length' => 418,
                                                    'chains' => ''
                                                  },
                                                  {
                                                    'percent_id' => '86.36',
                                                    'pdb_id' => '3ice',
                                                    'exact' => 0,
                                                    'align_length' => 418,
                                                    'chains' => ''
                                                  },
                                                  {
                                                    'percent_id' => '54.48',
                                                    'pdb_id' => '3l0o',
                                                    'exact' => 0,
                                                    'align_length' => 413,
                                                    'chains' => ''
	      }
                                                ]
        };

my $md5_example2 = {
          'af1975d214436f018b10a0c161867236' => [
                                                  {
                                                    'percent_id' => 100,
                                                    'pdb_id' => '4bl0',
                                                    'exact' => 1,
                                                    'align_length' => 341,
                                                    'chains' => '(A,D)'
                                                  },
                                                  {
                                                    'percent_id' => 100,
                                                    'pdb_id' => '2i3t',
                                                    'exact' => 1,
                                                    'align_length' => 341,
                                                    'chains' => '(A,C,E,G)'
                                                  }
                                                ]
        };

my $fid_example1 = {
          'kb|g.0.peg.2909' => [
                                 {
                                   'percent_id' => 100,
                                   'pdb_id' => '1cs0',
                                   'exact' => 1,
                                   'align_length' => 382,
                                   'chains' => '(B,D,F,H)'
                                 },
                                 {
                                   'percent_id' => 100,
                                   'pdb_id' => '1kee',
                                   'exact' => 1,
                                   'align_length' => 382,
                                   'chains' => '(B,D,F,H)'
                                  }
                               ]

        };

my $fid_example2 = {
          'kb|g.216.peg.2666' => [
                                   {
                                     'percent_id' => '50.11',
                                     'pdb_id' => '3hsi',
                                     'exact' => 0,
                                     'align_length' => 451,
                                     'chains' => ''
                                   }
                                 ]
        };

sub  check_md5_examples
   {
    my $pss = shift;

    foreach my $m ( keys( %{$md5_example1} ) )
       {
        my $mat = $pss->lookup_pdb_by_md5( [ $m ] );
        is_deeply( $mat, $md5_example1, "is deeply $m" );
       }
    foreach my $m ( keys( %{$md5_example2} ) )
       {
        my $mat = $pss->lookup_pdb_by_md5( [ $m ] );
        is_deeply( $mat, $md5_example2, "is deeply $m" );
       }
   }

sub  check_fid_examples
   {
    my $pss = shift;

    foreach my $f ( keys( %{$fid_example1} ) )
       {
        my $mat = $pss->lookup_pdb_by_fid( [ $f ] );
        is_deeply( $mat, $fid_example1, "is deeply $f" );
       }
    foreach my $f ( keys( %{$fid_example2} ) )
       {
        my $mat = $pss->lookup_pdb_by_fid( [ $f ] );
        is_deeply( $mat, $fid_example2, "is deeply $f" );
       }
   }


1;
