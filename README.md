# goSell iOS SDK
iOS SDK to use [goSell API][1].

[![Platform](https://img.shields.io/cocoapods/p/goSellSDK.svg?style=flat)](https://tap-payments.github.io/goSellSDK-iOS)
[![Build Status](https://travis-ci.org/Tap-Payments/goSellSDK-iOS.svg?branch=master)](https://travis-ci.org/Tap-Payments/goSellSDK-iOS)
[![Documentation](docs/badge.svg)](https://tap-payments.github.io/goSellSDK-iOS/)
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
$ pod update
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

*Swift*:

```swift
import goSellSDK // import goSellSDK framework

func setupGoSellSDK() {
	
	goSellSDK.authenticationKey = "YOUR_AUTHENTICATION_KEY" // Authentication key
	goSellSDK.encryptionKey = "YOUR_ENCRYPTION_KEY"         // Encryption key
}
```

*Objective-C*:


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

Example of **token** creation:

*Swift*:

```swift
func exampleCreateToken() {
        
    let fullCard = CreateTokenCard(number: "4111111111111111",
                                   expirationMonth: 10,
                                   expirationYear: 20,
                                   cvc: "123",
                                   name: "Testing VISA card",
                                   city: "Some city",
                                   country: "Some country",
                                   addressLine1: "First line",
                                   addressLine2: "Second line",
                                   addressState: "Royal State",                                    
                                   addressZip: 007)
        
    let request = CreateTokenRequest(card: fullCard)
        
    TokenClient.createToken(with: request) { (token, error) in
            
        if let _ = token {
                
            NSLog("Successfully created token.")
        }
        else {
                
            NSLog("Failed to create token with error: \(error!)")
        }
    }
}
```

*Objective-C*:

```objective-c
- (void)exampleCreateToken {
    
    CreateTokenCard  *fullCard = [[CreateTokenCard alloc] initWithNumber:@"4111111111111111"
                                                         expirationMonth:10
                                                          expirationYear:20
                                                                     cvc:@"123"
                                                                    name:@"Testing VISA card"
                                                                    city:@"Some city"
                                                                 country:@"Some country"
                                                            addressLine1:@"First line"
                                                            addressLine2:@"Second line"
                                                            addressState:@"Royal State"
                                                              addressZip:007];
    
    CreateTokenRequest *request = [[CreateTokenRequest alloc] initWithCard:fullCard];
    
    [TokenClient createTokenWith:request completion:^(Token * _Nullable token, TapSDKError * _Nullable error) {
        
        if (token) {
            
            NSLog(@"Successfully created token.");
        }
        else {
            
            NSLog(@"Failed to create token with error: %@", error);
        }
    }];
}
```

### Customers

To interact with the Customer APIs, please refer to the `CustomersClient` class inside the SDK.

Example of **customer** creation:

*Swift*:

```swift
func exampleCreateCustomer() {
    
    let request = CreateCustomerRequest(name: "CUSTOMER_NAME", phone: "PHONE_NUMBER", email: "EMAIL_ADDRESS")
    CustomersClient.createCustomer(with: request) { (customer, error) in
            
        if let _ = customer {
            
            NSLog("Customer successfully created.")
        }
        else {
            
            NSLog("Failed to create customer with error: \(error!)")
        }
    }
}
```

*Objective-C*:

```objective-c
- (void)exampleCreateCustomer {
    
    CreateCustomerRequest *request = [[CreateCustomerRequest alloc] initWithName:@"CUSTOMER_NAME" phone:@"PHONE_NUMBER" email:@"EMAIL_ADDRESS"];
    [CustomersClient createCustomerWith:request completion:^(Customer * _Nullable customer, TapSDKError * _Nullable error) {
       
        if ( customer ) {
        
            NSLog(@"Customer successfully created.");
        }
        else {
            
            NSLog(@"Failed to create customer with error: %@", error);
        }
    }];
}
```

### Cards

To interact with the Cards APIs, please refer to the `CardClient` class inside the SDK.

Example of **card** creation:

*Swift*:

```swift
func exampleCreateCard() {
    
    let request = CreateCardRequest(tokenIdentifier: "tok_XXXXXXXXXXXXXXXXXXXXXXXX")
    CardClient.createCard(for: "cus_XXXXXXXXXXXXXXXXXXXXXXX", with: request) { (card, error) in
        
        if let _ = card {
        
            NSLog("Successfully created card.")
        }
        else {
        
            NSLog("Failed to create card with error: \(error!)")
        }
    }
}
```

*Objective-C*:

```objective-c
+ (void)exampleCreateCard {
    
    CreateCardRequest *request = [[CreateCardRequest alloc] initWithTokenIdentifier:@"tok_XXXXXXXXXXXXXXXXXXXXXXXX"];
    [CardClient createCardFor:@"cus_XXXXXXXXXXXXXXXXXXXXXXX" with:request completion:^(Card * _Nullable card, TapSDKError * _Nullable error) {
        
        if ( card ) {
        
            NSLog(@"Successfully created card.");
        }
        else {
        
            NSLog(@"Failed to create card with error: %@", error);
        }
    }];
}
```

### Charges

To interact with the Charges APIs, please refer to the `ChargeClient` class inside the SDK.

Example of **charge** creation:

*Swift*:

```swift
func exampleCreateCharge() {
        
	let redirect = CreateChargeRedirect(returnURL: URL(string: "your_return_url")!, postURL: URL(string: "your_post_url")!)
    let source = CreateChargeSource(tokenIdentifier: "tok_XXXXXXXXXXXXXXXXXXXXXXXX")
    let request = CreateChargeRequest(amount: 1000.0, currency: "kwd", redirect: redirect, source: source)
        
    ChargeClient.createCharge(with: request) { (charge, error) in
            
        if let _ = charge {
                
            NSLog("Charge successfully created.")
        }
        else {
                
            NSLog("Failed to create charge with error: \(error!)")
        }
    }
}

```

*Objective-C*:

```objective-c
- (void)exampleCreateCharge {
    
    CreateChargeRedirect *redirect = [[CreateChargeRedirect alloc] initWithReturnURL:[NSURL URLWithString:@"your_return_url"]
                                                                             postURL:[NSURL URLWithString:@"your_post_url"]];
    
    CreateChargeSource *source = [[CreateChargeSource alloc] initWithTokenIdentifier:@"tok_XXXXXXXXXXXXXXXXXXXXXXXX"];
    
    CreateChargeRequest *request = [[CreateChargeRequest alloc] initWithAmount:[NSDecimalNumber numberWithInteger:1000].decimalValue
                                                                      currency:@"kwd"
                                                                      redirect:redirect
                                                                        source:source];
    
    [ChargeClient createChargeWith:request completion:^(Charge * _Nullable charge, TapSDKError * _Nullable error) {
        
        if ( charge ) {
            
            NSLog(@"Charge successfully created.");
        }
        else {
            
            NSLog(@"Failed to create charge with error: %@", error);
        }
    }];
}
```

Example of **source** creation:

*Swift*:

```swift
func exampleCreateSource() {
    
    // with token identifier
    let tokenSource = CreateChargeSource(tokenIdentifier: "tok_XXXXXXXXXXXXXXXXXXXXXXXX")
    
    // with static source
    let staticKNETSource = CreateChargeSource(staticIdentifier: .KNET)
    
    // with card identifier
    let cardSource = CreateChargeSource(cardIdentifier: "card_XXXXXXXXXXXXXXXXXXXXXXXX")
    
    // with plain card data
    let plainSource = CreateChargeSource(cardNumber: "4111111111111111", expirationMonth: 10, expirationYear: 20, cvc: "123")
}
```

*Objective-C*:

```objective-c
- (void)exampleCreateSource {
    
    // with token identifier
    CreateChargeSource *tokenSource = [[CreateChargeSource alloc] initWithTokenIdentifier:@"tok_XXXXXXXXXXXXXXXXXXXXXXXX"];
    
    /// with card identifier
    CreateChargeSource *cardSource = [[CreateChargeSource alloc] initWithCardIdentifier:@"card_XXXXXXXXXXXXXXXXXXXXXXXX"];
    
    // static source
    CreateChargeSource *staticKNETSource = [[CreateChargeSource alloc] initWithStaticIdentifier:SourceIdentifierKNET];
    
    // with plain card data
    CreateChargeSource *plainSource = [[CreateChargeSource alloc] initWithCardNumber:@"4111111111111111" expirationMonth:10 expirationYear:20 cvc:@"123"];
}
```

Example of **redirect** creation:

*Swift*:

```swift
func exampleCreateRedirect() {
        
    // without post url
    let redirectWithoutPostURL = CreateChargeRedirect(returnURL: URL(string: "your_return_url")!)
        
    // with post url
    let redirectWithPostURL = CreateChargeRedirect(returnURL: URL(string: "your_return_url")!, postURL: URL(string: "your_post_url")!)
}
```

*Objective-C*:

```objective-c
- (void)exampleCreateRedirect {
    
    // without post url
    CreateChargeRedirect *redirectWithoutPostURL = [[CreateChargeRedirect alloc] initWithReturnURL:[NSURL URLWithString:@"your_return_url"]];
    
    // with post url
    CreateChargeRedirect *redirectWithPostURL = [[CreateChargeRedirect alloc] initWithReturnURL:[NSURL URLWithString:@"your_return_url"] postURL:[NSURL URLWithString:@"your_post_url"]];
}
```

### BIN Lookup

To interact with the BIN API, please refer to the `BINClient` class inside the SDK.

Usage example:

*Swift*:

```swift
func exampleBINLookup() {

    BINClient.getBINNumberDetails(for: "411111") { (response, error) in
        
        if let nonnullResponse = response {
        
            // do something with BIN response
        }
        else {
        
            NSLog("Error occured while retrieving BIN information: \(error!)")
        }
    }
}
```

*Objective-C*:

```objective-c
- (void)exampleBINLookup {

    [BINClient getBINNumberDetailsFor:@"411111" completion:^(BINResponse * _Nullable response, TapSDKError * _Nullable error) {
        
        if ( response ) {
            
            // do something with response
        }
        else {
            
            NSLog("Error occured while retrieving BIN information: %@", error);
        }
    }];
}
```

-----
# Documentation
Documentation is available at [github-pages][2].<br>
Also documented sources are attached to the library.

[1]:https://www.tap.company/developers/
[2]:https://tap-payments.github.io/goSellSDK-iOS/