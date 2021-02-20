# APIRequest
iOS Swift APIRequest Class

# Example
Upload the json.php to some webserver and link the API.APIUrl to the file. If using an insecure connection, use this manual: https://stackoverflow.com/questions/32631184/the-resource-could-not-be-loaded-because-the-app-transport-security-policy-requi

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
