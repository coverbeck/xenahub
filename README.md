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

## Hosted Files
To load a data file into xenahub, you will need two files:
- the TSV data file itself, eg `example.tsv`. This must not be gzipped.
- a xena-formatted metadata file, `example.tsv.json`

Place both of these in the`xenahub/xena/files` directory.
Then, from the `xenahub` directory, run:

`make load file=example.tsv`

The request will complete within a few seconds and the file will then load asynchronously into the xena db.
Leave the TSV file within the `files` subdirectory, or the download link on its xena page will not work.

For backups of the metadata for Treehouse's hosted files, see [the reference-file-info repo](https://github.com/UCSC-Treehouse/reference-file-info).

