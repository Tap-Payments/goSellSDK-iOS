# goSell iOS SDK
iOS SDK to use [goSell API][1].

[![Platform](https://img.shields.io/cocoapods/p/goSellSDK.svg?style=flat)](https://tap-payments.github.io/goSellSDK-iOS)
[![Build Status](https://travis-ci.org/Tap-Payments/goSellSDK-iOS.svg?branch=master)](https://travis-ci.org/Tap-Payments/goSellSDK-iOS)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/goSellSDK.svg?style=flat)](https://img.shields.io/Tap-Payments/v/goSellSDK)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Applications](https://img.shields.io/cocoapods/at/goSellSDK.svg?style=flat)](https://tap-payments.github.io/goSellSDK-iOS)

# Install
---------
## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager, which automates and simplifies the process of using 3rd-party libraries in your projects.<br>You can install it with the following command:

```bash
$ gem install cocoapods
```

### Podfile

To integrate goSellSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'MyApp' do
    
    pod 'goSellSDK'

end
```

Then, run the following command:

```bash
$ pod install
```

## Installation with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate goSellSDK into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Tap-Payments/goSellSDK-iOS"
```

Run `carthage` to build the framework and drag the built `goSellSDK.framework` into your Xcode project.

# Usage
---------

## Setup
First of all, `goSellSDK` should be set up. To set it up, add the following lines of code somewhere in your project and make sure they will be called before any usage of `goSellSDK`.

Swift:

```swift
import goSellSDK // import goSellSDK framework

func setupGoSellSDK() {
	
	goSellSDK.authenticationKey = "YOUR_AUTHENTICATION_KEY" // Authentication key
	goSellSDK.encryptionKey = "YOUR_ENCRYPTION_KEY"         // Encryption key
}
```

Objective-C:


```objective-c
@import goSellSDK;
// or
#import <goSellSDK/goSellSDK-Swift.h>

- (void)setupGoSellSDK {
    
    [goSellSDK setAuthenticationKey:@"YOUR_AUTHENTICATION_KEY"]; // Authentication key
    [goSellSDK setEncryptionKey:@"YOUR_ENCRYPTION_KEY"];         // Encryption key
}

```
## API calls

After `goSellSDK` is set up, you can start calling the APIs.<br>The SDK is designed in a way that each of the sections has its own API manager.

Currently the following sections are available:

### Tokens

Tokens are used in charges. The interact with the Tokens APIs, please refer to the `TokenClient` class inside the SDK.

### Charges

To interact with the Charges APIs, please refer to the `ChargeClient` class inside the SDK.

# Documentation
-------------
Documentation is available at [github-pages][2].<br>
Also documented sources are attached to the library.

[1]:https://www.tap.company/developers/
[2]:https://tap-payments.github.io/goSellSDK-iOS/