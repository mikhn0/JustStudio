# IOS build
[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

After build XCode project add this lines to your podfile
```sh
pod 'nativevibro', '0.0.1'
pod 'nativeshare', '0.0.1'
```
### Pods

| Name | Pod |Ropo |
| ------ | ------ | ------ |
| nativevibro | [pod 'nativevibro', '0.0.1'] | https://bitbucket.org/aalinovsky/nativevibro/src|
| nativeshare | [pod 'nativeshare', '0.0.1'] | https://bitbucket.org/aalinovsky/nativeshare/src|

### Generate JSON Web Token for MusicKit

Use project - https://github.com/klaas/SwiftJWTSample/

**Enter the command in the terminal from *SwiftJWTSample* project folder:**
```sh
swift run generateToken <team-id> <key-id> path_to_keys/AuthKey.p8
```
**Generated JSON Web Token from 03.08.2019 (will expire 03.02.2020):**

```sh
JSON Web Token:
"eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6Ilo1WUdOQUEyNjYifQ.eyJpc3MiOiJUVjRZTjZWWDQ5IiwiaWF0IjoxNTY3NTI0ODc5LjkxNzUzNDgsImV4cCI6MTU3MjcwODg3OS45MTc1MzQ4fQ._Z9x8wc50MCwkm1SrYH7ztspyytrYJUF8pTVKstD8F8ij4XqE7wa1QLEwnzc0vgI-kGgKkIIlHXeemaliXpUUQ"

Header:
	{"typ":"JWT","alg":"ES256","kid":"Z5YGNAA266"}
Payload:
	{"iss":"TV4YN6VX49","iat":1567524879.9175348,"exp":1572708879.9175348}
Signature:
	_Z9x8wc50MCwkm1SrYH7ztspyytrYJUF8pTVKstD8F8ij4XqE7wa1QLEwnzc0vgI-kGgKkIIlHXeemaliXpUUQ
```


	
