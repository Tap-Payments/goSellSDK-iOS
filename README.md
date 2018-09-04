# goSell iOS SDK

iOS SDK to use [goSell API][1].

[![Platform](https://img.shields.io/cocoapods/p/goSellSDK.svg?style=flat)](https://tap-payments.github.io/goSellSDK-iOS)
[![Build Status](https://travis-ci.org/Tap-Payments/goSellSDK-iOS.svg?branch=master)](https://travis-ci.org/Tap-Payments/goSellSDK-iOS)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/goSellSDK.svg?style=flat)](https://img.shields.io/Tap-Payments/v/goSellSDK)
[![Applications](https://img.shields.io/cocoapods/at/goSellSDK.svg?style=flat)](https://tap-payments.github.io/goSellSDK-iOS)
<!---[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)-->


A library that fully covers payment process inside your iOS application.

# Table of Contents 
1. [Installation](#installation)
    1. [Installation with CocoaPods](#installation_with_cocoapods)
2. [Setup](#setup)
3. [Usage](#usage)
    1. [Pay Button](#pay_button)
        1. [Pay Button Placement](#pay_button_placement)
        2. [Properties](#pay_button_properties)
        3. [Methods](#pay_button_methods)
    2. [Payment Data Source](#payment_data_source)
    3. [Payment Delegate](#payment_delegate)
        1. [Payment Success Callback](#payment_success_callback)
        2. [Authorization Success Callback](#authorization_success_callback)
        3. [Payment Failure Callback](#payment_failure_callback)
        4. [Authorization Failure Callback](#authorization_failure_callback)
        5. [Payment/Authorization Cancel Callback](#payment_cancel_callback)
        

<a name="installation"></a>
# Installation
---------
<a name="installation_with_cocoapods"></a>
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

<a name="setup"></a>
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

<a name="usage"></a>
# Usage

After `goSellSDK` is set up, you can actually use the SDK.<br>
We have tried to make the SDK integration as simple as possible, requiring the minimum from you.

**goSellSDK** works in 2 modes:

1. *Purchase*: Default mode. Normal customer charge.
2. *Authorize*: Only authorization is happening. You should specify an action after successful authorization: either capture the amount or void the charge after specific period of time.

The mode is set through **PaymentDataSource** interface.

<a name="pay_button"></a>
## Pay Button
Here at Tap, we have designed our custom Pay button and all you need to do is just to put it somewhere on the screen and provide at least required payment details through its ```dataSource``` property.

<a name="pay_button_placement"></a>
### Pay Button Placement 

Pay Button is restricted to the height of exactly **44 points**. For better experience, make sure that it has enough **width** to display the content.

#### XIB/Storyboard
You can add Pay button on your view in XIB/Storyboard file.
To do that, do the following:

1. Drag & drop an instance of ```UIView``` at the desired location.
2. Select added view and open **Identity Inspector**
3. Enter the following values:
   1. Class: **PayButton**
   2. Module: **goSellSDK**
4. For your convenience, you may also connect ```dataSource``` and ```delegate``` outlets.

#### Code
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

<a name="pay_button_properties"></a>
### Properties

Below is the list of Pay button properties

<table style="text-align:center">
    <th colspan=2>Property</th>
    <th colspan=2>Type</th>
    <th rowspan=2>Description</th>
    <tr>
        <th><nobr>Objective-C</nobr></td><th>Swift</td>
        <th><nobr>Objective-C</nobr></td><th>Swift</td>
    </tr>
    <tr>
        <td><sub><i>enabled</i></sub></td><td><sub><i>isEnabled</i></sub></td>
        <td><sub><b>BOOL</b></sub></td><td><sub><b>Bool</b></sub></td>
        <td align="justify"><sub>Defines whether the button is enabled.<br>Perhaps you will need it for your internal logic.</sub></td>
    </tr>
    <tr>
        <td colspan=2><sub><i>dataSource</i></sub></td>
        <td><sub><b>id&lt;PaymentDataSource&gt;</b></sub></td><td><sub><b>PaymentDataSource</b></sub></td>
        <td align="justify"><sub>Pay button data source. All input payment information is passed through this protocol. Required.</sub></td>
    </tr>
    <tr>
        <td colspan=2><sub><i>delegate</i></sub></td>
        <td><sub><b>id&lt;PaymentDelegate&gt;</b></sub></td><td><sub><b>PaymentDelegate</b></sub></td>
        <td align="justify"><sub>Pay button delegate. Payment status along with all output payment information is passed through this protocol.</sub></td>
    </tr>
</table>

<a name ="pay_button_methods"></a>
### Methods

<table style="text-align:center">
    <th colspan=2>Method</th>
    <th rowspan=2>Description</th>
    <tr>
        <th><nobr>Objective-C</nobr></th><th>Swift</th>
    </tr>
    <tr>
        <td><sub><nobr>- (void)updateDisplayedAmount</nobr></sub></td><td><sub><nobr>func updateDisplayedAmount()</nobr></sub></td>
        <td align="justify"><sub>Call this method to update displayed amount on the button.<br><b>Note:</b> If amount is non positive then pay button is force disabled.</sub></td>
    </tr>
</table>

<a name="payment_data_source"></a>
## Payment Data Source

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
        <td><sub><i>currency</i></sub></td>
        <td colspan=2><sub><b>Currency</b></sub></td>
        <td colspan=2><sub><i>true</i></sub></td>
        <td align="left"><sub>Currency of the transaction.</sub></td>
    </tr>
    <tr>
        <td><sub><i>customer</i></sub></td>
        <td colspan=2><sub><b>CustomerInfo</b></sub></td>
        <td colspan=2><sub><i>true</i></sub></td>
        <td align="left"><sub>Customer information. For more details on how to create the customer, please refer to <b>CustomerInfo</b> class reference.</sub></td>
    </tr>
    <tr>
        <td><sub><i>items</i></sub></td>
        <td><sub><b><nobr>NSArray&lt;PaymentItem *&gt;</nobr></b></sub></td><td><sub><b><nobr>[PaymentItem]</nobr></b></sub></td>
        <td colspan=2><sub><i>true</i></sub></td>
        <td align="left"><sub>List of items to pay for.</sub></td>
    </tr>
    <tr>
        <td><sub><i>mode</i></sub></td>
        <td colspan=2><sub><b>TransactionMode</b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>Mode of the transactions (purchase or authorize). If this property is not implemented, <i>purchase</i> mode is used.</sub></td>
    </tr>
    <tr>
        <td><sub><i>taxes</i></sub></td>
        <td><sub><b><nobr>NSArray&lt;Tax *&gt;</nobr></b></sub></td><td><sub><b><nobr>[Tax]</nobr></b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>You can specify taxation details here. By default, there are no taxes.<br> <b>Note:</b> specifying taxes will affect total payment/authorization amount.</sub></td>
    </tr>
    <tr>
        <td><sub><i>shipping</i></sub></td>
        <td><sub><b><nobr>NSArray&lt;Shipping *&gt;</nobr></b></sub></td><td><sub><b><nobr>[Shipping]</nobr></b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>You can specify shipping details here. By default, there are no shipping details.<br> <b>Note:</b> specifying shipping will affect total payment/authorization amount.</sub></td>
    </tr>
    <tr>
        <td><sub><i>postURL</i></sub></td>
        <td><sub><b>NSURL</b></sub></td><td><sub><b>URL</b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>The URL which will be called by Tap system notifying that payment has either succeed or failed.</sub></td>
    </tr>
    <tr>
        <td><sub><i>paymentDescription</i></sub></td>
        <td><sub><b>NSString</b></sub></td><td><sub><b>String</b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>Description of the payment.</sub></td>
    </tr>
    <tr>
        <td><sub><i>paymentMetadata</i></sub></td>
        <td><sub><b><nobr>NSDictionary&lt;NSString *, NSString *&gt;</nobr></b></sub></td><td><sub><b><nobr>[String: String]</nobr></b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>Additional information you would like to pass along with the transaction.</sub></td>
    </tr>
    <tr>
        <td><sub><i>paymentReference</i></sub></td>
        <td colspan=2><sub><b>Reference</b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>You can keep a reference to the transaction using this property.</sub></td>
    </tr>
    <tr>
        <td><sub><i>paymentStatementDescriptor</i></sub></td>
        <td><sub><b>NSString</b></sub></td><td><sub><b>String</b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>Statement descriptor.</sub></td>
    </tr>
    <tr>
        <td><sub><i>require3DSecure</i></sub></td>
        <td><sub><b>BOOL</b></sub></td><td><sub><b>Bool</b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>Defines if 3D secure check is required. If not implemented, treated as <i>true</i>.<br><b>Note:</b> If you disable 3D secure check, it still may occure. Final decision is taken by Tap.</sub></td>
    </tr>
    <tr>
        <td><sub><i>receiptSettings</i></sub></td>
        <td colspan=2><sub><b>Receipt</b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>Receipt recipient details.</sub></td>
    </tr>
    <tr>
        <td><sub><i>authorizeAction</i></sub></td>
        <td colspan=2><sub><b>AuthorizeAction</b></sub></td>
        <td><sub><i>false</i></sub></td><td><sub><i>true</i></sub></td>
        <td align="left"><sub>Action to perform after authorization succeeds.</sub></td>
    </tr>
</table>

<a name="payment_delegate"></a>
## Payment Delegate

**PaymentDelegate** is an interface which you may want to implement to receive payment/authorization status updates and update your user interface accordingly when payment window closes.

Below are listed down all available callbacks:

<a name="payment_success_callback"></a>
### Payment Success Callback

Notifies the receiver that payment has succeed.

#### Declaration

*Objective-C:*

```objective-c
- (void)paymentSucceed:(Charge * _Nonnull)charge payButton:(id <PayButtonProtocol> _Nonnull)payButton;
```

*Swift:*

```swift
func paymentSucceed(_ charge: Charge, payButton: PayButtonProtocol)
```

#### Arguments

**charge**: Successful charge object.

**payButton**: Button which has initiated the payment.

<a name="authorization_success_callback"></a>
### Authorization Success Callback

Notifies the receiver that authorization has succeed.

#### Declaration

*Objective-C:*

```objective-c
- (void)authorizationSucceed:(Authorize * _Nonnull)authorize payButton:(id <PayButtonProtocol> _Nonnull)payButton;
```

*Swift:*

```swift
func authorizationSucceed(_ authorize: Authorize, payButton: PayButtonProtocol)
```

#### Arguments

**authorize**: Successful authorize object.

**payButton**: Button which has initiated the authorization.

<a name="payment_failure_callback"></a>
### Payment Failure Callback

Notifies the receiver that payment has failed.

#### Declaration

*Objective-C:*

```objective-c
- (void)paymentFailedWith:(Charge * _Nullable)charge error:(TapSDKError * _Nullable)error payButton:(id <PayButtonProtocol> _Nonnull)payButton;
```

*Swift:*

```swift
func paymentFailed(with charge: Charge?, error: TapSDKError?, payButton: PayButtonProtocol)
```
#### Arguments

**charge**: Charge object that has failed (if reached the stage of charging).

**error**: An error that has occured (if any).

**payButton**: Button which has initiated the payment.

You may assume that at least one, `charge` or `error` is not `nil`.

<a name="authorization_failure_callback"></a>
### Authorization Failure Callback

Notifies the receiver that authorization has failed.

#### Declaration

*Objective-C:*

```objective-c
- (void)authorizationFailedWith:(Authorize * _Nullable)authorization error:(TapSDKError * _Nullable)error payButton:(id <PayButtonProtocol> _Nonnull)payButton;
```

*Swift:*

```swift
func authorizationFailed(with authorization: Authorize?, error: TapSDKError?, payButton: PayButtonProtocol)
```
#### Arguments

**authorize**: Authorize object that has failed (if reached the stage of authorization).

**error**: An error that has occured (if any).

**payButton**: Button which has initiated the authorization.

You may assume that at least one, `authorize` or `error` is not `nil`.

<a name="payment_cancel_callback"></a>
### Payment/Authorization Cancel Callback

Notifies the receiver that payment/authorization was cancelled by user.

#### Declaration

*Objective-C:*

```objective-c
- (void)paymentCancelled:(id <PayButtonProtocol> _Nonnull)payButton;
```

*Swift:*

```swift
func paymentCancelled(_ payButton: PayButtonProtocol)
```

#### Arguments

**payButton**: Button which has initiated the payment/authorization.

-----
# Documentation
Documentation is available at [github-pages][2].<br>
Also documented sources are attached to the library.

[1]:https://www.tap.company/developers/
[2]:https://tap-payments.github.io/goSellSDK-iOS/
