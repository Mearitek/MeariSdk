
### Delete Device Interface

- http request method
    ```
    GET
    ```
    
- URI
    ```
    /v1/third/customer/device/delete
    ```

- Request parameter

   | name | type of data | instruction | for example |
   | ------ | ------ | ------ | ------ |
   | userID | string | Get in the return value of login |  |
   | deviceID | string | Get in the return value of device list |  |
   | sourceApp | string | Customer Number |  |
   
- Response example
    ```
    {
        "resultCode":"1001"
    }
    ```

- Encryption rules

  please strictly follow the following references:
  [Server interface authentication method](Server%20interface%20authentication%20method.md)