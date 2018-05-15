//
//  HeaderNavigatedControllerWithSearch.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGAffineTransform.CGAffineTransform
import struct CoreGraphics.CGBase.CGFloat
import struct CoreGraphics.CGGeometry.CGPoint
import struct CoreGraphics.CGGeometry.CGSize
import class UIKit.UIColor.UIColor
import struct UIKit.UIGeometry.UIEdgeInsets
import class UIKit.UIScrollView.UIScrollView
import protocol UIKit.UIScrollView.UIScrollViewDelegate
import class UIKit.UISearchBar.UISearchBar
import protocol UIKit.UISearchBar.UISearchBarDelegate
import class UIKit.UITableView.UITableView

internal class HeaderNavigatedViewControllerWithSearch: HeaderNavigatedViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.updateTableViewContentInset()
    }
    
    internal override func headerNavigationViewLoaded(_ headerView: TapNavigationView) {
        
        super.headerNavigationViewLoaded(headerView)
        
        headerView.layer.shadowOpacity = 0.0
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        headerView.layer.shadowRadius = 1.0
        headerView.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    internal func tableViewLoaded(_ aTableView: UITableView) {
        
        if #available(iOS 11.0, *) {
            
            aTableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    internal func searchBarLoaded(_ aSearchBar: UISearchBar) {
        
        aSearchBar.delegate = self
        aSearchBar.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        aSearchBar.transform = CGAffineTransform(translationX: 0.0, y: -0.5 * self.searchBarHeight)
        aSearchBar.backgroundImage = .named("transparent_pixel", in: .goSellSDKResources)
        aSearchBar.placeholder = "Search"
    }
    
    internal func bothTableViewAndSearchBarLoaded(_ aTableView: UITableView, aSearchBar: UISearchBar) {
        
        self.updateTableViewContentInset()
        aTableView.contentOffset = .zero
    }
    
    internal func searchBarTextChanged(_ text: String) {}
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var searchBar: UISearchBar? {
        
        didSet {
            
            if let nonnullSearchBar = self.searchBar {
                
                self.searchBarLoaded(nonnullSearchBar)
                
                if let nonnullTableView = self.tableView {
                    
                    self.bothTableViewAndSearchBarLoaded(nonnullTableView, aSearchBar: nonnullSearchBar)
                }
            }
        }
    }
    @IBOutlet internal private(set) weak var tableView: UITableView? {
        
        didSet {
            
            if let nonnullTableView = self.tableView {
                
                self.tableViewLoaded(nonnullTableView)
                
                if let nonnullSearchBar = self.searchBar {
                    
                    self.bothTableViewAndSearchBarLoaded(nonnullTableView, aSearchBar: nonnullSearchBar)
                }
            }
        }
    }
    
    private var searchBarHeight: CGFloat {
        
        return self.searchBar?.bounds.height ?? 0.0
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func updateTableViewContentInset() {
        
        guard let nonnullTableView = self.tableView else { return }
        
        let desiredInset = UIEdgeInsets(top: self.searchBarHeight, left: 0.0, bottom: 0.0, right: 0.0)
        if nonnullTableView.contentInset != desiredInset {
            
            nonnullTableView.contentInset = desiredInset
        }
    }
    
    private func endSearching() {
        
        self.searchBar?.endEditing(true)
    }
    
    private func updateHeaderViewShadowOpacityAndSearchBarAlpha(for searchBarScale: CGFloat) {
        
        let searchBarOpacity = searchBarScale > 0.5 ? 1.0 : 2.0 * searchBarScale
        self.headerNavigationView?.layer.shadowOpacity = Float(1.0 - searchBarOpacity)
        self.searchBar?.alpha = searchBarOpacity
    }
}

// MARK: - UIScrollViewDelegate
extension HeaderNavigatedViewControllerWithSearch: UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView === self.tableView else { return }
        
        let height = self.searchBarHeight
        let visibleSearchBarPart = height - max(0.0, min(height, scrollView.contentInset.top + scrollView.contentOffset.y))
        
        let scaleY = visibleSearchBarPart / height
        if scaleY < 1.0 {
            
            self.endSearching()
        }
        
        self.updateHeaderViewShadowOpacityAndSearchBarAlpha(for: scaleY)
        
        let scaleTransform = CGAffineTransform(scaleX: 1.0, y: scaleY)
        let translateTransform = CGAffineTransform(translationX: 0.0, y: -0.5 * height)
        
        self.searchBar?.transform = scaleTransform.concatenating(translateTransform)
    }
}

// MARK: - UISearchBarDelegate
extension HeaderNavigatedViewControllerWithSearch: UISearchBarDelegate {
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchBarTextChanged(searchText)
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.endSearching()
    }
}
