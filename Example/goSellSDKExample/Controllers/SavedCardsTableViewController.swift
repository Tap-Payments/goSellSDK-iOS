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
import class	UIKit.UITableView.UITableViewRowAction
import class	UIKit.UITableViewCell.UITableViewCell

internal final class SavedCardsTableViewController: ModalNavigationTableViewController {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var customerIdentifier: String?
	
	internal override var isDoneButtonEnabled: Bool {
		
		return true
	}
	
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
	
	internal override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
			
			self?.deleteCard(at: indexPath)
		}
		
		return [delete]
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
	
	private func deleteCard(at indexPath: IndexPath) {
		
		guard let cardIdentifier = self.cards[indexPath.row].identifier, let customer = self.customerIdentifier else { return }
		
		self.showLoader()
	
		APISession.shared.deleteCard(cardIdentifier, of: customer) { [weak self] (deleted, error) in
			
			guard let strongSelf = self else { return }
			
			strongSelf.hideLoader()
			
			if deleted {
				
				strongSelf.didDeleteCard(at: indexPath)
			}
		}
	}
	
	private func didDeleteCard(at indexPath: IndexPath) {
		
		self.tableView.beginUpdates()
		
		self.cards.remove(at: indexPath.row)
		self.tableView.deleteRows(at: [indexPath], with: .automatic)
		
		self.tableView.endUpdates()
	}
}
