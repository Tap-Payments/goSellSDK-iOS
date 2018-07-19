//
//  HeaderNavigatedViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import struct   CoreGraphics.CGGeometry.CGSize
import func     TapAdditionsKit.clamp
import struct   TapAdditionsKit.TypeAlias
import class    UIKit.UIColor.UIColor
import class    UIKit.UIView.UIView

/// Base view controller for all view controllers that have navigation controller and a navigation bar with `TapNavigationView` inside it.
internal class HeaderNavigatedViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    @IBOutlet internal var headerNavigationView: TapNavigationView? {
        
        didSet {
            
            if let nonnullHeaderView = self.headerNavigationView {
                
                self.headerNavigationViewLoaded(nonnullHeaderView)
            }
        }
    }
    
    internal var interactivePopTransition: UINavigationControllerPopInteractionController?
    
    // MARK: Methods
    
    internal func headerNavigationViewLoaded(_ headerView: TapNavigationView) {
        
        headerView.delegate = self
        self.setupHeaderShadow(for: headerView)
    }
    
    internal func updateHeaderShadowOpacity(with contentOverlapping: CGFloat) {
        
        guard let nonnullHeaderView = self.headerNavigationView else { return }
        
        let opacity = clamp(value: 2.0 * contentOverlapping / nonnullHeaderView.bounds.height, low: 0.0, high: 1.0)
        nonnullHeaderView.layer.shadowOpacity = Float(opacity)
    }
    
    internal func requestToPop(_ decision: @escaping TypeAlias.BooleanClosure) {
        
        decision(true)
    }
    
    internal func pop() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func setupHeaderShadow(for header: UIView) {
        
        header.layer.shadowOpacity = 0.0
        header.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        header.layer.shadowRadius = 1.0
        header.layer.shadowColor = UIColor.lightGray.cgColor
    }
}

// MARK: - TapNavigationViewDelegate
extension HeaderNavigatedViewController: TapNavigationViewDelegate {
    
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
