# APIRequest
iOS Swift / Xcode APIRequest Class. This class uses the native URLSession to handle API-Requests asynchronous, non blocking. It sends parameters via POST to the server and receive a JSON Array of data mapped to a Dictionary.

## Installation
Add the APIRequest.swift file to your project and upload the json.php to some webserver that is reachable via the internet.

## Example
Initialize the class (maybe globally in your view controller)
```swift
  var API = APIRequest("http://example.com/json.php")
```

Inside some function, make the call like this
```swift
    let params = [
        "name": "John Doe",
        "mail": "johndoe@example.com"
    ]
    API.BlockWhenBusy = true //Default is false. This will make the API cancel all requests if another request is still pending.
    API.call(method: "TEST", parameters: params, ResponseHandler: MyResponseHandler)
```

Add a Responsehandler to handle the API Response
```swift
    func MyResponseHandler(success: Bool) {
        if (success) {
            //API Request was sucsessfully submitted, do something with the response data
            var myVar = self.API.Response.Data["test"] as! String //Data to variable
            self.responseLabel.text = (self.API.Response.Data["test"] as! String) + String(self.API.Response.Data["time"] as! Int) + (self.API.Response.Data["uid"] as! String) //Data to UI Label
            
            //Receive an Array from the API
            for arraycontent in self.API.Response.Data["array"] as! Array<String> {
                self.responseLabel.text! += arraycontent
            }
        } else {
            //API is busy - Request cancelled
        }
    }
```
## Troubleshooting
If using an insecure connection (http - non https for example), use this manual: https://stackoverflow.com/questions/32631184/the-resource-could-not-be-loaded-because-the-app-transport-security-policy-requi
