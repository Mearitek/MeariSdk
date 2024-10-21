### Activation code activates cloud storage,AI,4G   V3

- http request method

  ```
  POST
  ```

- Support format

  ```
  JSON
  ```

- URL

  ```
  /v3/third/sdk/actCode/service
  ```

- Request parameter

  | name             | type of data | instruction                                                  | for example |
  | ---------------- | ------------ | ------------------------------------------------------------ | ----------- |
  | userAccount      | string       | account                                                      |             |
  | deviceID         | long         | deviceID                                                     |             |
  | actCode          | string       | Activation code                                              |             |
  | type             | string       | Service Type  0:cloud，1:AI，2:4G                            | 0           |
  | phoneType        | string       | cellphone type(android is 'a',ios is 'i')                    | a           |
  | sourceApp        | int          | Customer Number                                              |             |
  | lngType          | string       | Language type                                                | en          |
  | partnerKey       | string       | Key (public key)                                             |             |
  | signatureVersion | string       | Signed version(the default version is 1.0)                   | 1.0         |
  | signature        | string       | Signature, signature rules: HmacSHA1 encryption is performed on the request parameters (in alphabetical order) according to the private key, and the signature is generated. |             |

- Response example

  ```
  {
      "result": {
          "orderNum": "" //unique identification
      },
      "t": 1621925563544,
      "resultCode": "1001"
  }
  ```



### Equipment usage activation code usage record  V3

- http request method

  ```
  POST
  ```

- Support format

  ```
  JSON
  ```

- URL

  ```
  /v3/third/sdk/actCode/usage/record
  ```

- Request parameter

  | name             | type of data | instruction                                                  | for example |
  | ---------------- | ------------ | ------------------------------------------------------------ | ----------- |
  | userAccount      | string       | account                                                      |             |
  | deviceID         | long         | deviceID                                                     |             |
  | phoneType        | string       | cellphone type(android is 'a',ios is 'i')                    | a           |
  | sourceApp        | int          | Customer Number                                              |             |
  | lngType          | string       | Language type                                                | en          |
  | partnerKey       | string       | Key (public key)                                             |             |
  | signatureVersion | string       | Signed version(the default version is 1.0)                   | 1.0         |
  | signature        | string       | Signature, signature rules: HmacSHA1 encryption is performed on the request parameters (in alphabetical order) according to the private key, and the signature is generated. |             |

- Response example

  ```
  {
      "result": {
          "data": [
              {
              	"orderNum": "", //unique identification
                  "actCode": "", //Activation code
                  "useTime": 1653720268000, //Usage time
                  "type": "0",  //Service Type 0:cloud，1:AI，2:4G
              }
          ]
      },
      "t": 1621925563544,
      "resultCode": "1001"
  }
  ```



### List of services currently in effect  V3

- http request method

  ```
  POST
  ```

- Support format

  ```
  JSON
  ```

- URL

  ```
  /v3/third/sdk/device/services/effect
  ```

- Request parameter

  | name             | type of data | instruction                                                  | for example |
  | ---------------- | ------------ | ------------------------------------------------------------ | ----------- |
  | userAccount      | string       | account                                                      |             |
  | deviceID         | long         | deviceID                                                     |             |
  | phoneType        | string       | cellphone type(android is 'a',ios is 'i')                    | a           |
  | sourceApp        | int          | Customer Number                                              |             |
  | lngType          | string       | Language type                                                | en          |
  | partnerKey       | string       | Key (public key)                                             |             |
  | signatureVersion | string       | Signed version(the default version is 1.0)                   | 1.0         |
  | signature        | string       | Signature, signature rules: HmacSHA1 encryption is performed on the request parameters (in alphabetical order) according to the private key, and the signature is generated. |             |

- Response example

  ```
  {
      "result": {
          "data": [
              {
                  "orderNum": "", //unique identification
                  "serverStartTime": 1653720268000, //Service start time
                  "serverEndTime": 1653720268000, //Service end time
                  "type": "0" //Service Type  0:cloud，1:AI，2:4G
              }
          ]
      },
      "t": 1621925563544,
      "resultCode": "1001"
  }
  ```
