//
//  ErrorReporter.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	TapErrorReportingV2.ErrorReporter
import protocol	TapErrorReportingV2.ErrorReporting

internal final class Reporter {

	// MARK: - Internal -
	// MARK: Properties
	
	internal static var language: String {
		
		get {
			
			return ErrorReporter.shared.language
		}
		set {
			
			ErrorReporter.shared.language = newValue
		}
	}
	
	internal static var canReport: Bool {
		
		return ErrorReporter.shared.canReport
	}
	
	// MARK: Methods
	
	internal static func report(_ error: TapSDKError) {
		
		ErrorReporter.shared.report(error, in: Constants.product, productVersion: GoSellSDK.sdkVersion, alertOrientationHandler: InterfaceOrientationManager.shared)
	}
	
	// MARK: - Private -
	
	private struct	Constants {
		
		fileprivate static let product	= "goSellSDK"
		
		//@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
	}
	
	// MARK: Methods
	
	//@available(*, unavailable) private init() { fatalError("This class cannot be instantiated.") }
}
