# goSell iOS SDK

iOS SDK to use [goSell API][1].

[![Platform](https://img.shields.io/cocoapods/p/goSellSDK.svg?style=flat)](https://tap-payments.github.io/goSellSDK-iOS)
[![Build Status](https://travis-ci.org/Tap-Payments/goSellSDK-iOS.svg?branch=master)](https://travis-ci.org/Tap-Payments/goSellSDK-iOS)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/goSellSDK.svg?style=flat)](https://img.shields.io/Tap-Payments/v/goSellSDK)
<!---[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)-->
[![Applications](https://img.shields.io/cocoapods/at/goSellSDK.svg?style=flat)](https://tap-payments.github.io/goSellSDK-iOS)

A library that fully covers payment process inside your iOS application.

# Table of Contents 
1. [Installation](#Installation)
    1. [Installation with CocoaPods](#installation_with_cocoapods)
2. [Setup](#Setup)
3. [Usage](#Usage)

# Installation
---------
## Installation with CocoaPods <a name ="installation_with_cocoapods"></a>

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
<!---
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
-->
# Setup
First of all, `goSellSDK` should be set up. To set it up, add the following line of code somewhere in your project and make sure it will be called before any usage of `goSellSDK`, otherwise an exception will be thrown.

*Swift*:

```swift
goSellSDK.secretKey = "YOUR_SECRET_KEY" // Secret key (format: "sk_XXXXXXXXXXXXXXXXXXXXXXXX")
```

*Objective-C*:

```objective-c
[goSellSDK setSecretKey:@"YOUR_SECRET_KEY"]; // Secret key (format: "sk_XXXXXXXXXXXXXXXXXXXXXXXX")

```
or

```objective-c
goSellSDK.secretKey = @"YOUR_SECRET_KEY"; // Secret key (format: "sk_XXXXXXXXXXXXXXXXXXXXXXXX")
```

Don't forget to import the framework at the beginning of the file:

*Swift*:

```swift
import goSellSDK
```

*Objective-C*:


```objective-c
@import goSellSDK;
```
or

```objective-c
#import <goSellSDK/goSellSDK-Swift.h>
```

#Usage

After `goSellSDK` is set up, you can actually use the SDK.<br>
We have tried to make the SDK integration as simple as possible, requiring the minimum from you.

**goSellSDK** works in 2 modes:

1. *Purchase*: Default mode. Normal customer charge.
2. *Authorize*: Only authorization is happening. You should specify an action after successful authorization: either capture the amount or void the charge after specific period of time.

The mode is set through **PaymentDataSource** interface.

##Pay Button
Here at Tap, we have designed our custom Pay button and all you need to do is just to put it somewhere on the screen and provide at least required payment details through its ```dataSource``` property.
###Pay Button Placement

Pay Button is restricted to the height of exactly **44 points**. For better experience, make sure that it has enough **width** to display the content.

####XIB/Storyboard
You can add Pay button on your view in XIB/Storyboard file.
To do that, do the following:

1. Drag & drop an instance of ```UIView``` at the desired location.
2. Select added view and open **Identity Inspector**
3. Enter the following values:
   1. Class: **PayButton**
   2. Module: **goSellSDK**
4. For your convenience, you may also connect ```dataSource``` and ```delegate``` outlets.

####Code
You can also add Pay button with the code:

*Swift*:

```swift
import goSellSDK
...
func addPayButton() {

    let buttonFrame = CGRect(x: 8.0, y: UIScreen.main.bounds.height - 52.0, width: UIScreen.main.bounds.width - 16.0, height: 44.0)
    let button = PayButton(frame: buttonFrame)
    self.view.addSubview(button) // or where you want it
    
    button.dataSource = self // or whatever
    button.delegate = self // or whatever
}
```

*Objective-C*:


```objective-c
@import goSellSDK;
...
- (void)addPayButton {

    CGRect buttonFrame = CGRectMake(8.0, UIScreen.mainScreen.bounds.size.height - 52.0, UIScreen.mainScreen.bounds.size.width - 16.0, 44.0);
    PayButton *button = [[PayButton alloc] initWithFrame:buttonFrame];
    [self.view addSubview:button]; // or where you want it
    
    button.dataSource = self; // or whatever
    button.delegate = self; // or whatever
}

```

### Properties
Below is the list of Pay button properties

<table style="text-align:center">

    <th colspan=2>Property</th>
    <th colspan=2>Type</th>
    <th rowspan=2>Description</th>
    
    <tr>
        <th>Objective-C</td><th>Swift</td>
        <th>Objective-C</td><th>Swift</td>
    </tr>
    <tr>
        <td><i>enabled</i></td><td><i>isEnabled</i></td>
        <td><b>BOOL</b></td><td><b>Bool</b></td>
        <td align="justify">Defines whether the button is enabled.<br>Perhaps you will need it for your internal logic.</td>
    </tr>
    <tr>
        <td colspan=2><i>dataSource</i></td>
        <td><b>id&lt;PaymentDataSource&gt;</b></td><td><b>PaymentDataSource</b></td>
        <td align="justify">Pay button data source. All input payment information is passed through this protocol. Required.</td>
    </tr>
    <tr>
        <td colspan=2><i>delegate</i></td>
        <td><b>id&lt;PaymentDelegate&gt;</b></td><td><b>PaymentDelegate</b></td>
        <td align="justify">Pay button delegate. Payment status along with all output payment information is passed through this protocol.</td>
    </tr>
</table>

###Methods

<table style="text-align:center">

    <th colspan=2>Method</th>
    <th rowspan=2>Description</th>
    
    <tr>
        <th>Objective-C</th><th>Swift</th>
    </tr>
    <tr>
        <td> <nobr>- (<i>void</i>)updateDisplayedAmount</nobr> </td><td><nobr>func updateDisplayedAmount()</nobr></td>
        <td align="justify">Call this method to update displayed amount on the button.<br><b>Note:</b> If amount is non positive then pay button is force disabled.</td>
    </tr>
</table>

##PaymentDataSource

**PaymentDataSource** is an interface which you should implement somewhere in your code to pass payment information to an instance of Pay button in order to be able to access payment flow within the SDK.

The following table describes its structure and specifies which fields are required for each of the modes.

<table style="text-align:center">
    
    <th rowspan=2>Member</th>
    <th colspan=2>Type</th>
    <th colspan=2>Required</th>
    <th rowspan=2>Description</th>
    
    <tr>
        <th>Objective-C</th><th>Swift</th>
        <th>Purchase</th><th>Authorize</th>
    </tr>
    <tr>
        <td><i>currency</i></td>
        <td colspan=2><b>Currency</b></td>
        <td colspan=2><i>true</i></td>
        <td align="justify">Currency of the transaction.</td>
    </tr>
    <tr>
        <td><i>customer</td>
        <td colspan=2><b>CustomerInfo</b></td>
        <td colspan=2><i>true</i></td>
        <td align="justify">Customer information. For more details on how to create the customer, please refer to <b>CustomerInfo </b> class reference.</td>
    </tr>
    <tr>
        <td><i>items</i></td>
        <td><b><nobr>NSArray&lt;PaymentItem *&gt;</nobr></b></td><td><b>[PaymentItem]</b></td>
        <td colspan=2><i>true</i></td>
        <td align="justify">List of items to pay for.</td>
    </tr>
    <tr>
        <td><i>mode</i></td>
        <td colspan=2><b>TransactionMode</b></td>
        <td colspan=2><i>false</i></td>
        <td align="justify">Mode of the transactions (purchase or authorize). If this property is not implemented, <i>purchase</i> mode is used.</td>
    </tr>
    <tr>
        <td><i>taxes</i></td>
        <td><b><nobr>NSArray&lt;Tax *&gt;</nobr></b></td><td><b>[Tax]</b></td>
        <td colspan=2><i>false</i></td>
        <td align="justify">You can specify taxation details here. By default, there are no taxes.<br> <b>Note:</b> specifying taxes will affect total payment/authorization amount.</td>
    </tr>
    <tr>
        <td><i>shipping</i></td>
        <td><b><nobr>NSArray&lt;Shipping *&gt;</nobr></b></td><td><b>[Shipping]</b></td>
        <td colspan=2><i>false</i></td>
        <td align="justify">You can specify shipping details here. By default, there are no shipping details.<br> <b>Note:</b> specifying shipping will affect total payment/authorization amount.</td>
    </tr>
    <tr>
        <td><i>postURL</i></td>
        <td><b>NSURL</b></td><td><b>URL</b></td>
        <td colspan=2><i>false</i></td>
        <td align="justify">The URL which will be called by Tap system notifying that payment has either succeed or failed.</td>
    </tr>
    <tr>
        <td><i>paymentDescription</i></td>
        <td><b>NSString</b></td><td><b>String</b></td>
        <td colspan=2><i>false</i></td>
        <td align="justify">Description of the payment.</td>
    </tr>
    <tr>
        <td><i>paymentMetadata</i></td>
        <td><b><nobr>NSDictionary&lt;NSString *, NSString *&gt;</nobr></b></td><td><b><nobr>[String: String]</nobr></b></td>
        <td colspan=2><i>false</i></td>
        <td align="justify">Additional information you would like to pass along with the transaction.</td>
    </tr>
    <tr>
        <td><i>paymentReference</i></td>
        <td colspan=2><b>Reference</b></td>
        <td colspan=2><i>false</i></td>
        <td align="justify">You can keep a reference to the transaction using this property.</td>
    </tr>
    <tr>
        <td><i>paymentStatementDescriptor</i></td>
        <td><b>NSString</b></td><td><b>String</b></td>
        <td colspan=2><i>false</i></td>
        <td align="justify">Statement descriptor.</td>
    </tr>
    <tr>
        <td><i>require3DSecure</i></td>
        <td><b>BOOL</b></td><td><b>Bool</b></td>
        <td colspan=2><i>false</i></td>
        <td align="justify">Defines if 3D secure check is required. If not implemented, treated as <i>true</i>.<br><b>Note:</b> If you disable 3D secure check, it still may occure. Final decision is taken by Tap.</td>
    </tr>
    <tr>
        <td><i>receiptSettings</i></td>
        <td colspan=2><b>Receipt</b></td>
        <td colspan=2><i>false</i></td>
        <td align="justify">Receipt recipient details.</td>
    </tr>
    <tr>
        <td><i>authorizeAction</i></td>
        <td colspan=2><b>AuthorizeAction</b></td>
        <td><i>false</i></td><td><i>true</i></td>
        <td align="justify">Action to perform after authorization succeeds.</td>
    </tr>
</table>

##PaymentDelegate

**PaymentDelegate** is an interface which you may want to implement to receive payment/authorization status updates and update your user interface accordingly when payment window closes.

The table below lists down all available callbacks.

<table style="text-align:center">
    
    <tr>
        <td />
        <th>Method</th>
        <th>Parameters</th>
        <th>Description</th>
    </tr>
    <tr>
        <th><nobr>Objective-C</nobr></th>
        <td align="left"><nobr>- (void)paymentSucceed:(Charge * _Nonnull)charge payButton:(id &lt;PayButtonProtocol&gt; _Nonnull)payButton</nobr></td>
        <td rowspan=2 align="justify"><b>charge</b>: Successful charge<br><b>payButton</b>: Pay button which has initiated the payment.</td>
        <td rowspan=2 align="justify">Notifies the receiver that payment has succeed, passing successful charge and the button which has initiated the payment.</td>
    <tr>
        <th>Swift</th>
        <td align="left"><nobr>func paymentSucceed(_ charge: Charge, payButton: PayButtonProtocol)</nobr></td>
    <tr>
    
</table>


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
    
    // static source
    let staticKNETSource = CreateChargeSource(staticIdentifier: .KNET)
    
    // with plain card data
    let plainSource = CreateChargeSource(cardNumber: "4111111111111111", expirationMonth: 10, expirationYear: 20, cvc: "123")
}
```

*Objective-C*:

```objective-c
- (void)exampleCreateSource {
    
    // with token identifier
    CreateChargeSource *tokenSource = [[CreateChargeSource alloc] initWithTokenIdentifier:@"tok_XXXXXXXXXXXXXXXXXXXXXXXX"];
    
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

-----
# Documentation
Documentation is available at [github-pages][2].<br>
Also documented sources are attached to the library.

[1]:https://www.tap.company/developers/
[2]:https://tap-payments.github.io/goSellSDK-iOS/