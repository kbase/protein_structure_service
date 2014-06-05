package Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient;

use JSON::RPC::Client;
use strict;
use Data::Dumper;
use URI;
use Bio::KBase::Exceptions;

# Client version should match Impl version
# This is a Semantic Version number,
# http://semver.org
our $VERSION = "0.1.0";

=head1 NAME

Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient

=head1 DESCRIPTION


Service for all ......R 

Sean, please refer... 
https://trac.kbase.us/projects/kbase/wiki/StandardDocuments


=cut

sub new
{
    my($class, $url, @args) = @_;
    

    my $self = {
	client => Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient::RpcClient->new,
	url => $url,
    };


    my $ua = $self->{client}->ua;	 
    my $timeout = $ENV{CDMI_TIMEOUT} || (30 * 60);	 
    $ua->timeout($timeout);
    bless $self, $class;
    #    $self->_validate_version();
    return $self;
}




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
    my($self, @args) = @_;

# Authentication: none

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function lookup_pdb_by_md5 (received $n, expecting 1)");
    }
    {
	my($input_ids) = @args;

	my @_bad_arguments;
        (ref($input_ids) eq 'ARRAY') or push(@_bad_arguments, "Invalid type for argument 1 \"input_ids\" (value was \"$input_ids\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to lookup_pdb_by_md5:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'lookup_pdb_by_md5');
	}
    }

    my $result = $self->{client}->call($self->{url}, {
	method => "KBaseProteinStructure.lookup_pdb_by_md5",
	params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'lookup_pdb_by_md5',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method lookup_pdb_by_md5",
					    status_line => $self->{client}->status_line,
					    method_name => 'lookup_pdb_by_md5',
				       );
    }
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
    my($self, @args) = @_;

# Authentication: none

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function lookup_pdb_by_fid (received $n, expecting 1)");
    }
    {
	my($feature_ids) = @args;

	my @_bad_arguments;
        (ref($feature_ids) eq 'ARRAY') or push(@_bad_arguments, "Invalid type for argument 1 \"feature_ids\" (value was \"$feature_ids\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to lookup_pdb_by_fid:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'lookup_pdb_by_fid');
	}
    }

    my $result = $self->{client}->call($self->{url}, {
	method => "KBaseProteinStructure.lookup_pdb_by_fid",
	params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'lookup_pdb_by_fid',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method lookup_pdb_by_fid",
					    status_line => $self->{client}->status_line,
					    method_name => 'lookup_pdb_by_fid',
				       );
    }
}



sub version {
    my ($self) = @_;
    my $result = $self->{client}->call($self->{url}, {
        method => "KBaseProteinStructure.version",
        params => [],
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(
                error => $result->error_message,
                code => $result->content->{code},
                method_name => 'lookup_pdb_by_fid',
            );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(
            error => "Error invoking method lookup_pdb_by_fid",
            status_line => $self->{client}->status_line,
            method_name => 'lookup_pdb_by_fid',
        );
    }
}

sub _validate_version {
    my ($self) = @_;
    my $svr_version = $self->version();
    my $client_version = $VERSION;
    my ($cMajor, $cMinor) = split(/\./, $client_version);
    my ($sMajor, $sMinor) = split(/\./, $svr_version);
    if ($sMajor != $cMajor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Major version numbers differ.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor < $cMinor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Client minor version greater than Server minor version.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor > $cMinor) {
        warn "New client version available for Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient\n";
    }
    if ($sMajor == 0) {
        warn "Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient version is $svr_version. API subject to change.\n";
    }
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

package Bio::KBase::KBaseProteinStructure::KBaseProteinStructureClient::RpcClient;
use base 'JSON::RPC::Client';

#
# Override JSON::RPC::Client::call because it doesn't handle error returns properly.
#

sub call {
    my ($self, $uri, $obj) = @_;
    my $result;

    if ($uri =~ /\?/) {
       $result = $self->_get($uri);
    }
    else {
        Carp::croak "not hashref." unless (ref $obj eq 'HASH');
        $result = $self->_post($uri, $obj);
    }

    my $service = $obj->{method} =~ /^system\./ if ( $obj );

    $self->status_line($result->status_line);

    if ($result->is_success) {

        return unless($result->content); # notification?

        if ($service) {
            return JSON::RPC::ServiceObject->new($result, $self->json);
        }

        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    elsif ($result->content_type eq 'application/json')
    {
        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    else {
        return;
    }
}


sub _post {
    my ($self, $uri, $obj) = @_;
    my $json = $self->json;

    $obj->{version} ||= $self->{version} || '1.1';

    if ($obj->{version} eq '1.0') {
        delete $obj->{version};
        if (exists $obj->{id}) {
            $self->id($obj->{id}) if ($obj->{id}); # if undef, it is notification.
        }
        else {
            $obj->{id} = $self->id || ($self->id('JSON::RPC::Client'));
        }
    }
    else {
        # $obj->{id} = $self->id if (defined $self->id);
	# Assign a random number to the id if one hasn't been set
	$obj->{id} = (defined $self->id) ? $self->id : substr(rand(),2);
    }

    my $content = $json->encode($obj);

    $self->ua->post(
        $uri,
        Content_Type   => $self->{content_type},
        Content        => $content,
        Accept         => 'application/json',
	($self->{token} ? (Authorization => $self->{token}) : ()),
    );
}



1;
