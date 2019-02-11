# xenahub
Stand-alone Dockerized Xena Hub

## Requirements:
- docker
- docker-compose
- make (optional)


## Notes
You will need to provide a certificate file and keyfile.
They should be placed in the xena/certs subdirectory. (When running in standalone mode.
See below for running behind a reverse proxy.)

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

## Root-Squash
If your xena files are stored on an NFS mount that has been "root-squashed", it is a little
bit complicated to make the permissions work.

The way I am doing it is to make everything group-readable, then run the docker with user
root (the default) but the same group id as the group on the host.
You will have to edit your docker-compose.yml file to update the group ID to the correct one.
To find the desired group id:

`getent group GROUPNAME`

If you get the following error, set the `xena` dir to be group-writable:

`Error opening database: "Could not save properties /root/xena/database.lock.db"`

## Running behind Apache reverse proxy
This is how to set it up on a shared server running on a high-level port, with Apache proxying to it.
Instructions may be approximate.

### DNS
Set up a CNAME to your shared server with your hub URL:

xenahub.example.com 28800 CNAME sharedserver.example.com

### Apache
Apache is responsible for holding the certificates for the `xenahub.example.com` site in this mode.
For example, store in `/etc/httpd/xena_certs`:
`chain.crt  xena.crt  xena.csr  xena.key`

Then, in `/etc/httpd/conf.d/ssl.conf`, include the following VirtualHost.
This will send https requests to Xena's 7223 (https) port. ProxyPreserveHost ensures that xena knows
that its hostname is xenahub.example.com instead of 127.0.0.1.

```
<VirtualHost *:443>
  ServerName xenahub.example.com
  SSLEngine on
  SSLProtocol all -SSLv2 -SSLv3
  SSLCipherSuite HIGH:3DES:!aNULL:!MD5:!SEED:!IDEA
  SSLCertificateFile /etc/httpd/xena_certs/xena.crt
  SSLCertificateKeyFile /etc/httpd/xena_certs/xena.key
  SSLCertificateChainFile /etc/httpd/xena_certs/chain.crt

  ProxyRequests Off
  ProxyPreserveHost On
  SSLProxyEngine On
  SSLProxyVerify none
  SSLProxyCheckPeerCN off
  SSLProxyCheckPeerName off
  SSLProxyCheckPeerExpire off
  ProxyPass "/"  "https://127.0.0.1:7223/"
  ProxyPassReverse "/"  "https://127.0.0.1:7223/"
</VirtualHost>
```

### Xena Docker
For behind reverse proxy, you will want to use the no-certs configuration & docker build.
This is currently the default.
