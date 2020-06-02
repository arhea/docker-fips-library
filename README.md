# FIPS 140-2 Compliant Docker Images

This repository contains sample implementations of FIPS 140-2 compliant container images. Containers need to run on host operating systems that have FIPS 140-2 enabled.

- [Alpine Linux](./alpine/) - Compiles the FIPS 140-2 compliant OpenSSL 1.0.2k-fips on Alpine
- [Amazon Linux 2](./amazonlinux/) - Installs the FIPS 140-2 compliant OpenSSL and `dracut-fips` package
- [CentOS 7](./centos/) - Installs the FIPS 140-2 compliant OpenSSL and `dracut-fips` package
- [NGINX](./nginx/) - Compiles NGINX using a FIPS 140-2 compliant version of OpenSSL

## Usage

These are reference implementations and have not been validated by NIST, FedRAMP, or DoD CC SRG accreditations bodies. I recommend working with your security organization, Third Party Assessment Organizations (3PAO), or authorizing official (AO).

For deployment, I recommend building and storing these images within your environment for building, testing, and scanning.

## What is FIPS 140-2?

The Federal Information Processing Standard Publication 140-2, (FIPS PUB 140-2),[1][2] is a U.S. government computer security standard used to approve cryptographic modules. The title is Security Requirements for Cryptographic Modules. Initial publication was on May 25, 2001 and was last updated December 3, 2002.

For more information, visit the [FIPS 140-2 Wikipedia Page](https://en.wikipedia.org/wiki/FIPS_140-2).

## License

This library is licensed under the MIT-0 License. See the [LICENSE file](./LICENSE).
