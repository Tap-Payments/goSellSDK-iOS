//
//  SavedCardCell.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	goSellSDK.SavedCard
import class	UIKit.UILabel.UILabel
import class	UIKit.UITableViewCell.UITableViewCell

internal final class SavedCardCell: UITableViewCell {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal func fill(with card: SavedCard) {
		
		self.cardNumberLabel?.text		= self.generateCardNumberString(from: card)
		self.expirationDateLabel?.text	= self.generateExpirationDateString(from: card)
		self.cardholderNameLabel?.text	= card.cardholderName
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	@IBOutlet private weak var cardNumberLabel: UILabel?
	
	@IBOutlet private weak var expirationDateLabel: UILabel?
	
	@IBOutlet private weak var cardholderNameLabel: UILabel?
	
	// MARK: Methods
	
	private func generateCardNumberString(from card: SavedCard) -> String {
		
		if card.brand == .americanExpress {
			
			return card.firstSixDigits.prefix(4) + " " + card.firstSixDigits.suffix(2) + "•••• •" + card.lastFourDigits
		}
		else {
			
			return card.firstSixDigits.prefix(4) + " " + card.firstSixDigits.suffix(2) + "•• •••• " + card.lastFourDigits
		}
	}
	
	private func generateExpirationDateString(from card: SavedCard) -> String {
		
		return String(format: "%02d/%02d", card.expirationMonth, card.expirationYear % 100)
	}
}
