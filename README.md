# goSell iOS SDK

iOS SDK to use [goSell API][1].

[![Platform](https://img.shields.io/cocoapods/p/goSellSDK.svg?style=flat)](https://tap-payments.github.io/goSellSDK-iOS)
[![Build Status](https://travis-ci.org/Tap-Payments/goSellSDK-iOS.svg?branch=master)](https://travis-ci.org/Tap-Payments/goSellSDK-iOS)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/goSellSDK.svg?style=flat)](https://img.shields.io/Tap-Payments/v/goSellSDK)
[![Documentation](docs/badge.svg)](https://tap-payments.github.io/goSellSDK-iOS)

A library that fully covers payment/authorization/card saving process inside your iOS application.

# Table of Contents 

---

1. [Requirements](#requirements)
2. [Installation](#installation)
   1. [Installation with CocoaPods](#installation_with_cocoapods)
   2. [Installation with Carthage](#installation_with_carthage)
   3. [M1 based Macs](#M1 based_Macs)
   4. [Installation with App Clip](#Installation_To_App_Clip)
3. [Setup](#setup)
   1. [goSellSDK Class Properties](#setup_gosellsdk_class_properties)
   2. [goSellSDK Class Methods](#setup_gosellsdk_class_methods)
   3. [Setup Steps](#setup_steps)
4. [Usage](#usage)
   1. [SDK modes](#sdk_modes)
   2. [Pay Button](#pay_button)
      1. [Pay Button Placement](#pay_button_placement)
      2. [Properties](#pay_button_properties)
      3. [Methods](#pay_button_methods)
   3. [Session](#session)
      1. [Properties](#session_properties)
       2. [Methods](#session_methods)
   4. [API Session](#api_session)
      1. [Properties](#api_session_properties)
       2. [Methods](#api_session_methods)
   5. [Session Data Source](#session_data_source)
      1. [Structure](#session_data_source_structure)
      2. [Samples](#session_data_source_samples)
   6. [Session Delegate](#session_delegate)
      1. [Payment Success Callback](#payment_success_callback)
      2. [Payment Failure Callback](#payment_failure_callback)
      3. [Authorization Success Callback](#authorization_success_callback)
      4. [Authorization Failure Callback](#authorization_failure_callback)
      5. [Card Saving Success Callback](#card_saving_success_callback)
      6. [Card Saving Failure Callback](#card_saving_failure_callback)
      7. [Card Tokenization Success Callback](#card_tokenization_success_callback)
      8. [Card Tokenization Failure Callback](#card_tokenization_failure_callback)
      9. [Session Is Starting Callback](#session_is_starting_callback)
      10. [Session Has Started Callback](#session_has_started_callback)
      11. [Session Has Failed to Start Callback](#session_has_failed_to_start_callback)
      12. [Session Cancel Callback](#session_cancel_callback)
   7. [Session Appearance](#session_appearance)
5. [Sample](#sample) 
        

<a name="requirements"></a>

# Requirements

---

To use the SDK the following requirements must be met:

1. **Xcode 10.0** or newer
2. **Swift 4.0** or newer (preinstalled with Xcode)   
3. Deployment target SDK for the  app: **iOS 11.0** or later
4. To support apps below iOS 11 please use this command : **pod "goSellSDK", '2.2.22'**

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

**To integrate goSellSDK into your Xcode 12+ project using CocoaPods, Please make sure you are using goSellSDK version >= 2.2.33**


To integrate goSellSDK into your iOS 11+ Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '12.0'
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

To integrate goSellSDK into your less than iOS 11 Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '11.0'
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'MyApp' do
    
    pod "goSellSDK", '2.2.22'

end
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

We also recommend you to include **ErrorReporting** submodule in order to allow your customers to report unexpected behaviour of the SDK directly to Tap.

To include error reporting, please add the following line to your `Podfile`:

```ruby
target 'MyApp' do
    
    # Other pods
    ...
    
    # Error reporting submodule.
    pod 'goSellSDK/ErrorReporting' 

end

```

<a name="setup"></a>

## M1 based Macs

You may face a compilation error when compiled using M1 based Mac devices, to solve this please follow these steps:

1. Close the Xcode.
  
2. Go to the `application` folder.
  
3. Find the `Xcode` icon.
  
4. Right click on Xcode icon.
  
5. Choose `Get info`
  
6. Check the option `Open using Rosetta`

![img](https://i.ibb.co/vQDnnwG/Stephen-Mickelsen-2-1645220554524.png)

## Installation To App Clip

Apple introduced in iOS 14+ an app on demand fashion called it "App Clip", where it gives the merchant the opportunity to provide his services on the go without the need for his customers to download an app.

In Tap we strive following the highest standards and utilising the latest provided technologies, hence we provided a comptible SDK to be embedded inside an App Clip target. The sdk is used exactly the same as this SDK code wise.

For more info please follow : [goSellAppClipSDK](https://github.com/Tap-Payments/goSellAppClipSDK)

# Setup

---

First of all, `goSellSDK` should be set up. In this section only secret key is required.

<a name="setup_gosellsdk_class_properties"></a>

## goSellSDK Class Properties

Below is the list of properties in goSellSDK class you can manipulate. Make sure you do the setup before any usage of the SDK.

<a name="setup_gosellsdk_class_properties_secret_key"></a>

### Secret Key

To set it up, add the following line of code somewhere in your project and make sure it will be called before any usage of `goSellSDK`, otherwise an exception will be thrown. **Required**.
PS: This key is just a ‘Tap identifier’ for the application integrating with our SDK. Please don’t confuse it with public/secret keys used for encryption and decryption, which are stored safely on our PCI approved servers.

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

Currently we support the following languages:

<table>
	<th style="text-align:center">Language</th><th style="text-align:center">Locale Identifier</th>
	<tr>
		<td>Arabic</td><td>ar</td>
	</tr>
	<tr>
		<td>English</td><td>en</td>
	</tr>
	<tr>
		<td>Russian</td><td>ru</td>
	</tr>
</table>



### SDK Version

This property returns current SDK version.

<a name="setup_gosellsdk_class_methods"></a>

## goSellSDK Class Methods

### Reset

Resets all settings and makes the SDK to reinitialize on next usage.<br>
Might be useful when you are switching accounts.<br>
Also when you are logging the user out, although that's not required.

<a name="setup_steps"></a>

## Setup Steps

### With PayButton

For those, who would like to use PayButton.

1. Place *PayButton*.
2. Assign its *datasource* and *delegate*.
3. Implement *datasource* and *delegate*.

### Without PayButton

For those who would like to keep their design and start the SDK process manually.

1. Create *Session* object.
2. Assign its *datasource* and *delegate*.
3. Implement *datasource* and *delegate*.

### Apple Pay

*Make sure, your current goSellSDK version is >= 2.2.12-beta*

1. Ask for the CSR from Tap team.

2. From your Apple Developer account:

3. 1. Create a merchant identifier

      A *merchant identifier* uniquely identifies you to Apple Pay as a merchant who is able to accept payments. You can use the same merchant identifier for multiple native and web apps. It never expires.

      1. In [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources), select Identifiers from the sidebar, then click the Add button (+) in the upper-left corner. ![img](https://i.imgur.com/50MJuuk.png)
      2. Select Merchant IDs, then click Continue. ![img](https://i.imgur.com/lYAE2am.png)
      3. Enter the merchant description and identifier name, then click Continue. ![img](https://i.imgur.com/w6gpIo4.png)
      4. Review the settings, then click Register.

   2. Create Payment Processing Certificate:A *payment processing certificate* is associated with your merchant identifier and used to encrypt payment information. The payment processing certificate expires every 25 months. If the certificate is revoked, you can recreate it.

      1. In [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources), select Identifiers from the sidebar. ![img](https://i.imgur.com/eBKFkvo.png)

      2. Under Identifiers, select Merchant IDs using the filter in the top-right.

      3. On the right, select your merchant identifier.

         *Note:* If a banner appears at the top of the page saying that you need to accept an agreement, click the Review Agreement button and follow the instructions before continuing.

      4. Under Apple Pay Payment Processing Certificate, click Create Certificate.

      5. [Create a certificate signing request](https://help.apple.com/developer-account/#/devbfa00fef7) on your Mac, and click Continue.

      6. Click Choose File.

      7. In the dialog that appears, select the certificate request file (a file with a `.certSigningRequest` file extension), then click Choose.

      8. Click Continue.

      9. Click Download.

         The certificate file (a file with a `.cer` file extension) appears in your `Downloads` folder.

4. Share your .cer file, merchant identifier and app bundle id back to Tap team.

5. Enable Apple Pay capability into your project from Xcode and select the merchant identifier. ![img](https://i.imgur.com/PT29us3.png)

6. Tap Apple Pay button will appear if:

   1. You did all the previous steps.
   2. The customer is paying with a currency that has Apple Pay option enabled from our side.
   3. The customer paying already activate Apple pay in his device.
   4. The customer paying has already added at least one valid card in his Apple Wallet with one our Apple pay payment networks.



<a name="usage"></a>

# Usage

---

After `goSellSDK` is set up, you can actually use the SDK.<br>
We have tried to make the SDK integration as simple as possible, requiring the minimum from you.

<a name="sdk_modes"></a>

## SDK Modes

**goSellSDK** works in 4 modes:

1. *Purchase*: Default mode. Normal customer charge.
2. *Authorize*: Only authorization is happening. You should specify an action after successful authorization: either capture the amount or void the charge after specific period of time.
3. *Card Saving*: Use this mode to save the card of the customer with Tap and use it later.
4. *Card Tokenization*: Use this mode if you are willing to perform the charging/authorization manually. The purpose of this mode is only to collect and tokenize card information details of your customer if you don't have PCI compliance certificate but willing to process the payment manually using our services.

The mode is set through **SessionDataSource** interface.

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
        <td><sub><b>id&lt;SessionDataSource&gt;</b></sub></td><td><sub><b>SessionDataSource</b></sub></td>
        <td align="justify"><sub>Session data source. All input payment information is passed through this protocol. Required.</sub></td>
    </tr>
    <tr>
        <td colspan=2><sub><i>delegate</i></sub></td>
        <td><sub><b>id&lt;SessionDelegate&gt;</b></sub></td><td><sub><b>SessionDelegate</b></sub></td>
        <td align="justify"><sub>Session delegate. Payment status along with all output payment information is passed through this protocol.</sub></td>
    </tr>
    <tr>
        <td colspan=2><sub><i>appearance</i></sub></td>
        <td><sub><b>id&lt;SessionAppearance&gt;</b></sub></td><td><sub><b>SessionAppearance</b></sub></td>
        <td align="justify"><sub>Session appearance. Implement only if you need UI customization. For more details please refer to SessionAppearance section.</sub></td>
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
        <td><sub><nobr>- (void)updateDisplayedState</nobr></sub></td><td><sub><nobr>func updateDisplayedState()</nobr></sub></td>
        <td align="justify"><sub>Call this method to update displayed amount on the button.<br><b>Note:</b> If amount is non positive then pay button is force disabled.</sub></td>
    </tr>
</table>



<a name="session"></a>

## Session

You want to use `Session` object if you are not using `PayButton`.

<a name="session_properties"></a>

### Properties

<table style="text-align:center">
    <th colspan=2>Property</th>
    <th colspan=2>Type</th>
    <th rowspan=2>Description</th>
    <tr>
        <th><sub><nobr>Objective-C</nobr></sub></td><th><sub>Swift</sub></td>
        <th><sub><nobr>Objective-C</nobr></sub></td><th><sub>Swift</sub></td>
    </tr>
    <tr>
    <td colspan="2"><sub><i>dataSource</i></sub></td>
    <td><sub><b>id&lt;SessionDataSource&gt;</b></sub></td><td><sub><b>SessionDataSource</b></sub></td>
    <td align="justify"><sub>Session data source. All input payment information is passed through this protocol. Required.</sub></td>
    </tr>
    <tr>
        <td colspan=2><sub><i>delegate</i></sub></td>
        <td><sub><b>id&lt;SessionDelegate&gt;</b></sub></td><td><sub><b>SessionDelegate</b></sub></td>
        <td align="justify"><sub>Session delegate. Payment status along with all output payment information is passed through this protocol.</sub></td>
    </tr>
    <tr>
        <td colspan=2><sub><i>appearance</i></sub></td>
        <td><sub><b>id&lt;SessionAppearance&gt;</b></sub></td><td><sub><b>SessionAppearance</b></sub></td>
        <td align="justify"><sub>Session appearance. Implement only if you need UI customization. For more details please refer to SessionAppearance section.</sub></td>
    </tr>
    <tr>
        <td colspan=2><sub><i>canStart</i></sub></td>
        <td><sub><b>BOOL</b></sub></td><td><sub><b>Bool</b></sub></td>
        <td align="justify"><sub>Readonly. Defines if session can start with the data you have provided through the <b>dataSource</b>.</sub></td>
    </tr>
</table>



<a name="session_methods"></a>

### Methods

<table style="text-align:center">
    <th colspan=2>Method</th>
    <th rowspan=2>Description</th>
    <tr>
        <th><sub><nobr>Objective-C</nobr></sub></th><th><sub>Swift</sub></th>
    </tr>
    <tr>
        <td colspan="2"><sub><nobr>calculateDisplayedAmount</nobr></sub></td>
        <td align="justify"><sub>Calculates and returns an amount based on the details provided through the <b>dataSource</b>. You might want to call this method every time you update your <b>dataSource</b> to reflect changes in UI if you are not using <i>PayButton</i> provided by the SDK.<br><b>Returns:</b> Amount suggested to display to the customer or <i>nil</i> in the following cases:
        	<ol>
				<li>Session cannot start with the provided details.</li>
				<li>You are in card saving mode.</li>
			</ol>
		</sub></td>
    </tr>
    <tr>
        <td colspan="2"><sub><nobr>start</nobr></sub></td>
        <td align="justify"><sub>Initiates the session.<br><b>Returns:</b> boolean value which determines whether all conditions are met to start the sesssion.</sub></td>
    </tr>
    <tr>
    	<td colspan="2"><sub><nobr>stop</nobr></sub></td>
    	<td align="justify"><sub>Stops the session. You might want to use this method when you need to close the SDK externally from your app, for example when performing a deep link.<br><b>Arguments:</b><br><i>completion</i>: Completion closure that will be called once all opened user interface of the SDK will be dismissed.</sub></td>
    </tr>
</table>



<a name="api_session"></a>

## API Session

**APISession** is a class you want to use when you need to call plain APIs without the UI. Currently not all APIs are available.

<a name="api_session_properties"></a>

### Properties

<table style="text-align:center">
    <th colspan=2>Property</th>
    <th colspan=2>Type</th>
    <th rowspan=2>Description</th>
    <tr>
        <th><sub><nobr>Objective-C</nobr></sub></td><th><sub>Swift</sub></td>
        <th><sub><nobr>Objective-C</nobr></sub></td><th><sub>Swift</sub></td>
    </tr>
    <tr>
    	<td><sub><i>sharedInstance</i></sub></td>
    	<td><sub><i>shared</i></sub></td>
    	<td colspan="2"><sub><b>APISession</b></sub></td>
    	<td align="justify"><sub>Shared singleton APISession instance.</sub></td>
    </tr>
</table>



<a name="api_session_methods"></a>

### Methods

Please refer to `APISession` class documentation for more details.

<a name="session_data_source"></a>

## Session Data Source

**SessionDataSource** is an interface which you should implement somewhere in your code to pass payment information  in order to be able to access payment flow within the SDK.

<a name="session_data_source_structure"></a>

### Strucure

The following table describes its structure and specifies which fields are required for each of the modes.

<table style="text-align:center">
    <th rowspan=2>Member</th>
    <th colspan=2>Type</th>
    <th colspan=3>Required</th>
    <th rowspan=2>Description</th>
    <tr>
        <th><sub>Objective-C</sub></th><th><sub>Swift</sub></th>
        <th><sub>Purchase</sub></th><th><sub>Authorize</sub></th><th><sub>Card Saving</sub></th>
    </tr>
    <tr>
        <td><sub><i>mode</i></sub></td>
        <td colspan=2><sub><b>TransactionMode</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Mode of the transactions (<b>purchase</b>, <b>authorize</b>, <b>card saving</b> or <b>card tokenization</b>). If this property is not implemented, <i>purchase</i> mode is used.</sub></td>
    </tr>
    <tr>
        <td><sub><i>customer</i></sub></td>
        <td colspan=2><sub><b>Customer</b></sub></td>
        <td colspan=3><sub><i>true</i></sub></td>
        <td align="left"><sub>Customer information. For more details on how to create the customer, please refer to <i>Customer</i> class reference.</sub></td>
    </tr>
    <tr>
        <td><sub><i>currency</i></sub></td>
        <td colspan=2><sub><b>Currency</b></sub></td>
        <td colspan=2><sub><i>true</i></sub></td><td><sub><i>false</i></sub></td>
        <td align="left"><sub>Currency of the transaction.</sub></td>
    </tr>
    <tr>
        <td><sub><i>amount</i></sub></td>
        <td><sub><b><nobr>NSDecimal</nobr></b></sub></td><td><sub><b><nobr>Decimal</nobr></b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Payment/Authorization amount.<br><b>Note:</b> In order to have payment amount either <i>amount</i> or <i>items</i> should be implemented. If both are implemented, <i>items</i> is preferred.</sub></td>
    </tr>
    <tr>
        <td><sub><i>items</i></sub></td>
        <td><sub><b>NSArray <nobr>&lt;PaymentItem *&gt;</nobr></b></sub></td><td><sub><b><nobr>[PaymentItem]</nobr></b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>List of items to pay for.<br><b>Note:</b> In order to have payment amount either <i>amount</i> or <i>items</i> should be implemented. If both are implemented, <i>items</i> is preferred.</sub></td>
    </tr>
    <tr>
        <td><sub><i>destinations</i></sub></td>
        <td><sub><b>NSArray <nobr>&lt;Destination *&gt;</nobr></b></sub></td><td><sub><b><nobr>[Destination]</nobr></b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>The list of merchant desired destinations accounts to receive funds from payment/authorization transactions.</sub></td>
    </tr>
    <tr>
		<td><sub><i>merchantID</i></sub></td>
       <td><sub><b>NSString</b></sub></td><td><sub><b>String</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>If you have multiple merchant accounts, please specify which one you would like to use through this field.</sub></td>
    </tr>
    <tr>
        <td><sub><i>taxes</i></sub></td>
        <td><sub><b>NSArray <nobr>&lt;Tax *&gt;</nobr></b></sub></td><td><sub><b><nobr>[Tax]</nobr></b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>You can specify taxation details here. By default, there are no taxes.<br> <b>Note:</b> Specifying taxes will affect total payment/authorization amount.</sub></td>
    </tr>
    <tr>
        <td><sub><i>shipping</i></sub></td>
        <td><sub><b>NSArray <nobr>&lt;Shipping *&gt;</nobr></b></sub></td><td><sub><b><nobr>[Shipping]</nobr></b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>You can specify shipping details here. By default, there are no shipping details.<br> <b>Note:</b> Specifying shipping will affect total payment/authorization amount.</sub></td>
    </tr>
    <tr>
        <td><sub><i>postURL</i></sub></td>
        <td><sub><b>NSURL</b></sub></td><td><sub><b>URL</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>The URL which will be called by Tap system notifying that payment has either succeed or failed.</sub></td>
    </tr>
    <tr>
        <td><sub><i>paymentDescription</i></sub></td>
        <td><sub><b>NSString</b></sub></td><td><sub><b>String</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Description of the payment.</sub></td>
    </tr>
    <tr>
        <td><sub><i>paymentMetadata</i></sub></td>
        <td><sub><b>NSDictionary <nobr>&lt;NSString *, NSString *&gt;</nobr></b></sub></td><td><sub><b><nobr>[String: String]</nobr></b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Additional information you would like to pass along with the transaction.</sub></td>
    </tr>
    <tr>
        <td><sub><i>paymentReference</i></sub></td>
        <td colspan=2><sub><b>Reference</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>You can keep a reference to the transaction using this property.</sub></td>
    </tr>
    <tr>
        <td><sub><i>paymentStatementDescriptor</i></sub></td>
        <td><sub><b>NSString</b></sub></td><td><sub><b>String</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Statement descriptor.</sub></td>
    </tr>
    <tr>
        <td><sub><i>require3DSecure</i></sub></td>
        <td><sub><b>BOOL</b></sub></td><td><sub><b>Bool</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Defines if 3D secure check is required. If not implemented, treated as <i>true</i>.<br><b>Note:</b> If you disable 3D secure check, it still may occure. Final decision is taken by Tap.</sub></td>
    </tr>
    <tr>
        <td><sub><i>receiptSettings</i></sub></td>
        <td colspan=2><sub><b>Receipt</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Receipt recipient details.</sub></td>
    </tr>
    <tr>
        <td><sub><i>authorizeAction</i></sub></td>
        <td colspan=2><sub><b>AuthorizeAction</b></sub></td>
        <td><sub><i>false</i></sub></td><td><sub><i>true</i></sub></td><td><sub><i>false</i></sub></td>
        <td align="left"><sub>Action to perform after authorization succeeds.</sub></td>
    </tr>
    <tr>
        <td><sub><i>allowsToSaveSameCardMoreThanOnce</i></sub></td>
        <td><sub><b>BOOL</b></sub></td><td><sub><b>Bool</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Defines if same card can be saved more than once.<br><b>Note:</b> Same cards means absolutely equal data set. For example, if customer specifies same card details, but different cardholder names, we will treat this like different cards.</sub></td>
    </tr>
	<tr>
        <td><sub><i>applePayMerchantID</i></sub></td>
        <td><sub><b>NSString</b></sub></td><td><sub><b>String</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Defines the Apple pay merchant id you get from Apple developer account</sub></td>
    </tr>
	<tr>
        <td><sub><i>allowedCadTypes</i></sub></td>
        <td><sub><b>NSArray<\CardType *></b></sub></td><td><sub><b>[CardType]</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Defines the allowed card types the merchant wants his clients to pay with (Credit, Debit, All)</sub></td>
    </tr>
    <tr>
        <td><sub><i>isSaveCardSwitchOnByDefault</i></sub></td>
        <td><sub><b>BOOL</b></sub></td><td><sub><b>Bool</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Defines if save card switch is on by default.<br><b>Note:</b> If value of this property is <i>true</i>, then switch will be remaining off until card information is filled and valid. And after will be toggled on automatically.</sub></td>
    </tr>
       <tr>
        <td><sub><i>paymentType</i></sub></td>
        <td colspan=2><sub><b>PaymentType</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Defines payment types to show.</sub></td>
    </tr>
  <tr>
        <td><sub><i>cardHolderName</i></sub></td>
        <td><sub><b>NSString</b></sub></td><td><sub><b>String</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Provide a default card holder name to be written in the card input view.</sub></td>
    </tr>
       <tr>
        <td><sub><i>paymentType</i></sub></td>
        <td colspan=2><sub><b>PaymentType</b></sub></td>
        <td colspan=3><sub><i>false</i></sub></td>
        <td align="left"><sub>Defines payment types to show.</sub></td>
    </tr>
</table>


<a name="session_data_source_samples"></a>

### Samples

---

#### Mode

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

#### Customer

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

#### Currency

Tap supports processing payments in 10+ currencies, allowing you to charge customers in their native currency while receiving funds in yours. This is especially helpful if you have a global presence, as charging in a customer’s native currency can increase sales. 

##### SupportedCurrencies

| Currency          | Code |
| ----------------- | ---- |
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

#### Amount

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

#### Taxes

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

#### Allows to Save Same Card More Than Once

**Objective-C**

```objective-c
- (BOOL)allowsToSaveSameCardMoreThanOnce {
    
    return NO;
}
```

**Swift**

```swift
var allowsToSaveSameCardMoreThanOnce: Bool {
        
    return false
}
```


#### Apple Pay Merchant ID

**Objective-C**

```objective-c
-(NSString *)applePayMerchantID
{
    return @"merchant.com.example";
}
```

**Swift**

```swift
var applePayMerchantID: String
{
	return "merchant.com.example"
}
```


#### Define acceptable card types

**Objective-C**

```objective-c
- (NSArray<CardType *> *)allowedCadTypes {
    CardType* credit = [[CardType alloc]initWithCardType:Credit];
    CardType* debit = [[CardType alloc]initWithCardType:Debit];
    return @[credit,debit];
}
```

**Swift**

```swift
var allowedCadTypes: [CardType]? {
	return [CardType(cardType: .Debit), CardType(cardType: .Credit)]
}
```

<a name="session_delegate"></a>

## Session Delegate

**SessionDelegate** is an interface which you may want to implement to receive payment/authorization/card saving status updates and update your user interface accordingly when payment window closes.

Below are listed down all available callbacks:

<a name="payment_success_callback"></a>

### Payment Success Callback

Notifies the receiver that payment has succeed. Can be called only in **purchase** mode.

#### Declaration

*Objective-C:*

```objective-c
- (void)paymentSucceed:(Charge * _Nonnull)charge onSession:(id <SessionProtocol> _Nonnull)session;
```

*Swift:*

```swift
func paymentSucceed(_ charge: Charge, on session: SessionProtocol)
```

#### Arguments

**charge**: Successful charge object.

**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

<a name="payment_failure_callback"></a>

### Payment Failure Callback

Notifies the receiver that payment has failed. Can be called only in **purchase** mode.

#### Declaration

*Objective-C:*

```objective-c
- (void)paymentFailedWithCharge:(Charge * _Nullable)charge error:(TapSDKError * _Nullable)error onSession:(id <SessionProtocol> _Nonnull)session;
```

*Swift:*

```swift
func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol)
```

#### Arguments

**charge**: Charge object that has failed (if reached the stage of charging).

**error**: An error that has occured (if any).

**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

You may assume that at least one, `charge` or `error` is not `nil`.

<a name="authorization_success_callback"></a>

### Authorization Success Callback

Notifies the receiver that authorization has succeed. Can be called only in **authorization** mode.

#### Declaration

*Objective-C:*

```objective-c
- (void)authorizationSucceed:(Authorize * _Nonnull)authorize onSession:(id <SessionProtocol> _Nonnull)session;
```

*Swift:*

```swift
func authorizationSucceed(_ authorize: Authorize, on session: SessionProtocol)
```

#### Arguments

**authorize**: Successful authorize object.

**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

<a name="authorization_failure_callback"></a>

### Authorization Failure Callback

Notifies the receiver that authorization has failed. Can be called only in **authorization** mode.

#### Declaration

*Objective-C:*

```objective-c
- (void)authorizationFailedWithAuthorize:(Authorize * _Nullable)authorize error:(TapSDKError * _Nullable)error onSession:(id <SessionProtocol> _Nonnull)session;
```

*Swift:*

```swift
func authorizationFailed(with authorize: Authorize?, error: TapSDKError?, on session: SessionProtocol)
```

#### Arguments

**authorize**: Authorize object that has failed (if reached the stage of authorization).

**error**: An error that has occured (if any).

**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

You may assume that at least one, `authorize` or `error` is not `nil`.

<a name="card_saving_success_callback"></a>

### Card Saving Success Callback

Notifies the receiver that the customer has successfully saved the card. Can be called only in **card saving** mode.

#### Declaration

*Objective-C:*

```objective-c
- (void)cardSaved:(CardVerification * _Nonnull)cardVerification onSession:(id <SessionProtocol> _Nonnull)session;
```

*Swift:*

```swift
func cardSaved(_ cardVerification: CardVerification, on session: SessionProtocol)
```

#### Arguments

**cardVerification**: Card verification object with the details.

**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

<a name="card_saving_failure_callback"></a>

### Card Saving Failure Callback

Notifies the receiver that the customer failed to save the card. Can be called only in **card saving** mode.

#### Declaration

*Objective-C*:

```objective-c
- (void)cardSavingFailedWithCardVerification:(CardVerification * _Nullable)cardVerification error:(TapSDKError * _Nullable)error onSession:(id <SessionProtocol> _Nonnull)session;
```

*Swift:*

```swift
func cardSavingFailed(with cardVerification: CardVerification?, error: TapSDKError?, on session: SessionProtocol)
```

#### Arguments

**cardVerification**: Card verification object with the details (if reached the stage of card saving).

**error**: Error that has occured. If `nil`, please refer to the `cardVerification` object for error details.

**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

<a name="card_tokenization_success_callback"></a>

### Card Tokenization Success Callback

Notifies the receiver that card token has successfully created. Can be called only in **card tokenization** mode.

#### Declaration

*Objective-C*:

```objective-c
- (void)cardTokenized:(Token * _Nonnull)token onSession:(id <SessionProtocol> _Nonnull)session customerRequestedToSaveTheCard:(BOOL)saveCard;
```

*Swift*:

```swift
func cardTokenized(_ token: Token, on session: SessionProtocol, customerRequestedToSaveTheCard saveCard: Bool)
```

#### Arguments

**token**: Token of the card provided by your customer.
**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.
**saveCard**: Boolean flag which determines whether the customer wants to save the card. Actual card saving process is not happening.

<a name="card_tokenization_failure_callback"></a>

### Card Tokenization Failure Callback

Notifies the receiver that card token has failed to be created. Can be called only in **card tokenization** mode.

#### Declaration

*Objective-C*:

```objective-c
- (void)cardTokenizationFailedWithError:(TapSDKError * _Nonnull)error onSession:(id <SessionProtocol> _Nonnull)session;
```

*Swift*:

```swift
func cardTokenizationFailed(with error: TapSDKError, on session: SessionProtocol)
```

#### Arguments

**error**: Error that has occured.
**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

<a name="session_is_starting_callback"></a>

### Session Is Starting Callback

Notifies the receiver that session is about to start, but hasn't yet shown the SDK UI. You might want to use this method if you are not using `PayButton` in your application and want to show a loader before SDK UI appears on the screen. Will be called in all modes.

#### Declaration

*Objective-C:*

```objective-c
- (void)sessionIsStarting:(id <SessionProtocol> _Nonnull)session;
```

*Swift:*

```swift
func sessionIsStarting(_ session: SessionProtocol)
```

#### Arguments

**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

<a name="session_has_started_callback"></a>

### Session Has Started Callback

Notifies the receiver that session has successfully started and shown the SDK UI on the screen. You might want to use this method if you are not using `PayButton` in your application and want to hide a loader after SDK UI has appeared on the screen. Will be called in all modes.

#### Declaration

*Objective-C:*

```objective-c
- (void)sessionHasStarted:(id <SessionProtocol> _Nonnull)session;
```

*Swift:*

```swift
func sessionHasStarted(_ session: SessionProtocol)
```

#### Arguments

**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

<a name="session_has_failed_to_start_callback"></a>

### Session Has Failed to Start Callback

Notifies the receiver that session has failed to start and will not show the SDK UI on the screen. You might want to use this method if you are not using `PayButton` in your application and want to hide a loader because the session has failed. For the actual failure cause please implement other methods from this protocol and listen to the callbacks. Will be called in all modes.

#### Declaration

*Objective-C:*

```objective-c
- (void)sessionHasFailedToStart:(id <SessionProtocol> _Nonnull)session;
```

*Swift:*

```swift
func sessionHasFailedToStart(_ session: SessionProtocol)
```

#### Arguments

**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

<a name="session_cancel_callback"></a>

### Session Cancel Callback

Notifies the receiver that payment/authorization was cancelled by user. Will be called in all modes.

#### Declaration

*Objective-C:*

```objective-c
- (void)sessionCancelled:(id <SessionProtocol> _Nonnull)session;
```

*Swift:*

```swift
func sessionCancelled(_ session: SessionProtocol)
```

#### Arguments

**session**: Session object. It can be either a PayButton or an instance of Session if you are not using PayButton.

<a name="session_appearance"></a>

## Session Appearance

You might want to implement `SessionAppearance` protocol if you need some UI customization to match your user interface and provide great user experience.

Please refer to `SessionAppearance` class documentation to see what kind of customization is currently available.

<a name="sample"></a>

# Sample

Sample application integration is available in [Example][2] folder.

-----

# Documentation

Documentation is available at [github-pages][3].<br>
Also documented sources are attached to the library.

[1]:https://www.tap.company/developers/
[2]:Example
[3]:https://tap-payments.github.io/goSellSDK-iOS/
