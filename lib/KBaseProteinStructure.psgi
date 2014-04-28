use Bio::KBase::KBaseProteinStructure::KBaseProteinStructureImpl;

use Bio::KBase::KBaseProteinStructure::Service;
use Plack::Middleware::CrossOrigin;



my @dispatch;

{
    my $obj = Bio::KBase::KBaseProteinStructure::KBaseProteinStructureImpl->new;
    push(@dispatch, 'KBaseProteinStructure' => $obj);
}


my $server = Bio::KBase::KBaseProteinStructure::Service->new(instance_dispatch => { @dispatch },
				allow_get => 0,
			       );

my $handler = sub { $server->handle_input(@_) };

$handler = Plack::Middleware::CrossOrigin->wrap( $handler, origins => "*", headers => "*");
