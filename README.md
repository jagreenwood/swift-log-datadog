# DataDogLog 🐶

![Swift](https://img.shields.io/badge/Swift-5.2-orange.svg)
![Release](https://img.shields.io/github/v/tag/jagreenwood/swift-log-data-dog?label=release&logo=github)
![Unit Test](https://github.com/jagreenwood/swift-log-data-dog/workflows/Unit%20Test/badge.svg)

This package implements a handler for [swift-log](https://github.com/apple/swift-log) which will send log messages to the [Datadog's](https://www.datadoghq.com) Log Management service.

## Usage

###  Add Package 📦
Integrate the `DataDogLog` package as a dependency with Swift Package Manager. Add the following to `Package.swift`:

```swift
.package(url: "git@github.com:jagreenwood/swift-log-data-dog.git", from: "0.0.1")
```

Add `DataDogLog`  to your target dependencies:

```swift
.product(name: "DataDogLog", package: "swift-log-data-dog")
```

### Configure ⚙️

Configure the logger by bootstrapping a `DataDogLogHandler` instance.

```swift
import DataDogLog

// add handler to logging system
LoggingSystem.bootstrap {
    // initialize handler instance
    var handler = DataDogLogHandler(label: $0, key: "xxx", hostname: "hostname")
    // global metadata (optional)
    handler.metadata = ["foo":"bar"]

    return handler
}
```

### Logging 🌲

To send logs to Datadog, initialize a `Logger` instance and send a message with optional additional metadata:

```swift
import DataDogLog

let logger = Logger(label: "com.swift-log.awesome-app")
logger.error("unfortunate error", metadata: ["request-id": "abc-123"])
```

This call will send the following payload to Datadog:

```swift
{
    "message": "2020-05-27T06:37:17-0400 ERROR: unfortunate error",
    "hostname": "hostname",
    "ddsource": "com.swift-log.awesome-app",
    "ddtags": "callsite:testLog():39,foo:bar,request-id:abc-123"
}
```
