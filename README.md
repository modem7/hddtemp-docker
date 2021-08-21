# HDDTemp-Docker

![Docker Pulls](https://img.shields.io/docker/pulls/modem7/hddtemp-docker) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/modem7/hddtemp-docker/latest) [![Build Status](https://drone.modem7.com/api/badges/modem7/hddtemp-docker/status.svg)](https://drone.modem7.com/modem7/hddtemp-docker)

Docker container for HDDTemp:
http://savannah.nongnu.org/projects/hddtemp

# Tags: 
| Tag | Description |
| :----: | --- |
| Latest | Automatically built every week. |
| Monthly | Automatically built every month. |
| Stable | Automatically built every year. |

# Note
NOTE: This repository will install hddtemp in the docker container from apt repositories. I do not maintain the hddtemp project.

# Example:
```
docker run -d \
--privileged=true 
--name="hddtemp-docker" \
-e HDDTEMP_ARGS="-q -d -F /dev/sd*" \
-e TZ="Europe/London" \
modem7/hddtemp-docker
```

The hddtemp.db file was obtained from:
http://www.guzu.net/linux/hddtemp.db

I do not know how up-to-date that file is. I suspect it has not been maintained...
Therefore I decided to copy it into this repository and have made a couple additions.
The hddtemp.db file in this repository will get loaded into the container.

Enjoy!
