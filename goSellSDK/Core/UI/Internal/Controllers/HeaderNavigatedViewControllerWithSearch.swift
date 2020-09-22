//
//  HeaderNavigatedControllerWithSearch.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import func     TapAdditionsKitV2.tap_clamp
import protocol TapSearchViewV2.TapSearchUpdating
import class    TapSearchViewV2.TapSearchView
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIColor.UIColor
import struct   UIKit.UIGeometry.UIEdgeInsets
import class    UIKit.UIScrollView.UIScrollView
import protocol UIKit.UIScrollView.UIScrollViewDelegate
import class    UIKit.UISearchBar.UISearchBar
import protocol UIKit.UISearchBar.UISearchBarDelegate
import class    UIKit.UITableView.UITableView

internal class HeaderNavigatedViewControllerWithSearch: HeaderNavigatedViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal override var headerHasShadowInitially: Bool {
        
        return false
    }
    
    @IBOutlet internal private(set) weak var tableView: UITableView? {
        
        didSet {
            
            if let nonnullTableView = self.tableView {
                
                self.tableViewLoaded(nonnullTableView)
                
                if let nonnullSearchView = self.searchView {
                    
                    self.bothTableViewAndSearchViewLoaded(nonnullTableView, searchView: nonnullSearchView)
                }
            }
        }
    }
    
    // MARK: Methods
    
    internal override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.updateTableViewContentInset()
    }
    
    internal func tableViewLoaded(_ aTableView: UITableView) {
        
        if #available(iOS 11.0, *) {
            
            aTableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    internal func searchViewLoaded(_ aSearchView: TapSearchView) {
        
        aSearchView.delegate = self
        
        aSearchView.layer.shadowOpacity = 0.0
        aSearchView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        aSearchView.layer.shadowRadius = 1.0
        aSearchView.layer.shadowColor = Constants.searchViewShadowColor?.cgColor
		
		self.searchViewHeightConstraint?.constant = Constants.headerViewAndSearchBarOverlapping + Constants.shadowHeight
		aSearchView.tap_layout()
    }
    
    internal func bothTableViewAndSearchViewLoaded(_ aTableView: UITableView, searchView aSearchView: TapSearchView) {
        
        self.updateTableViewContentInset()
        aTableView.contentOffset = .zero
    }
    
    internal func searchViewTextChanged(_ text: String) {}
	
	internal override func localizationChanged() {
		
		super.localizationChanged()
		self.searchView?.searchField.setLocalizedText(for: .placeholder, key: .search_bar_placeholder)
	}
	
	internal override func themeChanged() {
		
		super.themeChanged()
		self.searchView?.setStyle(Theme.current.searchBarStyle)
	}
	
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let headerViewAndSearchBarOverlapping: CGFloat = 4.0
        fileprivate static let shadowHeight: CGFloat = 2.0
		fileprivate static let searchViewShadowColor = UIColor(tap_hex: "B5B5B5A8")
        
        //@available(*, unavailable) private init() { }
    }
	
	private enum SearchViewState {
		
		case active
		case collapsed
	}
	
    // MARK: Properties
    
    @IBOutlet internal weak var searchView: TapSearchView? {
        
        didSet {
            
            if let nonnullSearchView = self.searchView {
                
                self.searchViewLoaded(nonnullSearchView)
                
                if let nonnullTableView = self.tableView {
                    
                    self.bothTableViewAndSearchViewLoaded(nonnullTableView, searchView: nonnullSearchView)
                }
            }
        }
    }
    
    @IBOutlet private weak var searchViewHeightConstraint: NSLayoutConstraint?
	
	private var searchViewState: SearchViewState = .collapsed {
		
		didSet {
			
			self.updateTableViewContentInset()
		}
	}
	
	private var canSearchViewBeCollapsed: Bool {
		
		guard let sView = self.searchView else { return true }
		return (sView.searchField.text?.tap_length ?? 0) == 0
	}
	
    // MARK: Methods
    
    private func updateTableViewContentInset() {
        
        guard let nonnullTableView = self.tableView else { return }
        guard let searchHeight = self.searchView?.intrinsicContentSize.height else { return }
		
		var topInset: CGFloat
		
		switch self.searchViewState {
			
		case .active:		topInset = searchHeight - Constants.headerViewAndSearchBarOverlapping
		case .collapsed:	topInset = Constants.shadowHeight
			
		}
		
        let desiredInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
        if nonnullTableView.contentInset != desiredInset {
            
            nonnullTableView.contentInset = desiredInset
        }
    }
    
    private func endSearching() {
        
        self.searchView?.endEditing(true)
    }
    
    private func updateSearchViewShadowOpacity(for searchViewRelativeSize: CGFloat) {
        
        let desiredOpacity = 1.0 - 2.0 * searchViewRelativeSize
        let shadowOpacity = searchViewRelativeSize > 0.5 ? 0.0 : desiredOpacity
        self.searchView?.layer.shadowOpacity = Float(shadowOpacity)
    }
}

// MARK: - UIScrollViewDelegate
extension HeaderNavigatedViewControllerWithSearch: UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		if let searchViewHeightAndScale = self.visibleSearchViewHeightAndScale(basedOn: scrollView) {
			
			self.searchViewHeightConstraint?.constant = searchViewHeightAndScale.0
			self.updateSearchViewShadowOpacity(for: searchViewHeightAndScale.1)
		}
    }
	
	internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		
		if let searchViewHeightAndScale = self.visibleSearchViewHeightAndScale(basedOn: scrollView) {
			
			let collapsing = scrollView.panGestureRecognizer.velocity(in: scrollView).y <= 0.0
			
			self.searchViewState = searchViewHeightAndScale.1 < 1.0 && collapsing && self.canSearchViewBeCollapsed ? .collapsed : .active
		}
	}
	
	private func visibleSearchViewHeightAndScale(basedOn scrollView: UIScrollView) -> (CGFloat, CGFloat)? {
	
		guard scrollView === self.tableView else { return nil }
		guard let height = self.searchView?.intrinsicContentSize.height else { return nil }
		
		let minimalVisiblePart = Constants.headerViewAndSearchBarOverlapping + Constants.shadowHeight
		
		let emptySpace = self.canSearchViewBeCollapsed ? Constants.headerViewAndSearchBarOverlapping - scrollView.contentOffset.y : height
		let desiredSearchViewHeight: CGFloat = tap_clamp(value: emptySpace, low: minimalVisiblePart, high: height)
		
		let scaleY = desiredSearchViewHeight / height
		
		return (desiredSearchViewHeight, scaleY)
		
	}
}

// MARK: - TapSearchUpdating
extension HeaderNavigatedViewControllerWithSearch: TapSearchUpdating {
    
    internal func updateSearchResults(with searchText: String) {
        
        self.searchViewTextChanged(searchText)
    }
}
