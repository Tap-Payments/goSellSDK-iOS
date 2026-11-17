//
//  Image.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import class	UIKit.UIImage.UIImage

/// Enum representing image with the source to load from.
///
/// - named: Local image with `name` from `bundle`
/// - remote: Remote image with source url.
internal enum Image: Equatable {
	
	case named(String, Bundle)
	case ready(UIImage)
	case remote(URL)
}
