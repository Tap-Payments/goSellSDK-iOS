//
//  UIView+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import struct	TapAdditionsKitV2.TypeAlias
import enum 	UIKit.UIView.UISemanticContentAttribute
import class	UIKit.UIView.UIView

internal extension UIView {
	
	// MARK: - Internal -	
	// MARK: Methods
	
	func tap_updateLayoutDirectionIfRequired() {
		
		if #available(iOS 9.0, *) {
			
			let requiredContentAttribute: UISemanticContentAttribute = LocalizationManager.shared.layoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight
			if requiredContentAttribute != self.semanticContentAttribute {
				
				self.tap_applySemanticContentAttribute(requiredContentAttribute)
			}
		}
	}
}

// MARK: - Safe area

internal extension UIView {
    
    /// Re-pins `subview`'s given horizontal edges from this view's edges to this view's safe area.
    ///
    /// The SDK's storyboards pin content to the plain view edges. On a large landscape screen (an unfolded
    /// foldable iPhone, where the status bar and camera sit on a side edge) that put content under them.
    /// Where there are no side insets (portrait iPhones, iPads) the layout is unchanged.
    ///
    /// - Parameters:
    ///   - subview: Direct subview whose edge constraints to this view should move to the safe area.
    ///   - edges: `.leading` and/or `.trailing`.
    func tap_pinToHorizontalSafeArea(_ subview: UIView, edges: [NSLayoutConstraint.Attribute] = [.leading, .trailing]) {
        
        let edgeConstraints = self.constraints.filter { constraint in
            
            let pinsSubviewToSelf = (constraint.firstItem === subview && constraint.secondItem === self) || (constraint.firstItem === self && constraint.secondItem === subview)
            return pinsSubviewToSelf && edges.contains(constraint.firstAttribute) && constraint.firstAttribute == constraint.secondAttribute && constraint.relation == .equal
        }
        
        var safeAreaConstraints: [NSLayoutConstraint] = []
        
        for constraint in edgeConstraints {
            
            // `first.edge = second.edge + constant`, so the offset flips when this view is the first item.
            let offset = constraint.firstItem === subview ? constraint.constant : -constraint.constant
            
            let safeAreaConstraint: NSLayoutConstraint
            
            switch constraint.firstAttribute {
                
            case .leading:
                
                safeAreaConstraint = subview.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: offset)
                
            case .trailing:
                
                safeAreaConstraint = subview.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: offset)
                
            default:
                
                continue
            }
            
            safeAreaConstraint.priority = constraint.priority
            safeAreaConstraints.append(safeAreaConstraint)
        }
        
        NSLayoutConstraint.deactivate(edgeConstraints)
        NSLayoutConstraint.activate(safeAreaConstraints)
    }
}
