package Bio::KBase::KBaseProteinStructure::KBaseProteinStructureImpl;
use strict;
use Bio::KBase::Exceptions;
# Use Semantic Versioning (2.0.0-rc.1)
# http://semver.org 
our $VERSION = "0.1.0";

=head1 NAME

KBaseProteinStructure

=head1 DESCRIPTION

Service for all ......R 

Sean, please refer... 
https://trac.kbase.us/projects/kbase/wiki/StandardDocuments

=cut

#BEGIN_HEADER

# TODO:
#   1) do we put all aux file names into deploy.cfg?
#      a) pdb md5 list
#      b) pdb res data
#      c) pdb blast db
#   2) Error handling (and recovery?) for 
#        a) all CMDI connections
#        b) existence and readability of aux files
#        c) existence and execution of blastp
#        d) blast execution
#   3) how to adjust or pass alternate percent id thresholds?
#       same for match length?
#   4) preparation of aux files?
#   5) how to test?
#   6) scheme for setting a cutoff evalue for blastp?
#
use Bio::KBase::CDMI::CDMIClient;
use Bio::KBase::Utilities::ScriptThing;


# TODO:  do we need to put these files into deploy.cfg?

# this creates a MD5-indexed hash table connecting the unique protein sequence MD5
# to a list reference of pdb IDs coupled with chain ids (in cases where there are 
# different chain sequences in a structure)

sub  load_md5_pdb_table
   {
    my $self = shift;
    my $md5pdbfile = "/home/ubuntu/Auxfiles/pdb.md5.tab";

    open( MDP, $md5pdbfile ) || die "Can't open $md5pdbfile: $!\n";
    $self->{'md5pdbtab'} = {};
    my $r = $self->{'md5pdbtab'};
    while ( $_ = <MDP> )
       {
        chomp;
        s/^\s+//;
        my ($md5,$pdb_id,$chains) = split( /\s+/ );
        $self->{'md5pdbtab'}->{$md5} = [] unless( defined( $self->{'md5pdbtab'}->{$md5} ) );
        push( @{$self->{'md5pdbtab'}->{$md5}}, [ $pdb_id, $chains ] );
       }
    close( MDP );
    print STDERR "LOADED MD5 PDB TABLE  two\n";
   }


sub  load_res_aux_table
   {
    my $self = shift;
    my $auxpdbfile = "/home/ubuntu/Auxfiles/pdb.res.cofactors.tab";

    open( AUX, $auxpdbfile ) || die "Can't open $auxpdbfile: $!\n";
    $self->{'pdbres'} = {};
    while ( $_ = <AUX> )
       {
        chomp;
        s/^\s*//;
        my ( $pdb_id, $res, $cofactor, $engineered ) = split( /\s+/ );
        $res = '-1' if ( $res eq 'NA' );
        $self->{'pdbres'}->{$pdb_id} = $res;
       }
    close( AUX );
    print STDERR "LOADED PDB RES TABLE\n";
   }

# cdm_md5_to_md5_sequences() and cdm_fids_to_md5_sequences() both return
# tables, keyed or indexed by the ids in each case, to listref of [ md5, seq ]
#   in the case of cdm_md5_to_md5_sequences, the md5 is redundant with the 
# input id, but that makes the processing by get_matches() the same
# in either case

sub  cdm_md5_to_md5_sequences
   {
    my $self = shift;
    my $md5s = shift;

    my $h = $self->{'cdmi'}->get_entity_ProteinSequence( $md5s, ['sequence']);

    die "no h\n" unless( $h );

    # make a result hash id (md5) -> [ md5, sequence ]

    my $md5_seq_tab = {};
    map { $md5_seq_tab->{$h->{$_}->{'id'}} = [ $h->{$_}->{'id'}, $h->{$_}->{'sequence'} ] } keys( %{$h} );

    return( $md5_seq_tab );
   }

#
# This takes as input a list of feature ids, and returns a hash table which maps
#  the feature id to a listref of both md5 id, and protein sequence  
#      fid -> [ md5, seq ]
#  as obtained from central store.
# (Note:  CMDIClient::get_relationship_Produces() seems to return a one-to-one
#  mapping.  I don't know how to verify this)
#
sub  cdm_fids_to_md5_sequnces
   {
    my $self = shift;
    my $fids = shift;
    my $prods = $self->{'cdmi'}->get_relationship_Produces( $fids, 
                                                            ['id'], 
                                                            ['from_link','to_link'],
                                                            ['id','sequence'] );

    # TODO: error handling if get_relationship_Produces() failes?

    my $md5_seq_tab = {};
    foreach my $r ( @{$prods} )
       {
        my $fid = $$r[0]->{'id'};
        # TODO: insert error check here for multiple hit on
        #       $md5_seq_tab->{$fid} - this should not exist already. If it does
        #       then its a duplicate.  Then what?
        $md5_seq_tab->{$fid} = [ map( $$r[2]->{$_}, ( 'id', 'sequence' ) ) ];
       }
    return( $md5_seq_tab );
   }

# get_matches assembles (and sorts) the final results hash reference
# for both lookup functions

sub  get_matches
   {
    my $self = shift;
    my $input_ids = shift;
    my $md5_seqs = shift;

    my $results = {};                    # indexed by id (either md5 or fids)
    foreach my $id ( @{$input_ids} )     # for each input id
       {
        $results->{$id} = [] unless( defined( $results->{$id} ) );   # initialize results list
        my ($md5,$protseq) = @{$md5_seqs->{$id}};
        my $seqlength = length( $protseq );                          # length for alignment cutoff

        # TODO: put in error handling - what if the record didn't come back?

        if ( defined( $self->{'md5pdbtab'}->{$md5} ) )               # if we have exact PDB 
           {                                                         # matches, then use those
            foreach my $r ( @{$self->{'md5pdbtab'}->{$md5}} )
               {
                push( @{$results->{$id}}, { 'pdb_id'       => $$r[0], 
                                            'chains'       => $$r[1],
                                            'resolution'   => $self->{'pdbres'}->{$$r[0]},   # CAUTION! ERROR HANDLING HERE!
                                            'exact'        => 1,
                                            'percent_id'   => 100.0,
                                            'align_length' => $seqlength
                                          } );
               }
           }
        else                                                         # no exact match, so try a blast search
           {
            my $seqfile = "/tmp/kbsl$$.fasta";                       # put the sequence into a tmp fasta
                open( TMPSEQ, ">$seqfile" ) || die "Can't write to $seqfile: $!\n";
            print TMPSEQ ">$md5\n";
            print TMPSEQ $protseq, "\n";
            #
            # TODO: probably should put a reasonable cutoff on evalue or score to reduce
            #       output size.  
            open( BLAST, "blastp -db /home/ubuntu/Auxfiles/pdb_md5_prot -outfmt 7 -query $seqfile|" )
               || die "can't blastp: $!\n";

            while ( $_ = <BLAST> )
	       {
                next if ( /^#/ );                                   # TODO maybe check for header here?
                my ($seqid, $pdb_md5_id, $percent_id, $alen) = split( /\s+/ );
                if ( $percent_id >= 70.0 && (100.0 * $alen / $seqlength ) > 90.0 )
                   {
                    my $hits = $self->{'md5pdbtab'}->{$pdb_md5_id};
                    if ( $hits )
                       {
                        foreach my $r ( @{$hits} )
                           {
                            push( @{$results->{$id}}, { 'pdb_id'       => $$r[0], 
                                                        'chains'       => $$r[1],
                                                        'resolution'   => $self->{'pdbres'}->{$$r[0]},   # CAUTION! ERROR HANDLING HERE!
                                                        'exact'        => 0,
                                                        'percent_id'   => $percent_id,
                                                        'align_length' => $alen         # length of seq
                                                       } );
                           }
                       }
		   }
               }
            close( BLAST );
            unlink( $seqfile ) || die "Can't unlink $seqfile: $!\n";        # clean up 
           }            
       }

    # sort multiple hits for each input md5
    foreach my $id ( keys( %{$results} ) )
       {
        @{$results->{$id}} = sort { 
                                     if ( $a->{'percent_id'} != $b->{'percent_id'} )
                                        { return( $b->{'percent_id'} <=> $a->{'percent_id'} ); }
                                     else
                                        { return( $a->{'resolution'} <=> $b->{'resolution'} ); }
                                   } 
                                   ( @{$results->{$id}} );
       }

    return( $results );
   }

#END_HEADER

sub new
{
    my($class, @args) = @_;
    my $self = {
    };
    bless $self, $class;
    #BEGIN_CONSTRUCTOR

    # establish initial connection to central store.
    # TODO:  best way to handle error here.

    ${$self}{'cdmi'} = Bio::KBase::CDMI::CDMIClient->new_for_script();    

    $self->load_md5_pdb_table();

    $self->load_res_aux_table();

    #END_CONSTRUCTOR

    if ($self->can('_init_instance'))
    {
	$self->_init_instance();
    }
    return $self;
}

=head1 METHODS



=head2 lookup_pdb_by_md5

  $results = $obj->lookup_pdb_by_md5($input_ids)

=over 4

=item Parameter and return types

=begin html

<pre>
$input_ids is a md5_ids_t
$results is a md5_to_pdb_matches
md5_ids_t is a reference to a list where each element is a md5_id_t
md5_id_t is a string
md5_to_pdb_matches is a reference to a hash where the key is a md5_id_t and the value is a PDBMatches
PDBMatches is a reference to a list where each element is a PDBMatch
PDBMatch is a reference to a hash where the following keys are defined:
	pdb_id has a value which is a pdb_id_t
	chains has a value which is a chains_t
	resolution has a value which is a resolution_t
	exact has a value which is an exact_t
	percent_id has a value which is a percent_id_t
	align_length has a value which is an align_length_t
pdb_id_t is a string
chains_t is a string
resolution_t is a float
exact_t is an int
percent_id_t is a float
align_length_t is an int

</pre>

=end html

=begin text

$input_ids is a md5_ids_t
$results is a md5_to_pdb_matches
md5_ids_t is a reference to a list where each element is a md5_id_t
md5_id_t is a string
md5_to_pdb_matches is a reference to a hash where the key is a md5_id_t and the value is a PDBMatches
PDBMatches is a reference to a list where each element is a PDBMatch
PDBMatch is a reference to a hash where the following keys are defined:
	pdb_id has a value which is a pdb_id_t
	chains has a value which is a chains_t
	resolution has a value which is a resolution_t
	exact has a value which is an exact_t
	percent_id has a value which is a percent_id_t
	align_length has a value which is an align_length_t
pdb_id_t is a string
chains_t is a string
resolution_t is a float
exact_t is an int
percent_id_t is a float
align_length_t is an int


=end text



=item Description

of each to a list of PDBMatch records

=back

=cut

sub lookup_pdb_by_md5
{
    my $self = shift;
    my($input_ids) = @_;

    my @_bad_arguments;
    (ref($input_ids) eq 'ARRAY') or push(@_bad_arguments, "Invalid type for argument \"input_ids\" (value was \"$input_ids\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to lookup_pdb_by_md5:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'lookup_pdb_by_md5');
    }

    my $ctx = $Bio::KBase::KBaseProteinStructure::Service::CallContext;
    my($results);
    #BEGIN lookup_pdb_by_md5

    my $md5_seqs = $self->cdm_md5_to_md5_sequences( $input_ids );

    my $results = $self->get_matches( $input_ids, $md5_seqs );

    #END lookup_pdb_by_md5
    my @_bad_returns;
    (ref($results) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"results\" (value was \"$results\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to lookup_pdb_by_md5:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'lookup_pdb_by_md5');
    }
    return($results);
}




=head2 lookup_pdb_by_fid

  $results = $obj->lookup_pdb_by_fid($feature_ids)

=over 4

=item Parameter and return types

=begin html

<pre>
$feature_ids is a feature_ids_t
$results is a fid_to_pdb_matches
feature_ids_t is a reference to a list where each element is a feature_id_t
feature_id_t is a string
fid_to_pdb_matches is a reference to a hash where the key is a feature_id_t and the value is a PDBMatches
PDBMatches is a reference to a list where each element is a PDBMatch
PDBMatch is a reference to a hash where the following keys are defined:
	pdb_id has a value which is a pdb_id_t
	chains has a value which is a chains_t
	resolution has a value which is a resolution_t
	exact has a value which is an exact_t
	percent_id has a value which is a percent_id_t
	align_length has a value which is an align_length_t
pdb_id_t is a string
chains_t is a string
resolution_t is a float
exact_t is an int
percent_id_t is a float
align_length_t is an int

</pre>

=end html

=begin text

$feature_ids is a feature_ids_t
$results is a fid_to_pdb_matches
feature_ids_t is a reference to a list where each element is a feature_id_t
feature_id_t is a string
fid_to_pdb_matches is a reference to a hash where the key is a feature_id_t and the value is a PDBMatches
PDBMatches is a reference to a list where each element is a PDBMatch
PDBMatch is a reference to a hash where the following keys are defined:
	pdb_id has a value which is a pdb_id_t
	chains has a value which is a chains_t
	resolution has a value which is a resolution_t
	exact has a value which is an exact_t
	percent_id has a value which is a percent_id_t
	align_length has a value which is an align_length_t
pdb_id_t is a string
chains_t is a string
resolution_t is a float
exact_t is an int
percent_id_t is a float
align_length_t is an int


=end text



=item Description



=back

=cut

sub lookup_pdb_by_fid
{
    my $self = shift;
    my($feature_ids) = @_;

    my @_bad_arguments;
    (ref($feature_ids) eq 'ARRAY') or push(@_bad_arguments, "Invalid type for argument \"feature_ids\" (value was \"$feature_ids\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to lookup_pdb_by_fid:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'lookup_pdb_by_fid');
    }

    my $ctx = $Bio::KBase::KBaseProteinStructure::Service::CallContext;
    my($results);
    #BEGIN lookup_pdb_by_fid

    my $md5_seqs = $self->cdm_fids_to_md5_sequences( $feature_ids );

    my $results = $self->get_matches( $feature_ids, $md5_seqs );

    #END lookup_pdb_by_fid
    my @_bad_returns;
    (ref($results) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"results\" (value was \"$results\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to lookup_pdb_by_fid:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'lookup_pdb_by_fid');
    }
    return($results);
}




=head2 version 

  $return = $obj->version()

=over 4

=item Parameter and return types

=begin html

<pre>
$return is a string
</pre>

=end html

=begin text

$return is a string

=end text

=item Description

Return the module version. This is a Semantic Versioning number.

=back

=cut

sub version {
    return $VERSION;
}

=head1 TYPES



=head2 md5_id_t

=over 4



=item Description

Inputs to services:


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 md5_ids_t

=over 4



=item Description

KBase protein MD5 id


=item Definition

=begin html

<pre>
a reference to a list where each element is a md5_id_t
</pre>

=end html

=begin text

a reference to a list where each element is a md5_id_t

=end text

=back



=head2 feature_id_t

=over 4



=item Description

list of protein MD5s


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 feature_ids_t

=over 4



=item Description

KBase feature id, ala "kb|g.0.peg.781"


=item Definition

=begin html

<pre>
a reference to a list where each element is a feature_id_t
</pre>

=end html

=begin text

a reference to a list where each element is a feature_id_t

=end text

=back



=head2 pdb_id_t

=over 4



=item Description

Outputs from service


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 chains_t

=over 4



=item Description

PDB id


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 exact_t

=over 4



=item Description

subchains of a match, i.e. "(A,C,D)"


=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 resolution_t

=over 4



=item Description

1 (true) if exact match to pdb sequence


=item Definition

=begin html

<pre>
a float
</pre>

=end html

=begin text

a float

=end text

=back



=head2 percent_id_t

=over 4



=item Description

structural resolution (angstroms)


=item Definition

=begin html

<pre>
a float
</pre>

=end html

=begin text

a float

=end text

=back



=head2 align_length_t

=over 4



=item Description

% identity from BLASTP matches


=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 PDBMatch

=over 4



=item Description

alignment length


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
pdb_id has a value which is a pdb_id_t
chains has a value which is a chains_t
resolution has a value which is a resolution_t
exact has a value which is an exact_t
percent_id has a value which is a percent_id_t
align_length has a value which is an align_length_t

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
pdb_id has a value which is a pdb_id_t
chains has a value which is a chains_t
resolution has a value which is a resolution_t
exact has a value which is an exact_t
percent_id has a value which is a percent_id_t
align_length has a value which is an align_length_t


=end text

=back



=head2 PDBMatches

=over 4



=item Definition

=begin html

<pre>
a reference to a list where each element is a PDBMatch
</pre>

=end html

=begin text

a reference to a list where each element is a PDBMatch

=end text

=back



=head2 md5_to_pdb_matches

=over 4



=item Description

list of the same


=item Definition

=begin html

<pre>
a reference to a hash where the key is a md5_id_t and the value is a PDBMatches
</pre>

=end html

=begin text

a reference to a hash where the key is a md5_id_t and the value is a PDBMatches

=end text

=back



=head2 fid_to_pdb_matches

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the key is a feature_id_t and the value is a PDBMatches
</pre>

=end html

=begin text

a reference to a hash where the key is a feature_id_t and the value is a PDBMatches

=end text

=back



=cut

1;
