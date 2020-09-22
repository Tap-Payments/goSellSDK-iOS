//
//  HeaderNavigatedViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import func     TapAdditionsKitV2.tap_clamp
import struct   TapAdditionsKitV2.TypeAlias
import class    UIKit.UIColor.UIColor
import class    UIKit.UIView.UIView

/// Base view controller for all view controllers that have navigation controller and a navigation bar with `TapNavigationView` inside it.
internal class HeaderNavigatedViewController: BaseViewController, NavigationContentViewController {
    
    // MARK: - Internal -
    // MARK: Properties
	
    internal var headerHasShadowInitially: Bool { return true }
	
	internal var animatesHeaderBackgroundOpacity: Bool { return true }
    
    @IBOutlet internal var headerNavigationView: TapNavigationView? {
        
        didSet {
            
            if let nonnullHeaderView = self.headerNavigationView {
                
                self.headerNavigationViewLoaded(nonnullHeaderView)
            }
        }
    }
	
    internal var interactivePopTransition: UINavigationControllerPopInteractionController?
	
	internal var contentTopOffset: CGFloat {
		
		if let headerView = self.headerNavigationView {
			
			let headerFrame = headerView.convert(headerView.bounds, to: self.view.window)
			return headerFrame.origin.y + headerFrame.size.height
		}
		else {
			
			return self.view.convert(self.view.bounds, to: self.view.window).origin.y + TapNavigationView.preferredHeight
		}
	}
	
	internal var headerStyle: NavigationBarStyle {
		
		return Theme.current.navigationBarStyle
	}
	
    // MARK: Methods
    
    internal func headerNavigationViewLoaded(_ headerView: TapNavigationView) {
		
		if let selfAsHeaderDataSource = self as? TapNavigationView.DataSource {
			
			headerView.dataSource = selfAsHeaderDataSource
		}
		
        headerView.delegate = self
		
        self.setupHeaderShadow(for: headerView)
    }
	
	internal override func localizationChanged() {
		
		super.localizationChanged()
		self.headerNavigationView?.setStyle(self.headerStyle)
		self.headerNavigationView?.updateContentAndLayout(animated: true)
	}
	
	internal override func themeChanged() {
		
		super.themeChanged()
		self.headerNavigationView?.setStyle(self.headerStyle)
        if let nonnullHeaderView = self.headerNavigationView {
            
            self.headerNavigationViewLoaded(nonnullHeaderView)
        }
	}
	
    internal func updateHeaderShadowOpacity(with contentOverlapping: CGFloat) {
        
        guard let nonnullHeaderView = self.headerNavigationView else { return }
		
		var opacity: CGFloat
		if self.headerHasShadowInitially {
			
			opacity = 1.0
		}
		else {
			
			opacity = tap_clamp(value: 2.0 * contentOverlapping / nonnullHeaderView.bounds.height, low: 0.0, high: 1.0)
		}
		
        nonnullHeaderView.layer.shadowOpacity = Float(opacity)
		nonnullHeaderView.backgroundOpacity = self.animatesHeaderBackgroundOpacity ? opacity : 1.0
    }
    
    internal func requestToPop(_ decision: @escaping TypeAlias.BooleanClosure) {
        
        decision(true)
    }
    
    internal func pop() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
	
	internal func close() {}
    
    // MARK: - Private -
    // MARK: Methods
    
    private func setupHeaderShadow(for header: UIView) {
        
        header.layer.shadowOpacity = self.headerHasShadowInitially ? 1.0 : 0.0
        header.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        header.layer.shadowRadius = 1.0
        header.layer.shadowColor = UIColor.lightGray.cgColor
    }
}

// MARK: - TapNavigationView.Delegate
extension HeaderNavigatedViewController: TapNavigationView.Delegate {
	
	internal func navigationViewCloseButtonClicked(_ navigationView: TapNavigationView) {
		
		self.close()
	}
    
    internal func navigationViewBackButtonClicked(_ navigationView: TapNavigationView) {
        
        self.requestToPop { [weak self] (willPop) in
            
            if willPop {
                
                self?.pop()
            }
        }
    }
}

// MARK: - InteractivePopViewController
extension HeaderNavigatedViewController: InteractivePopViewController {}
