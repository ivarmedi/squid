# ivarmedi/squid:3.5.25

## Contents

This dockerfile contains squid compiled with ssl support. You can use it to proxy encrypted traffic using your own cert (`ssl_bump`).

## Usage

You need to provide your own certificates. Just generate a simple self-signed.
Note that you don't need to provide a FQDN in the cert as squid will generate certificates on the fly when you request a site over https.

```bash
$ openssl genrsa -out squid.key 2048
Generating RSA private key, 2048 bit long modulus
..............................+++
.................+++
e is 65537 (0x10001)

$ openssl req -new -key squid.key -out squid.csr
ou are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:SE
State or Province Name (full name) [Some-State]:sthlm
Locality Name (eg, city) []:sthlm
Organization Name (eg, company) [Internet Widgits Pty Ltd]:ivarmedi
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

$ openssl x509 -req -days 3652 -in squid.csr -signkey squid.key -out squid.crt
Signature ok
subject=/C=SE/ST=sthlm/L=sthlm/O=ivarmedi
Getting Private key
```

Mount these in the container on `/etc/ssl/squid`: 

```bash
docker run -it --rm -v /path/to/certs:/etc/ssl/squid -p 3128:3128 ivarmedi/squid
```

## More options

### Logs
You can mount a volume on `/var/log/squid` to access the logs

```
-v /path/to/logs:/var/log/squid
```

### Persistent cache
To keep cached data betweeen restarts, mount a volume on `/var/spool/squid/`

```
-v /path/to/persistent/cache:/var/spool/squid
```

### Custom config
You can customize the config by mounting your own on `/etc/squid/squid.conf`

```
-v /path/to/config:/etc/squid/squid.conf
```
