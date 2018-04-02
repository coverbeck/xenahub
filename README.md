# xenahub
Stand-alone Dockerized Xena Hub

## Requirements:
- docker
- docker-compose
- make (optional)


## Notes
You will need to provide a certificate file and keyfile.
They should be placed in the xena/certs subdirectory.

The hub must be accessible at the URL that the certificate is for.
Otherwise you will get an "ERR_CERT_COMMON_NAME_INVALID" error.
