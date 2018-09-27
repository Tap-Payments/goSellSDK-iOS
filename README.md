# goSell iOS SDK

iOS SDK to use [goSell API][1].

[![Platform](https://img.shields.io/cocoapods/p/goSellSDK.svg?style=flat)](https://tap-payments.github.io/goSellSDK-iOS)
[![Build Status](https://travis-ci.org/Tap-Payments/goSellSDK-iOS.svg?branch=master)](https://travis-ci.org/Tap-Payments/goSellSDK-iOS)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/goSellSDK.svg?style=flat)](https://img.shields.io/Tap-Payments/v/goSellSDK)
[![Applications](https://img.shields.io/cocoapods/at/goSellSDK.svg?style=flat)](https://tap-payments.github.io/goSellSDK-iOS)
<!---[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)-->


A library that fully covers payment process inside your iOS application.

# Table of Contents 
---

1. [Requirements](#requirements)
2. [Installation](#installation)
    1. [Installation with CocoaPods](#installation_with_cocoapods)
3. [Setup](#setup)
    1. [Setup Steps](#setup_steps)
4. [Usage](#usage)
    1. [Pay Button](#pay_button)
        1. [Pay Button Placement](#pay_button_placement)
        2. [Properties](#pay_button_properties)
        3. [Methods](#pay_button_methods)
    2. [Payment Data Source](#payment_data_source)
        1. [Structure](#payment_data_source_structure)
        2. [Samples](#payment_data_source_samples)
    3. [Payment Delegate](#payment_delegate)
        1. [Payment Success Callback](#payment_success_callback)
        2. [Authorization Success Callback](#authorization_success_callback)
        3. [Payment Failure Callback](#payment_failure_callback)
        4. [Authorization Failure Callback](#authorization_failure_callback)
        5. [Payment/Authorization Cancel Callback](#payment_cancel_callback)
        

<a name="requirements"></a>
# Requirements
---

To use the SDK the following requirements must be met:

1. **Xcode 10.0** or newer
2. **Swift 4.2** or newer (preinstalled with Xcode)   
3. Base SDK for the target app: **iOS 8.0** or later

<a name="installation"></a>
# Installation
---

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
---
First of all, `goSellSDK` should be set up. In this section only secret key is required.

<a name="setup_gosellsdk_class_properties"></a>
## goSellSDK Class Properties

Below is the list of properties in goSellSDK class you can manipulate. Make sure you do the setup before any usage of the SDK.

<a name="setup_gosellsdk_class_properties_secret_key"></a>
### Secret Key

To set it up, add the following line of code somewhere in your project and make sure it will be called before any usage of `goSellSDK`, otherwise an exception will be thrown. **Required**.

*Swift*:

```swift
let secretKey = SecretKey(sanbox: "YOUR_SANDBOX_SECRET_KEY", production: "YOUR_PRODUCTION_SECRET_KEY") // (format of the key: "sk_XXXXXXXXXXXXXXXXXXXXXXXX")
goSellSDK.secretKey = secretKey // Secret key (format: "sk_XXXXXXXXXXXXXXXXXXXXXXXX")
```

*Objective-C*:

```objective-c
SecretKey *secretKey = [[SecretKey alloc] initWithSandbox:@"YOUR_SANDBOX_SECRET_KEY" production:@"YOUR_PRODUCTION_SECRET_KEY"]; // (format of the key: "sk_XXXXXXXXXXXXXXXXXXXXXXXX")
[goSellSDK setSecretKey:secretKey];
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

<a name="setup_gosellsdk_class_properties_mode"></a>
### Mode

SDK mode is a mode SDK is operating in, either **sandbox** or **production**.

Use this property to test your integration with the sandbox transactions.

**WARNING:** Default value of this property is *production* which means your transaction are real transactions. Switch to *sandbox* while in development.

<a name="setup_gosellsdk_class_properties_language"></a>
### Language

Localization language of the UI part of the SDK. This is locale identifier. 

Make sure it consists only from 2 lowercased letters and is presented in the list of **availableLanguages** property of *goSellSDK* class.

**Notice:** Starting from *iOS 9* SDK user interface layout direction is based on the language you select, which means that if you would like to have it in Arabic language, the UI will be switched to RTL (right-to-left).

### Available Languages

This property returns the list of locale identifiers the SDK is currently localized into.

<a name="setup_steps"></a>
## Setup Steps

1. Place *PayButton*.
2. Assign its *datasource* and *delegate*.
3. Implement *datasource* and *delegate*.

<a name="usage"></a>
# Usage
---

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
        <th><sub><nobr>Objective-C</nobr></sub></td><th><sub>Swift</sub></td>
         <th><sub><nobr>Objective-C</nobr></sub></td><th><sub>Swift</sub></td>
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
        <th><sub><nobr>Objective-C</nobr></sub></th><th><sub>Swift</sub></th>
    </tr>
    <tr>
        <td><sub><nobr>- (void)updateDisplayedAmount</nobr></sub></td><td><sub><nobr>func updateDisplayedAmount()</nobr></sub></td>
        <td align="justify"><sub>Call this method to update displayed amount on the button.<br><b>Note:</b> If amount is non positive then pay button is force disabled.</sub></td>
    </tr>
</table>

<a name="payment_data_source"></a>
## Payment Data Source

**PaymentDataSource** is an interface which you should implement somewhere in your code to pass payment information to an instance of Pay button in order to be able to access payment flow within the SDK.

<a name="payment_data_source_structure"></a>
### Strucure

The following table describes its structure and specifies which fields are required for each of the modes.

<table style="text-align:center">
    <th rowspan=2>Member</th>
    <th colspan=2>Type</th>
    <th colspan=2>Required</th>
    <th rowspan=2>Description</th>
    <tr>
        <th><sub>Objective-C</sub></th><th><sub>Swift</sub></th>
        <th><sub>Purchase</sub></th><th><sub>Authorize</sub></th>
    </tr>
    <tr>
        <td><sub><i>currency</i></sub></td>
        <td colspan=2><sub><b>Currency</b></sub></td>
        <td colspan=2><sub><i>true</i></sub></td>
        <td align="left"><sub>Currency of the transaction.</sub></td>
    </tr>
    <tr>
        <td><sub><i>customer</i></sub></td>
        <td colspan=2><sub><b>Customer</b></sub></td>
        <td colspan=2><sub><i>true</i></sub></td>
        <td align="left"><sub>Customer information. For more details on how to create the customer, please refer to <i>Customer</i> class reference.</sub></td>
    </tr>
    <tr>
        <td><sub><i>amount</i></sub></td>
        <td><sub><b><nobr>NSDecimal</nobr></b></sub></td><td><sub><b><nobr>Decimal</nobr></b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>Payment/Authorization amount.<br><b>Note:</b> In order to have payment amount either <i>amount</i> or <i>items</i> should be implemented. If both are implemented, <i>items</i> is preferred.</sub></td>
    </tr>
    <tr>
        <td><sub><i>items</i></sub></td>
        <td><sub><b><nobr>NSArray&lt;PaymentItem *&gt;</nobr></b></sub></td><td><sub><b><nobr>[PaymentItem]</nobr></b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>List of items to pay for.<br><b>Note:</b> In order to have payment amount either <i>amount</i> or <i>items</i> should be implemented. If both are implemented, <i>items</i> is preferred.</sub></td>
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
        <td align="left"><sub>You can specify taxation details here. By default, there are no taxes.<br> <b>Note:</b> Specifying taxes will affect total payment/authorization amount.</sub></td>
    </tr>
    <tr>
        <td><sub><i>shipping</i></sub></td>
        <td><sub><b><nobr>NSArray&lt;Shipping *&gt;</nobr></b></sub></td><td><sub><b><nobr>[Shipping]</nobr></b></sub></td>
        <td colspan=2><sub><i>false</i></sub></td>
        <td align="left"><sub>You can specify shipping details here. By default, there are no shipping details.<br> <b>Note:</b> Specifying shipping will affect total payment/authorization amount.</sub></td>
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

<a name="payment_data_source_samples"></a>
### Samples
---

#### Currency

Tap supports processing payments in 10+ currencies, allowing you to charge customers in their native currency while receiving funds in yours. This is especially helpful if you have a global presence, as charging in a customer’s native currency can increase sales. 

##### SupportedCurrencies

|      Currency     | Code |
|-------------------|------|
| UAE Dirham        | AED  |
| Bahraini Dinar    | BHD  |
| Egyptian Pound    | EGP  |
| Euro              | EUR  |
| UK Pound Sterling | GBP  |
| Kuwaiti Dinar     | KWD  |
| Omani Riyal       | OMR  |
| Qatari Riyal      | QAR  |
| Saudi Riyal       | SAR  |
| US Dollar         | USD  |

**Objective-C**

```objective-c
- (Currency *)currency {
    
    return [Currency withISOCode:@"KWD"];
}
```

**Swift**

```swift
var currency: Currency? {
        
    return .with(isoCode: "KWD")
}
```

#### Customer
-

**Objective-C**

```objective-c
- (Customer *)customer {
    
    if ( customerIDIsKnown ) {
        
        return [self identifiedCustomer];
    }
    else {
        
        return [self newCustomer];
    }
}

/// Creating a customer with known identifier received from Tap before.
- (Customer *)identifiedCustomer {
    
    return [[Customer alloc] initWithIdentifier:@"cus_tomer_id"];
}

/// Creating a customer with raw information.
- (Customer *)newCustomer {
    
    EmailAddress *email = [EmailAddress withEmailAddressString:@"customer@mail.com"];
    PhoneNumber *phoneNumber = [[PhoneNumber alloc] initWithISDNumber:@"965" phoneNumber:@"96512345"];
    
    Customer *newCustomer = [[Customer alloc] initWithEmailAddress:email
                                                       phoneNumber:phoneNumber
                                                         firstName:@"Steve"
                                                        middleName:nil
                                                          lastName:@"Jobs"];
    
    return newCustomer;
}
```

**Swift**

```swift
var customer: Customer? {
        
    if customerIDIsKnown {
            
        return self.identifiedCustomer
    }
    else {
            
        return self.newCustomer
    }
}

/// Creating a customer with known identifier received from Tap before.
var identifiedCustomer: Customer? {
        
    return try? Customer(identifier: "cus_to_mer")
}

/// Creating a customer with raw information. 
var newCustomer: Customer? {
        
    let emailAddress = try! EmailAddress(emailAddressString: "customer@mail.com")
    let phoneNumber = try! PhoneNumber(isdNumber: "965", phoneNumber: "96512345")
        
    return try? Customer(emailAddress:  emailAddress,
                         phoneNumber:   phoneNumber,
                         firstName:     "Steve",
                         middleName:    nil,
                         lastName:      "Jobs")
}
```
#### Amount
-

**Objective-C**

```objective-c
- (NSDecimal)amount {
    
    return [NSDecimalNumber one].decimalValue;
}
```

**Swift**

```swift
var amount: Decimal {
        
    return 1.0
}
```

#### Items
-

**Objective-C**

```objective-c
- (NSArray<PaymentItem *> *)items {
    
    Quantity *oneUnit = [[Quantity alloc] initWithValue:[NSDecimalNumber one].decimalValue
                                      unitOfMeasurement:[Measurement units]];
    NSDecimal ten = [[NSDecimalNumber one] decimalNumberByMultiplyingByPowerOf10:1].decimalValue;
    
    PaymentItem *firstItem = [[PaymentItem alloc] initWithTitle:@"Test item #1"
                                                       quantity:oneUnit
                                                  amountPerUnit:ten];
    
    
    NSDecimal oneHundred = [[NSDecimalNumber one] decimalNumberByMultiplyingByPowerOf10:2].decimalValue;
    Quantity *oneHundredSquareMeters = [[Quantity alloc] initWithValue:oneHundred unitOfMeasurement:[Measurement area:SquareMeters]];
    
    NSDecimal seventeen = [NSDecimalNumber numberWithDouble:17.0].decimalValue;
    
    AmountModificator *tenPercents = [[AmountModificator alloc] initWithPercents:ten];
    
    NSDecimal oneThousand = [[NSDecimalNumber one] decimalNumberByMultiplyingByPowerOf10:3].decimalValue;
    
    AmountModificator *thousandMoney = [[AmountModificator alloc] initWithFixedAmount:oneThousand];
    Tax *thousandKD = [[Tax alloc] initWithTitle:@"KD 1,000.000" descriptionText:@"This is an example of a tax." amount:thousandMoney];
    
    PaymentItem *secondItem = [[PaymentItem alloc] initWithTitle:@"Test item #2"
                                                 descriptionText:@"Test item #2 awesome description"
                                                        quantity:oneHundredSquareMeters
                                                   amountPerUnit:seventeen
                                                        discount:tenPercents
                                                           taxes:@[thousandKD]];
    
    return @[firstItem, secondItem];
}
```

**Swift**

```swift
var items: [PaymentItem]? {
        
    let oneUnit = Quantity(value: 1, unitOfMeasurement: .units)
    let firstItem = PaymentItem(title:          "Test item #1",
                                quantity:       oneUnit,
                                amountPerUnit:  10)
        
    let oneHundredSquareMeters = Quantity(value:                100,
                                          unitOfMeasurement:    .area(.squareMeters))
    let tenPercents = AmountModificator(percents: 10)
    let thousandMoney = AmountModificator(fixedAmount: 1000)
    let thousandKD = Tax(title:             "KD 1,000.000",
                         descriptionText:   "This is an example of a tax.",
                         amount: thousandMoney)
        
    let secondItem = PaymentItem(title:             "Test item #2",
                                 descriptionText:   "Test item #2 awesome description.",
                                 quantity:          oneHundredSquareMeters,
                                 amountPerUnit:     17,
                                 discount:          tenPercents,
                                 taxes:             [thousandKD])
        
    return [firstItem, secondItem]
}
```

#### Mode
-

**Objective-C**

```objective-c
- (enum TransactionMode)mode {
    
    return Purchase;
}
```

**Swift**

```swift
var mode: TransactionMode {
        
    return .purchase
}
```

#### Taxes
-

**Objective-C**

```objective-c
- (NSArray<Tax *> *)taxes {
    
    NSDecimal fifteen = [NSDecimalNumber numberWithDouble:15.0].decimalValue;
    AmountModificator *fifteenPercents = [[AmountModificator alloc] initWithPercents:fifteen];
    
    Tax *fifteenPercentsTax = [[Tax alloc] initWithTitle:@"15 percents"
                                         descriptionText:@"Just another fifteen percents."
                                                  amount:fifteenPercents];
    
    return @[fifteenPercentsTax];
}
```

**Swift**

```swift
var taxes: [Tax]? {
        
    let fifteenPercents = AmountModificator(percents: 15)
    
    let fifteenPercentsTax = Tax(title:             "15 percents",
                                 descriptionText:   "Just another fifteen percents",
                                 amount:            fifteenPercents)
        
    return [fifteenPercentsTax]
}
```

#### Shipping
-

**Objective-C**

```objective-c
- (NSArray<Shipping *> *)shipping {
    
    NSDecimal fiveHundred = [NSDecimalNumber numberWithDouble:500.0].decimalValue;
    Shipping *deliveryToHome = [[Shipping alloc] initWithName:@"Delivery"
                                              descriptionText:@"Delivery to Home"
                                                       amount:fiveHundred];
    
    return @[deliveryToHome];
}
```

**Swift**

```swift
var shipping: [Shipping]? {
        
    let deliveryToHome = Shipping(name:             "Delivery",
                                  descriptionText:  "Delivery to Home",
                                  amount:           500)
    return [deliveryToHome]
}
```

#### Post URL
-

**Objective-C**

```objective-c
- (NSURL *)postURL {
    
    return [NSURL URLWithString:@"https://tap.company/post"];
}
```

**Swift**

```swift
var postURL: URL? {
        
    return URL(string: "https://tap.company/post")
}
```

#### Payment Description
-

**Objective-C**

```objective-c
- (NSString *)paymentDescription {
    
    return @"Awesome payment description will be here.";
}
```

**Swift**

```swift
var paymentDescription: String? {
        
    return "Awesome payment description will be here.";
}
```

#### Payment Metadata
-

**Objective-C**

```objective-c
- (NSDictionary<NSString *,NSString *> *)paymentMetadata {
    
    return @{@"note": @"some note",
             @"internal_linking_id": @"id3424141414"};
}
```

**Swift**

```swift
var paymentMetadata: [String : String]? {
        
    return [
        
        "note": "some note",
        "internal_linking_id": "id3424141414"
    ]
}
```

#### Payment Reference
-

**Objective-C**

```objective-c
- (Reference *)paymentReference {
    
    return [[Reference alloc] initWithTransactionNumber:@"tr_2352358020f"
                                            orderNumber:@"ord_2352094823"];
}
```

**Swift**

```swift
var paymentReference: Reference? {
        
    return Reference(transactionNumber: "tr_2352358020f",
                     orderNumber:       "ord_2352094823")
}
```

#### Payment Statement Descriptor
-

**Objective-C**

```objective-c
- (NSString *)paymentStatementDescriptor {
    
    return @"Payment statement descriptor will be here";
}
```

**Swift**

```swift
var paymentStatementDescriptor: String? {
        
    return "Payment statement descriptor will be here"
}
```

#### Require 3D Secure
-

**Objective-C**

```objective-c
- (BOOL)require3DSecure {
    
    return YES;
}
```

**Swift**

```swift
var require3DSecure: Bool {
        
    return true
}
```

#### Receipt Settings
-

**Objective-C**

```objective-c
- (Receipt *)receiptSettings {
    
    return [[Receipt alloc] initWithEmail:YES sms:YES];
}
```

**Swift**

```swift
var receiptSettings: Receipt? {
        
    return Receipt(email: true, sms: true)
}
```

#### Authorize Action
-

**Objective-C**

```objective-c
- (AuthorizeAction *)authorizeAction {
    
    AuthorizeAction *captureAfterTwoHours = [AuthorizeAction captureAfterTimeInHours:2];
    return captureAfterTwoHours;
}
```

**Swift**

```swift
var authorizeAction: AuthorizeAction {
        
    return .capture(after: 2)
}
```

<a name="payment_delegate"></a>
## Payment Delegate

**PaymentDelegate** is an interface which you may want to implement to receive payment/authorization status updates and update your user interface accordingly when payment window closes.

Below are listed down all available callbacks:

<a name="payment_success_callback"></a>
### Payment Success Callback
-

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
-

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
-

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
-

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
-

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
