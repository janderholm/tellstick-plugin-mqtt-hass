#!/bin/sh -e

read -p "This will bind mount $HOME/.gnupg into a container and may mess up permissions. Do you want to continue? " y
case $y in
    [Yy]* ) break;;
    * ) exit;;
esac

docker run -it --network=host -v $(pwd):/usr/src/tellstick-server/plugins/tellstick-plugin-mqtt-hass -v $HOME/.gnupg/:/root/.gnupg tellstick-plugin-mqtt-hass-build ./tellstick.sh build-plugin plugins/tellstick-plugin-mqtt-hass/
