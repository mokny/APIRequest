# APIRequest
iOS Swift APIRequest Class

# Example
Upload the json.php to some webserver and link the API.APIUrl to the file. If using an insecure connection, use this manual: https://stackoverflow.com/questions/32631184/the-resource-could-not-be-loaded-because-the-app-transport-security-policy-requi

Initialize the class (maybe globally in your view controller)
```swift
  var API = APIRequest()
```

Inside some function, make the call like this
```swift
    let params = [
        "bla": "blabla",
        "asd": "asdasdasdasd"
    ]
    API.call(method: "ASD", parameters: params, ResponseHandler: MyResponseHandler)
```

Add a Responsehandler to handle the API Response
```swift
    func MyResponseHandler(json: Any) {
        var test = self.API.Response.Data["test"] //Into a variable
        self.responseLabel.text = self.API.Response.Data["test"] //Directly into the UI - here a label
    }
```
