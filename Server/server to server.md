### User login SDKV2

- http request method
    ```
    POST
    ```
    
- Support format
    ```
    JSON
    ```
    
- URI
    ```
    /v2/third/sdk/login
    ```
    
- Request parameter

   | name | type of data | instruction |
   | ------ | ------ | ------ |
   | userAccount | string | account |
   | sourceApp | int | Customer Number |
   | lngType | string | Language type |
   | phoneType | string | cellphone type |
   | phoneCode | string | Phone number |
   | countryCode | string | Country code |
   | iotType | string | iot type |
   | partnerKey | string | Key (public key) |
   | signatureVersion | string | Signed version, the default version is 1.0|
   | signature | string | Signature, signature rules: HmacSHA1 encryption is performed on the request parameters (in alphabetical order) according to the private key, and the signature is generated.|
   
- Response example
    ```
    {
        "result":{
            "countryCode":"",
            "imageUrl":"",
            "iot":{
                "pfKey":{
                    "accessid":"",
                    "accesskey":""
                },
                "mqtt_aws":{
    
                },
                "mqtt":{
                    "clientId":"",
                    "crtUrls":"",
                    "deviceSecret":"",
                    "dn":"",
                    "host":"",
                    "iotId":"",
                    "iotToken":"",
                    "keepalive":300,
                    "pk":"",
                    "port":"",
                    "protocol":"",
                    "region":"",
                    "subTopic":""
                },
                "iotVersion":1
            },
            "iotType":0,
            "jpushAlias":"",
            "loginType":0,
            "nickName":"",
            "phoneCode":"",
            "ringDuration":"",
            "soundFlag":0,
            "userAccount":"",
            "userID":100000000021,
            "userToken":""
        },
        "t":1621925563544,
        "resultCode":"1001"
    }
    ```
    

    ### User SDK redirection V2
    
 - http request method
     ```
     POST
     ```
     
 - 支持格式
     ```
     JSON
     ```
     
 - URI
     ```
     /v2/third/sdk/redirect
     ```
     
 - Support format

    | name | type of data | instruction |
    | ------ | ------ | ------ |
    | sourceApp | int | Customer Number |
    | countryCode | string | Country code |
    | partnerKey | string | Key (public key) |
    | signatureVersion | string | Signed version, the default version is 1.0|
    | signature | string | Signature, signature rules: HmacSHA1 encryption is performed on the request parameters (in alphabetical order) according to the private key, and the signature is generated.|
    
 - Response example
     ```
     {
         "result":{
             "countryCode":"",
             "pointUrl":"",
             "apiServer":"",
             "partnerId":0,
             "dcCode":"",
             "gwCode":"",
             "gwUrl":"",
             "pfApi":{
                 "openapi":{
                     "domain":""
                 },
                 "platform":{
                     "signature":"",
                     "domain":""
                 }
             }
         },
         "t":1622170952901,
         "resultCode":"1001"
     }
     ```