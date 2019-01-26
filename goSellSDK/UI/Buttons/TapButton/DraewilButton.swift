//
//  DraewilButton.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal final class DraewilButton: TapButton {
	
	override var themeStyle: TapButtonStyle {
		
		get {
			
			return _themeStyle
		}
		set {
			
			self.updateStateUI(animated: true)
		}
	}
	
	internal override func setup() {
		
		super.setup()
		self.tap_cornerRadius = 5.0
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private lazy var _themeStyle: TapButtonStyle = {
		
		return Theme.current.buttonStyles.first(where: { $0.type == .draewilSave })!
	}()
}
