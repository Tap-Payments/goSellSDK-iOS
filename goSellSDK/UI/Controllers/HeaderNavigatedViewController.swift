//
//  HeaderNavigatedViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

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
    }
    
    internal func backButtonClicked() { }
    
    internal func pop() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - TapNavigationViewDelegate
extension HeaderNavigatedViewController: TapNavigationViewDelegate {
    
    internal func navigationViewBackButtonClicked(_ navigationView: TapNavigationView) {
        
        self.backButtonClicked()
        self.pop()
    }
}

// MARK: - InteractivePopViewController
extension HeaderNavigatedViewController: InteractivePopViewController {}
