## Server interface authentication method

#### Method

+ when 'signatureVersion=1.0'，use sign authentication method.
+ Use 'userToken/PartnerSecret' as an encrypted private key, do not use as request parameters.
+ The interface is uniformly requested by GET。

#### Parameter

| Parameter Name   | Type   | Instruction                                                  | Required |
| ---------------- | ------ | ------------------------------------------------------------ | -------- |
| signature        | String | Signature result string.                                     | YES      |
| signatureMethod  | String | Signature method, default HMAC-SHA1.                         | YES      |
| timestamp        | String | Timestamp, for example 1712115627000               | YES      |
| signatureVersion | String | Signature algorithm version. The default is 1.0.             | YES      |
| signatureNonce   | String | Unique random number, timestamp. Users need to use different random values in different requests | YES      |

*signature For example*

```
signature = Base64.encode(HmacSha1("countryCode=US&partnerKey=eb072a50c9929&signatureMethod=HMAC-SHA1&signatureNonce=1684823279&signatureVersion=1.0&sourceApp=888&timestamp=1684823279", PartnerSecret))
```

> The parameters should be spliced in lexicographic order