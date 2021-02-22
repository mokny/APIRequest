# APIRequest
iOS Swift / Xcode APIRequest Class. This class uses the native URLSession to handle API-Requests asynchronous, non blocking. It sends parameters via POST to the server and receive a JSON Array of data mapped to a Dictionary.

## Installation
Add the APIRequest.swift file to your project and upload the json.php to some webserver that is reachable via the internet.

## Example
Initialize the class (maybe globally in your view controller)
```swift
  var API = APIRequest(apiurl: "http://example.com/json.php")
  
  //Optional Settings
  API.BlockWhenBusy = true //Default is false. This will make the API cancel all requests if another request is still pending
  API.SetUserAgent(agent: "MyUserAgent") //Sets the Useragent

```

Inside some function, make the call like this
```swift
    let params = [
        "name": "John Doe",
        "mail": "johndoe@example.com"
    ]
    API.call(method: "TEST", parameters: params, ResponseHandler: MyResponseHandler)
```

Add a Responsehandler to handle the API Response
```swift
    func MyResponseHandler(success: Bool) {
        if (success) {
            //API Request was successfully submitted, do something with the response data
            var myVar = self.API.Response.Data["test"] as! String //Data to variable
            self.responseLabel.text = (self.API.Response.Data["test"] as! String) + String(self.API.Response.Data["time"] as! Int) //Data to UI Label
            
            //Receive an Array from the API
            for arraycontent in self.API.Response.Data["array"] as! Array<String> {
                self.responseLabel.text! += arraycontent
            }
        } else {
            //API is busy - Request cancelled
        }
   }
```

## Protocol
By using API.call(...) the method sends your params via POST to the server. Additionaly the METHOD is sent to the server, so that key is reserved. The server then responds with a JSON encoded associative array. The custom response of the server should be located in an associative array that will be decoded on the client side (see json.php example). On the server side the key 'RESULT' should be set to 'SUCCESS' if the request was successful, or to anything else in case of an error.


## Troubleshooting
If using an insecure connection (http - non https for example), use this manual: https://stackoverflow.com/questions/32631184/the-resource-could-not-be-loaded-because-the-app-transport-security-policy-requi
