#!/usr/bin/env sh

# Documentation: https://containrrr.dev/watchtower/arguments/

# Sets the time zone to be used by WatchTower's logs and the optional Cron scheduling argument (--schedule). 
# If this environment variable is not set, Watchtower will use the default time zone: UTC. 
export TZ=Europe/Stockholm

# Removes old images after updating. When this flag is specified, watchtower will 
# remove the old image after restarting a container with a new image. Use this option 
# to prevent the accumulation of orphaned images on your system as containers are updated.
export WATCHTOWER_CLEANUP=true

# Poll interval (in seconds). This value controls how frequently watchtower will poll for new images.
# Either --schedule or a poll interval can be defined, but not both.
# Poll every 5 minutes (300 seconds).
export WATCHTOWER_POLL_INTERVAL=300

# Restart one image at time instead of stopping and starting all at once. 
# Useful in conjunction with lifecycle hooks to implement zero-downtime deploy.
# Set to false to begin with, we can experiment with zero-downtime deploys later.
export WATCHTOWER_ROLLING_RESTART=false

# NOTE: since we mount the docker config to root / in the container, any
# file named config.json will be overwritten. Therefore I recommended
# using a WORKDIR different from root when building your image to avoid 
# a potential naming conflict.

docker run -d \
   --name watchtower \
   -v /var/run/docker.sock:/var/run/docker.sock \
   -v ~/.docker/config.json:/config.json \
   -e WATCHTOWER_CLEANUP \
   -e WATCHTOWER_POLL_INTERVAL \
   -e WATCHTOWER_ROLLING_RESTART \
   -e TZ \
   index.docker.io/containrrr/watchtower

# NOTE: if you mount config.json in the manner above, changes from the host 
# system will (generally) not be propagated to the running container. Mounting
# files into the Docker daemon uses bind mounts, which are based on inodes.
# Most applications (including docker login and vim) will not directly edit 
# the file, but instead make a copy and replace the original file, which
# results in a new inode which in turn breaks the bind mount. As a workaround,
# you can create a symlink to your config.json file and then mount the symlink
# in the container. The symlinked file will always have the same inode, which
# keeps the bind mount intact and will ensure changes to the original file are
# propagated to the running container (regardless of the inode of the source file!). 

