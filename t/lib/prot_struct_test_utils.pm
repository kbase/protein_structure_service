package prot_struct_test_utils;

use strict;
use Test::More;
use Exporter;
use vars qw( $VERSION  @ISA @EXPORT );

$VERSION = 0.1;
@ISA = qw( Exporter );
@EXPORT = qw( check_matches_structure check_md5_data_struct check_fid_data_struct
              check_md5_examples check_fid_examples );

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
          'kb|g.0.peg.424' => [
                                {
                                  'percent_id' => 100,
                                  'pdb_id' => '3o4v',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => 100,
                                  'pdb_id' => '3df9',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => 100,
                                  'pdb_id' => '1nc3',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => 100,
                                  'pdb_id' => '1y6r',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => 100,
                                  'pdb_id' => '1z5p',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => 100,
                                  'pdb_id' => '1nc1',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => 100,
                                  'pdb_id' => '1jys',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => 100,
                                  'pdb_id' => '1y6q',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => '99.57',
                                  'pdb_id' => '1z5n',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => '99.57',
                                  'pdb_id' => '1z5o',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => '95.69',
                                  'pdb_id' => '4f3c',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => '95.69',
                                  'pdb_id' => '4f2w',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => '95.69',
                                  'pdb_id' => '4f3k',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => '95.69',
                                  'pdb_id' => '4f2p',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => '95.69',
                                  'pdb_id' => '4f1w',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                },
                                {
                                  'percent_id' => '90.09',
                                  'pdb_id' => '4g89',
                                  'exact' => 0,
                                  'align_length' => 232,
                                  'chains' => ''
                                }
                              ]
        };

my $fid_example2 = {
          'kb|g.0.peg.2350' => [
                                 {
                                   'percent_id' => 100,
                                   'pdb_id' => '4iot',
                                   'exact' => 1,
                                   'align_length' => 255,
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
