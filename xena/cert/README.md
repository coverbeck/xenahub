Store your certificate and key files in here (but don't commit to git).

To work with Xena, key files seem to need to be in the "pkcs#8" format.
Otherwise, you may get the following error:
"Exception in thread "main" java.security.spec.InvalidKeySpecException: java.security.InvalidKeyException: IOException : algid parse error, not a sequence"


To convert a key file from  "pkcs#1" to "pkcs8" ([source](https://stackoverflow.com/questions/15344125/load-a-rsa-private-key-in-java-algid-parse-error-not-a-sequence/29827944)):
```
# create priv8.pem from priv1.pem
openssl pkcs8 -topk8 -inform PEM -outform PEM -in priv1.pem -out priv8.pem -nocrypt
```
