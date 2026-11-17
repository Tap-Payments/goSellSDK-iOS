// swift-tools-version:5.9
import PackageDescription

// Swift Package Manager ships the Core part of goSellSDK. The optional ErrorReporting
// add-on (TapErrorReportingV2) is still available through CocoaPods only.
let package = Package(
    name: "goSellSDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "goSellSDK", targets: ["goSellSDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/Tap-Payments/EditableTextInsetsTextFieldV2.git", from: "0.0.4"),
        .package(url: "https://github.com/Tap-Payments/TapAdditionsKitV2.git", from: "0.0.22"),
        .package(url: "https://github.com/Tap-Payments/TapApplicationV2.git", from: "0.0.7"),
        .package(url: "https://github.com/Tap-Payments/TapBundleLocalizationV2.git", from: "0.0.4"),
        .package(url: "https://github.com/Tap-Payments/TapCardVlidatorKit-iOS.git", from: "1.0.27"),
        .package(url: "https://github.com/Tap-Payments/TapEditableView-iOSV2.git", from: "1.0.3"),
        .package(url: "https://github.com/Tap-Payments/TapFontsKitV2.git", from: "0.0.6"),
        .package(url: "https://github.com/Tap-Payments/TapGLKitV2.git", from: "0.0.4"),
        .package(url: "https://github.com/Tap-Payments/TapKeychainV2-iOS.git", from: "1.0.4"),
        .package(url: "https://github.com/Tap-Payments/TapNetworkManagerV2.git", from: "0.0.7"),
        .package(url: "https://github.com/Tap-Payments/TapNibViewV2.git", from: "0.0.4"),
        .package(url: "https://github.com/Tap-Payments/TapResponderChainInputViewV2.git", from: "0.0.6"),
        .package(url: "https://github.com/Tap-Payments/TapSearchViewV2.git", from: "0.0.6"),
        .package(url: "https://github.com/Tap-Payments/TapSwiftFixesV2.git", from: "1.0.6"),
        .package(url: "https://github.com/Tap-Payments/TapVisualEffectViewV2.git", from: "0.0.5")
    ],
    targets: [
        .target(
            name: "goSellSDK",
            dependencies: [
                .product(name: "EditableTextInsetsTextFieldV2", package: "EditableTextInsetsTextFieldV2"),
                .product(name: "TapAdditionsKitV2", package: "TapAdditionsKitV2"),
                .product(name: "TapApplicationV2", package: "TapApplicationV2"),
                .product(name: "TapBundleLocalizationV2", package: "TapBundleLocalizationV2"),
                .product(name: "TapCardVlidatorKit-iOS", package: "TapCardVlidatorKit-iOS"),
                .product(name: "TapEditableViewV2", package: "TapEditableView-iOSV2"),
                .product(name: "TapFontsKitV2", package: "TapFontsKitV2"),
                .product(name: "TapGLKitV2", package: "TapGLKitV2"),
                .product(name: "TapKeychainV2", package: "TapKeychainV2-iOS"),
                .product(name: "TapNetworkManagerV2", package: "TapNetworkManagerV2"),
                .product(name: "TapNibViewV2", package: "TapNibViewV2"),
                .product(name: "TapResponderChainInputViewV2", package: "TapResponderChainInputViewV2"),
                .product(name: "TapSearchViewV2", package: "TapSearchViewV2"),
                .product(name: "TapSwiftFixesV2", package: "TapSwiftFixesV2"),
                .product(name: "TapVisualEffectViewV2", package: "TapVisualEffectViewV2")
            ],
            path: "goSellSDK/Core",
            resources: [.process("UI/Internal/Resources")]
        )
    ],
    swiftLanguageVersions: [.v5]
)
