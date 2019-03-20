//
//  AddressInputViewController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    UIKit.UIScrollView.UIScrollView
import protocol UIKit.UIScrollView.UIScrollViewDelegate
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView

/// View controller to handle address input.
internal class AddressInputViewController: HeaderNavigatedViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal override var headerHasShadowInitially: Bool {
        
        return false
    }
    
    // MARK: Methods
    
    internal func setValidator(_ validator: CardAddressValidator) {
        
        self.addressFieldsDataManager = AddressFieldsDataManager(validator: validator, loadingListener: self)
        self.addressFieldsDataManager?.reloadClosure = {
            
            self.addressFieldsTableView?.reloadData()
        }
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let countrySelectionController = segue.destination as? CountrySelectionViewController {
            
            self.addressFieldsDataManager?.setupCountriesSelectionController(countrySelectionController)
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var addressFieldsTableView: UITableView?
    
    internal private(set) var addressFieldsDataManager: AddressFieldsDataManager?
    
    private weak var loader: LoadingViewController?
}

// MARK: - AddressFieldsDataManagerLoadingListener
extension AddressInputViewController: AddressFieldsDataManagerLoadingListener {
    
    internal func addressFieldsDataManagerDidStartLoadingFormats() {
		
        self.loader = Process.shared.showLoadingController(false)
    }
    
    internal func addressFieldsDataManagerDidStopLoadingFormats() {
        
        self.loader?.hide(animated: true, async: true, fromDestroyInstance: false)
    }
}

// MARK: - UIScrollViewDelegate
extension AddressInputViewController: UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView == self.addressFieldsTableView else { return }
        self.updateHeaderShadowOpacity(with: scrollView.contentOffset.y)
    }
}

// MARK: - TapNavigationView.DataSource
extension AddressInputViewController: TapNavigationView.DataSource {
	
	internal func navigationViewCanGoBack(_ navigationView: TapNavigationView) -> Bool {
		
		return (self.navigationController?.viewControllers.count ?? 0) > 1
	}
	
	internal func navigationViewIconPlaceholder(for navigationView: TapNavigationView) -> Image? {
		
		return nil
	}
	
	internal func navigationViewIcon(for navigationView: TapNavigationView) -> Image? {
		
		return nil
	}
	
	internal func navigationViewTitle(for navigationView: TapNavigationView) -> String? {
		
		return "Address"
	}
}
