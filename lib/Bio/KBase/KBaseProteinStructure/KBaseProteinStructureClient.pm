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
                method_name => 'lookup_pdb_by_md5',
            );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(
            error => "Error invoking method lookup_pdb_by_md5",
            status_line => $self->{client}->status_line,
            method_name => 'lookup_pdb_by_md5',
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
