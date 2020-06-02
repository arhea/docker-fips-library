# Alpine Linux with FIPS Support

This repository will build a FIPS 140-2 compliant OpenSSL version, `1.0.2k-fips`, on top of [alpine:3](https://hub.docker.com/_/alpine). It will not replace the existing OpenSSL version because that will interfere with `apk` and could get overwritten. Instead, the FIPS compatible version is added to the PATH.

## Building

| Options | Default | Supported Values | Description |
|---|---|---|
| IMAGE_REGISTRY | `073455283520.dkr.ecr.us-east-2.amazonaws.com` | Any Docker Registry | The URL of the Docker registry to push the images. |
| IMAGE_NAME | `fips/alpine` | Any | The name of the image repository within the Docker registry. |
| IMAGE_TAG | `3` | Any | The image tag associated with the build. |

```bash
make build
```
