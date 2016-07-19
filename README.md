# basi/varnish
From the alpine distribution it installs a Varnish daemon.


### Varnish
It allows you to use an specific VCL file when you provide an environment variable named: `$VCL_CONFIG`. But
you can provide a directory instead of a file and the system internally will merge all the "vcl" files found in
the directory to create the VCL file that will be used by Varnish.

This approach is useful when you have complicated Varnish logic, and it allows to use small consul-template templates.

As the provided VCL is split in pieces you can overwrite each piece individually in your container or the entire
directory.

## Example of use

### Provide a directory with the logic split in files

    docker run --rm -it -P --add-host web:127.0.0.1 \
        -v $PWD/rootfs/etc/varnish/conf.d/:/etc/varnish/conf.d/ \
        -e VCL_CONFIG=/etc/varnish/conf.d \
        basi/varnish

It will use the VCL files contained in the volume instead of the originally available files provided by the image.
If you want to change one VCL status you just need to to it with:

    docker run --rm -it -P --add-host web:127.0.0.1 \
        -v $PWD/rootfs/etc/varnish/conf.d/30-vcl_deliver.vcl:/etc/varnish/conf.d/30-vcl_deliver.vcl \
        -e VCL_CONFIG=/etc/varnish/conf.d \
        basi/varnish

And it will just switch just the logic executed in the vcl_deliver status by yours.

### Provide a full VCL file

Another possibility is just give to the system a full VCL file. The needed parameters would be something similar to:

    docker run --rm -it -P --add-host web:127.0.0.1 \
        -v $PWD/rootfs/etc/varnish/default.vcl:/etc/varnish/default.vcl \
        -e VCL_CONFIG=/etc/varnish/default.vcl \
        basi/varnish

NOTE: As you may see in the examples the "web" name is resolved as localhost, usually you will provide your service name in the VCL. 

### Basic header debugging

If in your request you include the header: `X-Cache-Debug: u0AJAlRWN4` you can get extra headers in your response.
You can change the default secret value using an environmental variable.

### Other supported parameters:

`$CACHE_SIZE`:           Determines the cache size used by varnish
`$VARNISHD_PARAMS`:      Other parameters you want to pass to the varnish daemon
`$VARNISH_DEBUG_SECRET`: Change the default debug password
