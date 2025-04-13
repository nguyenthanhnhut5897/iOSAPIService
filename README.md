
# iOSAPIService

**iOSAPIService** is a lightweight Swift package that streamlines API requests and response handling in iOS applications. It provides a modular architecture with built-in support for caching, date formatting, flexible decoding, and environment-specific configurations.

---

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
  - [Perform a Request](#perform-a-request)
  - [Configure Environment](#configure-environment)
- [License](#license)
- [Components](#components)
- [Utilities](#utilities)
- [Installation](#installation)
- [Author](#author)
- [Contributions](#contributions)

---

## Introduction

**iOSAPIService** helps developers create robust API integrations with minimal code. The package includes several key components:

- **Requestable**: Define reusable request formats.
- **ApiConfigurable**: Configure common parameters (e.g., base URL, headers) for different environments (development, staging, production).
- **ApiService**: Execute API calls and handle responses from the server.
- **APICacheCenter**: Manage caching of responses.
- **APIDateFormatter**: Format date strings from server responses.
- **AnyDecodable**: Decode responses where the type may not be known in advance.

This package is perfect for projects that require a streamlined approach to API communication and data handling.

---

## Usage

### Perform a Request

To perform a request, first create a type conforming to the `Requestable` protocol. Then, use the `ApiService` to execute the API call. For example:

```swift
// Define your endpoint by conforming to Requestable
struct GetUserRequest: Requestable {
    typealias Response = UserDTO
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/users/\(username ?? "")"
    }
    
    var headerField: [String : String] {
        return ["Content-Type" : "application/json;charset=utf-8"]
    }
    
    var username: String?
    
    init(username: String? = nil) {
        self.username = username
    }
}

// Performing the request with ApiService
let request = GetUserRequest(username: "12345")
ApiService.shared.send(request) { (result: Result<UserDTO, Error>) in
    switch result {
    case .success(let user):
        print("User Data: \(user)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

### Configure Environment

To configure different environments (development, staging, production), create an instance of `ApiConfigurable` and assign the appropriate configuration values. 

This setup not only supports switching between environments, but also allows you to configure API requests per service or source. For example, if your backend is structured into multiple microservices (e.g., auth, user, product), or if you are calling third-party APIs, each can have its own configuration instance that includes specific base URLs, headers, or other metadata.

For example:

```swift
// Configuring the environment
let apiConfig = ApiConfig()
apiConfig.baseURL = URL(string: "https://api.example.com")
apiConfig.sessionToken = "Bearer token"
apiConfig.additionalHeaders = ["langKey": "en"]

```

---

## Components

### Requestable
The `Requestable` protocol defines the format for making API requests, including the HTTP method, path, and parameters.

### ApiConfigurable
The `ApiConfigurable` protocol allows configuration of environment-specific settings such as base URL and headers.

### ApiService
The `ApiService` class executes API calls using a specified `Requestable` and handles responses.

### APICacheCenter
The `APICacheCenter` class manages caching for API responses, enabling you to store and retrieve data.

---

## Utilities

- **BodyEncoding**: Helper for encoding request body data.
- **ResponseDecoder**: Helper for decoding responses from the server into Swift types.
- **APIDateFormatter**: Utility for formatting date strings returned by the API.

---

## Installation

- To integrate iOSAPIService into your Xcode project using `Swift Package Manager`, add the following dependency:

```swift
dependencies: [
    .package(url: "https://github.com/nguyenthanhnhut5897/iOSAPIService.git", from: "1.0.4")
]
```
- To integrate iOSAPIService using `CocoaPods`, add the following line to your Podfile:
```swift
pod 'iOSAPIService', :git => 'https://github.com/nguyenthanhnhut5897/iOSAPIService.git', :tag => '1.0.4'
```
---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Author

**Nguyen Thanh Nhut**  
[GitHub](https://github.com/nguyenthanhnhut5897)

---

## Contributions

Contributions are welcome! Please fork the repository and create a pull request with your proposed changes.
