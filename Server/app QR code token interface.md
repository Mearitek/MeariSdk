
### QR Code Token Interface

- http request method
    ```
    GET
    ```
    
- URI
    ```
    /v1/third/customer/device/token
    ```

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

- Encryption rules

  please strictly follow the following references:
  [Server interface authentication method](Server%20interface%20authentication%20method.md)