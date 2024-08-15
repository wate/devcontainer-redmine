DNS情報
===========================

example.com
---------------------------

### DMARCレコード

* name: `_dmarc`
* type: `TXT`

#### rdata

```
v=DMARC1; p=quarantine; sp=quarantine; pct=100
```

redmine.example.com
---------------------------

### Aレコード

* name: `@`
* type: `A`

#### rdata

```
xxx.xxx.xxx.xxx
```

### AAAAレコード

* name: `@`
* type: `AAAA`

#### rdata

```
xxxx:xxxx:xxxx:xxxx:xxxx
```

### SPFレコード

name: `redmine`
type: `TXT`

### rdata

```
v=spf1 ip4:xxx.xxx.xxx.xxx ip6:xxxx:xxxx:xxxx:xxxx:xxxx ~all
```

### DKIMレコード

name: `default._domainkey.redmine`
type: `TXT`

### rdata

```
v=DKIM1; h=sha256; k=rsa; p=*********
```
