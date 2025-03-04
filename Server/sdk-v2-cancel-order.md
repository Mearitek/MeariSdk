### Create Order SDKV4

- **Http request method**
  
    ```
    POST
    ```
    
- **Support format**
  
    ```
    JSON
    ```
    
- **URI**
  
    ```
    /v3/third/sdk/order/cancel
    ```
    
- **Request parameter**

   |       name       | type of data |                         instruction                          | Required |  for example  |
   | :--------------: | :----------: | :----------------------------------------------------------: | :------: | :-----------: |
   |    sourceApp     |     int      |                     Your Customer Number                     |   YES    |      72       |
   |   userAccount    |    string    |                         User Account                         |   YES    | test@123.com  |
   |    partnerKey    |    string    |                       Key (public key)                       |   YES    |               |
   |     orderType    |     int      | order type. 1: cloud order 2: ai order 3: flow4g order       |   YES    | 1 or 2 or 3   |
   |     orderNum     |    string    |                          Order number                        |   YES    |01582572KS0209053 |
   | signatureMethod  |    string    |             Signature method, default HMAC-SHA1.             |   YES    |   HMAC-SHA1   |
   | signatureVersion |    string    |          Signed version(the default version is 1.0)          |   YES    |      1.0      |
   |  signatureNonce  |    string    | Unique random number, timestamp. Users need to use different random values in different requests |   YES    |      704      |
   |    timestamp     |    string    |        UTC time. The format is YYYY-MM-DDThh:mm:ssZ.         |   YES    | 1667476374574 |
   |    signature     |    string    |                   Signature result string.                   |   YES    |               |
   
- **signature For example**

```
*The parameters should be spliced in lexicographic order

signature = Base64.encode(HmacSha1("partnerKey=test&signatureMethod=HMAC-SHA1&signatureNonce=704&signatureVersion=1.0&sourceApp=72&timestamp=1667476374574&orderType=1&orderNum=1", PartnerSecret))
```

- **Response example**

```
{
	"resultCode": "1001"
}
```
- **Network request status code**

  ```
  1001    Request successful
  1003    The parameter is invalid
  1005    System exception
  1023    Location Login/Invalid User Token/Invalid signature
  4001    server not found. cancel order fail
  4002    The service has been used and exceeded 7 days.  cancel order fail
  ```