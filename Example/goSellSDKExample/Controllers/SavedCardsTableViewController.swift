//
//  SavedCardsTableViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSIndexPath.IndexPath
import class	goSellSDK.APISession
import class	goSellSDK.SavedCard
import class	UIKit.UIActivityIndicatorView
import class	UIKit.UITableView.UITableView
import class	UIKit.UITableViewCell.UITableViewCell

internal final class SavedCardsTableViewController: ModalNavigationTableViewController {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var customerIdentifier: String?
	
	// MARK: Methods
	
	internal override func viewDidLoad() {
		
		super.viewDidLoad()
		
		self.title = "Saved Cards"
		self.loadCards()
	}
	
	internal override func doneButtonClicked() {}
	
	internal override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.cards.count
	}
	
	internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedCardCell.tap_className) as? SavedCardCell else {
			
			fatalError("Failed to load cell from the storyboard.")
		}
		
		cell.fill(with: self.cards[indexPath.row])
		
		return cell
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private var cards: [SavedCard] = [] {
		
		didSet {
			
			self.tableView.reloadData()
		}
	}
	
	private var loader: UIActivityIndicatorView?
	
	// MARK: Methods
	
	private func loadCards() {
		
		guard let nonnullCustomerIdentifier = self.customerIdentifier else { return }
		
		self.showLoader()
		
		APISession.shared.retrieveAllCards(of: nonnullCustomerIdentifier) { [weak self] (cards, error) in
			
			self?.hideLoader()
			
			self?.cards = cards ?? []
		}
	}
	
	private func showLoader() {
		
		let loader = UIActivityIndicatorView(style: .gray)
		self.view.addSubview(loader)
		loader.center = self.view.center
		loader.startAnimating()
		
		self.loader = loader
	}
	
	private func hideLoader() {
		
		self.loader?.stopAnimating()
		self.loader?.removeFromSuperview()
		
		self.loader = nil
	}
}
