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

   | name | type of data | instruction | for example |
   | ------ | ------ | ------ | ------ |
   | userAccount | string | account(Preferably uuid) |  |
   | sourceApp | int | Customer Number |  |
   | lngType | string | Language type | en |
   | phoneType | string | cellphone type(android is 'a',ios is 'i') | a |
   | phoneCode | string | Phone number | 86 |
   | countryCode | string | Country code | CN |
   | iotType | string | iot type(the default is 3) | 3 |
   | partnerKey | string | Key (public key) |  |
   | signatureVersion | string | Signed version(the default version is 1.0) | 1.0 |
   | signature | string | Signature, signature rules: HmacSHA1 encryption is performed on the request parameters (in alphabetical order) according to the private key, and the signature is generated.| |
   
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

    | name | type of data | instruction | for example |
    | ------ | ------ | ------ | ------ |
    | sourceApp | int | Customer Number |  |
    | countryCode | string | Country code | CN |
    | partnerKey | string | Key (public key) |  |
    | signatureVersion | string | Signed version(the default version is 1.0) | 1.0 |
    | signature | string | Signature, signature rules: HmacSHA1 encryption is performed on the request parameters (in alphabetical order) according to the private key, and the signature is generated.| |
    
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