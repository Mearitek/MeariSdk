
### Get Device pf info Interface

- http request method
    ```
    GET
    ```
    
- URI
    ```
    /v1/third/customer/device/pf/info
    ```

- Request parameter

   | name | type of data | instruction | for example |
   | ------ | ------ | ------ | ------ |
   | licenseID | string | device license |  |
   | partnerKey | string | Key (public key) |  |
   
- Response example
    ```
    {
        "resultCode":"1001",
        "result":{
            "hostKey":"",
            "pfApi":{
                "openapi":{
                    "domain":""
                },
                "platform":{
                    "domain":"",
                    "signature":""
                }
            }
        }
    }
    ```

- Encryption rules

  please strictly follow the following references:
  [Server interface authentication method](Server%20interface%20authentication%20method.md)