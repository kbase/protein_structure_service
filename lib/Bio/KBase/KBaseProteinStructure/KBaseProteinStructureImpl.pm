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

use Bio::KBase::CDMI::CDMIClient;
use Bio::KBase::Utilities::ScriptThing;

sub  get_protein_sequences
   {
    my $self = shift;
    my @md5s = @_;

    my $h = $self->{'cdmi'}->get_entity_ProteinSequence( [ @md5s ], ['sequence']);

    die "no h\n" unless( $h );

    # make a result hash where md5's are keys, protein seq is
    # the value

    my $res = {};
    map { $res->{$h->{$_}->{'id'}} = $h->{$_}->{'sequence'} } keys( %{$h} );

    return( $res );
   }

# do we need to put these files into deploy.cfg?

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
    #foreach my $k ( keys( %{$self->{'md5pdbtab'}} ) )
    #   {
    #    print "$k: ", join( ", ", map( join( " ", @{$_} ), @{$self->{'md5pdbtab'}->{$k}} ) ), "\n";
    #   }
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
$input_ids is a md5_ids
$results is a md5_to_pdb_ids
md5_ids is a reference to a list where each element is a md5_id
md5_id is a string
md5_to_pdb_ids is a reference to a hash where the key is a md5_id and the value is a pdb_ids
pdb_ids is a reference to a list where each element is a pdb_id
pdb_id is a string

</pre>

=end html

=begin text

$input_ids is a md5_ids
$results is a md5_to_pdb_ids
md5_ids is a reference to a list where each element is a md5_id
md5_id is a string
md5_to_pdb_ids is a reference to a hash where the key is a md5_id and the value is a pdb_ids
pdb_ids is a reference to a list where each element is a pdb_id
pdb_id is a string


=end text



=item Description

core function used by many others.  Given a list of KBase SampleIds returns mapping of SampleId to expressionSampleDataStructure (essentially the core Expression Sample Object) : 
{sample_id -> expressionSampleDataStructure}

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

    # should only do this if no direct pdb match?
    my $protseqs = $self->get_protein_sequences( @{$input_ids} );

    my $results = {};
    foreach my $md5 ( @{$input_ids} )
       {
        $results->{$md5} = join( ", ", map( join( " ", @{$_} ), @{$self->{'md5pdbtab'}->{$md5}} ) );

        #$results->{$md5} = [ $protseqs->{$md5} ]; 
       }
        
    #  $results =  { 
    #               "input_m5s" => [ @{$input_ids} ]
    # 		    "test" => [ @prots ],
    #              };
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



=head2 md5_id

=over 4



=item Description

KBase Protein MD5 id


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



=head2 md5_ids

=over 4



=item Definition

=begin html

<pre>
a reference to a list where each element is a md5_id
</pre>

=end html

=begin text

a reference to a list where each element is a md5_id

=end text

=back



=head2 pdb_id

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



=head2 pdb_ids

=over 4



=item Definition

=begin html

<pre>
a reference to a list where each element is a pdb_id
</pre>

=end html

=begin text

a reference to a list where each element is a pdb_id

=end text

=back



=head2 md5_to_pdb_ids

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the key is a md5_id and the value is a pdb_ids
</pre>

=end html

=begin text

a reference to a hash where the key is a md5_id and the value is a pdb_ids

=end text

=back



=cut

1;
