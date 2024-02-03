# DataDogLog 🐶

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjagreenwood%2Fswift-log-datadog%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/jagreenwood/swift-log-datadog)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjagreenwood%2Fswift-log-datadog%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/jagreenwood/swift-log-datadog)

This package implements a handler for [swift-log](https://github.com/apple/swift-log) which will send log messages to the [Datadog's](https://www.datadoghq.com) Log Management service.

## Usage

###  Add Package 📦
Integrate the `DataDogLog` package as a dependency with Swift Package Manager. Add the following to `Package.swift`:

```swift
.package(url: "git@github.com:jagreenwood/swift-log-datadog.git", from: "1.0.0")
```

Add `DataDogLog`  to your target dependencies:

```swift
.product(name: "DataDogLog", package: "swift-log-datadog")
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
logger.error("unfortunate error", metadata: ["request-id": "abc-123"], source: "module-name")
```

This call will send the following payload to Datadog:

```json
{
    "message": "2020-05-27T06:37:17-0400 ERROR: unfortunate error",
    "hostname": "hostname",
    "ddsource": "module-name",
    "ddtags": "callsite:testLog():39,foo:bar,request-id:abc-123",
    "status": "error"
    "service": "com.swift-log.awesome-app"
}
```

### Select Region 🌎

The Datadog API runs on multiple regions (e.g. US, EU, US3, US5, US1FED), with different API endpoints. If your account was not created in the default **US** region, you need to set the `region` option when initializing `DataDogLogHandler`:

```swift
DataDogLogHandler(label: $0, key: "xxx", hostname: "hostname", region: .EU)
```
