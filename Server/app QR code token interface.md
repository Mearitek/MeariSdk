### App QR Code Token Interface

- http request method
    ```
    GET
    ```
    
- URI
    ```
    /app/token/get
    ```
    
- Request header

   | name | type of data | instruction | for example |
   | ------ | ------ | ------ | ------ |
   | jwt | string |  |  |
    
- Request parameter

   | name | type of data | instruction | for example |
   | ------ | ------ | ------ | ------ |
   | userID | string | Get in the return value of login |  |
   | timeZone | string |  | UTC08:00 |
   | region | string |  | Asia/Shanghai |
   | sourceApp | string | Customer Number |  |
   
- Response example
    ```
    {
        "smart_switch":5,
        "resultCode":"1001",
        "token":"CN-00000gs9tttt"
    }
    ```
- How to get the header parameter jwt
    ```
    jwt=${header}.${payload}.${signature}
    signature=base64(hmacsha1(userToken,${header}.${payload}))
    The header is usually the header parameter.
    The payload is usually the param parameter.
    The userToken is get from the return value of login.
    ```
