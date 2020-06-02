# Amazon Linux 2 in FIPS Mode

This repository uses the [amazonlinux:2](https://hub.docker.com/_/amazonlinux) base image and adds the `dracut-fips` and `openssl` to make an FIPS 140-2 compliant base image.

## Building

| Options | Default | Supported Values | Description |
|---|---|---|
| IMAGE_REGISTRY | `073455283520.dkr.ecr.us-east-2.amazonaws.com` | Any Docker Registry | The URL of the Docker registry to push the images. |
| IMAGE_NAME | `fips/amazonlinux` | Any | The name of the image repository within the Docker registry. |
| IMAGE_TAG | `2` | Any | The image tag associated with the build. |

```bash
make build
```
