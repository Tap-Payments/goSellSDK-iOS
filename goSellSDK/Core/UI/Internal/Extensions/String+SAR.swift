//
//  String+SAR.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

extension String {
    func getAttributedTitleForSAR() -> NSAttributedString? {
        let amountText = self ?? ""
        if let regex = try? NSRegularExpression(pattern: "SAR|SR|sar|sr", options: .caseInsensitive) {
            let range = NSRange(location: 0, length: amountText.utf16.count)
            let matches = regex.matches(in: amountText, options: [], range: range)
            
            if !matches.isEmpty {
                // Create the final attributed string
                let attributedString = NSMutableAttributedString(string: amountText)
                
                // Then apply special style to each SR/SAR match
                for match in matches {
                    attributedString.addAttributes(
                        [.font: UIFont(name: "sarRegular", size: UIFont.buttonFontSize)],
                        range: match.range
                    )
                }
                return attributedString
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
