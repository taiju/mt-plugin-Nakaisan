package Plack::Middleware::MT::Nakaisan;

use strict;
use warnings;

use parent 'Plack::Middleware';

use File::Spec;
use Plack::App::File;
use Plack::App::PHPCGI;

use MT::FileInfo;
use MT::Blog;

sub call {
    my ($self, $env) = @_;

    $env->{PATH_INFO} .= $self->_directory_index($env) if $env->{PATH_INFO} =~ m{/$};
    $env->{DOCUMENT_ROOT} ||= File::Spec->rel2abs(MT->config->NakaisanDocumentRoot);

    my $res = Plack::App::File->new(
        root => MT->config->NakaisanDocumentRoot,
    )->to_app->($env);

    return $self->_php_cgi($env) if $res->[0] ne '404' && $env->{PATH_INFO} =~ /\.php$/;

    return $res if $res->[0] ne '404' && !MT->config->NakaisanPassThroughBootstrapper;

    my $bootstrapper = $self->_bootstrapper($env);
    return $res unless $bootstrapper;
    return $res unless -f $bootstrapper;

    $self->_php_cgi($env, $bootstrapper);
}

sub _php_cgi {
    my ($self, $env, $script) = @_;

    $script ||= MT->config->NakaisanDocumentRoot . $env->{PATH_INFO};

    Plack::App::PHPCGI->new(
        script => $script,
        (MT->config->NakaisanPHPCGIPath ?
          (php_cgi => MT->config->NakaisanPHPCGIPath) : ()),
    )->to_app->($env);
}

sub _directory_index {
    my ($self, $env) = @_;

    my @dir_indexes = split /\s+/, MT->config->NakaisanDirectoryIndex;

    my @exist_dir_indexes = grep {
        -f MT->config->NakaisanDocumentRoot . $env->{PATH_INFO} . $_;
    } @dir_indexes;

    @exist_dir_indexes ? $exist_dir_indexes[0] : $dir_indexes[0];
}

sub _bootstrapper {
    my ($self, $env) = @_;
  
    my $fi = MT::FileInfo->load({ url => $env->{PATH_INFO} });
    return unless $fi;
  
    my ($domain, $path) = MT::Blog->load($fi->blog_id)->raw_site_url;
    $path ||= '';

    MT->config->NakaisanDocumentRoot . "/$path" . MT->config->NakaisanBootstrapper;
}

1;
