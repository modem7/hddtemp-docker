# HDDTemp-Docker

![Docker Pulls](https://img.shields.io/docker/pulls/modem7/hddtemp-docker) 
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/modem7/hddtemp-docker/latest) 
[![Build Status](https://drone.modem7.com/api/badges/modem7/hddtemp-docker/status.svg)](https://drone.modem7.com/modem7/hddtemp-docker)
[![Docker build CI](https://github.com/modem7/hddtemp-docker/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/modem7/hddtemp-docker/actions/workflows/CI.yml)

Docker container for HDDTemp:
http://savannah.nongnu.org/projects/hddtemp

HDDTemp has been rebuilt from https://github.com/vitlav/hddtemp which has several improvements and fixes:

### INCORPORATED PATCHES
 * Implement drives auto-detection
 * First try S.M.A.R.T. attribute 194, otherwise try attribute 190
 * Add support for NVME bus
 * Added ata-model patch (model is limited to 40 chars, so don't display junk after it)
 * Allow binding to a listen address that doesn't exist yet
 * Add -F --foreground option:  don't daemonize, stay in foreground
 * See [change log](https://github.com/vitlav/hddtemp/blob/master/ChangeLog)

# Tags
| Tag | Description |
| :----: | --- |
| latest | Latest version |
| 0.4.x | Versioned against vitlav repo |

# Note
NOTE: This repository will install hddtemp in the docker container from apt repositories. I do not maintain the hddtemp project.

# Example:
```
docker run -d \
--privileged=true \
--name="hddtemp-docker" \
-e HDDTEMP_ARGS="-q -d -F /dev/sd*" \
-e TZ="Europe/London" \
modem7/hddtemp-docker
```

or

```yaml
  hddtemp:
    image: modem7/hddtemp-docker:latest
    container_name: HDDTemp
    hostname: hddtemp
    restart: always
    ports:
      - "7634:7634"
    privileged: true
    environment:
      - HDDTEMP_ARGS="-q -d -F /dev/sd*"
      - TZ=$TZ
    volumes:
      - /dev:/dev:ro
```

The hddtemp.db file was obtained from:
https://de.freedif.org/savannah/hddtemp/hddtemp.db

Then it was updated from the [Gentoo repo](https://gitweb.gentoo.org/repo/gentoo.git/tree/app-admin/hddtemp).

Enjoy!
