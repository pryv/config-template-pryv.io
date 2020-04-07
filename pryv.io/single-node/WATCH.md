# Automatic restart upon configuration update

If you wish to automatically restart pryv components when some configuration update occurs you can watch the configuration files on each machine running a service-config-follower by launching the `watch-config` script (described bellow).
However, it requires you have `fs-watch` installed.
On Ubuntu 18.04 and above you can install it with

    $ sudo apt install fswatch

On other Linux versions you'll have to compile it yourself following this documentation : https://github.com/emcrisostomo/fswatch#installation
Here is an example on how to do that on Ubuntu 16.04 :

    VERSION=1.14.0;

    pushd /tmp;

    sudo apt-get update -y;
    sudo apt dist-upgrade;
    sudo apt-get install -y build-essential; # install gcc and other compiling tools
    url="https://github.com/emcrisostomo/fswatch/releases/download/$VERSION/fswatch-$VERSION.tar.gz"
    echo "Downloading $url"
    curl -O -J -L $url --output fswatch-$VERSION.tar.gz;
    tar xzf fswatch-$VERSION.tar.gz;
    cd fswatch-$VERSION;
    ./configure;
    make;
    sudo make install;
    sudo ldconfig;

    popd;

When the `watch-config` script is running, any changes in a file under `${PRYV_CONF_ROOT}/single-node/pryv/*/conf/` (even a simple `touch`) will trigger the `reload-module` script who will restart all the pryv containers.
In practice these changes will occure when calling the route `https://lead.${DOMAIN}/admin/notify?auth=${ADMIN_KEY}`
The `service-config-follower` will fetch all the configuration files from `service-config-leader` and write them under the `${PRYV_CONF_ROOT}/single-node/pryv/` folder, triggering the `watch-config` script.

If you want to automatically restart pryv components upon a configuration update you can launch the `watch-config` script :

    $ sudo ./watch-config --no-hup

To stop watching :

    $ sudo ./watch-config --stop-watch