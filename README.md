# NAME

Nakaisan - A Movable Type plugin.

# DESCRIPTION

Nakaisan ([なかいさん(仲居さん)](http://ja.wikipedia.org/wiki/%E4%BB%B2%E5%B1%85)) serve static and dynamic content with a Plack/PSGI server.

# INSTALL

1. Put cpanfile /path/to/mt.
2. Change working directory /path/to/mt.
    `$ cd /path/to/mt`
3. Install CPAN modules with carton. (What's carton? => [Carton](https://github.com/miyagawa/carton))
    `$ carton install`
4. Add a new line configuration directive `LocalLib local` to mt-config.cgi.  
5. Put Nakaisan /path/to/plugins.

(This is only one case.)

# HOW TO USE

1. Set website path /path/to/mt/public.
2. Set website URL http://localhost:5000/.
3. Change working directory /path/to/mt and run the starman.  
    `$ starman --pid=mt.pid mt.psgi`
4. Browse http://localhost:5000/.

# REQUIREMENTS

- Movable Type >= 5.2.7
- Plack::App::PHPCGI
- php-cgi command

# CONFIGURATION DIRECTIVES

## NakaisanMountPoint

Default is `/`.

## NakaisanDocumentRoot

Default is `public`.

## NakaisanPHPCGIPath

Default is nothing.

# PLUGIN SETTINGS (BLOG)

## directory_index

Default is `index.html index.htm index.php`.

## bootstrapper

Default is `mtview.php`.

## pass_through_bootstrapper

Default is `No`.

# SEE ALSO

- [Plack::App::PHPCGI](https://metacpan.org/pod/Plack::App::PHPCGI)

# LICENSE

Copyright (C) HIGASHI Taiju.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

HIGASHI Taiju
