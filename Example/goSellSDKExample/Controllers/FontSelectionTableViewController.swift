//
//  FontSelectionTableViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSIndexPath.IndexPath
import class	UIKit.UITableView.UITableView
import class	UIKit.UITableViewCell.UITableViewCell

internal class FontSelectionTableViewController: CaseSelectionTableViewController {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: FontTableViewCell.tap_className) as? FontTableViewCell else {
			
			fatalError("Failed to load \(FontTableViewCell.tap_className) from storyboard.")
		}
		
		return cell
	}
	
	internal override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		guard let fontCell = cell as? FontTableViewCell else {
			
			fatalError("Somehow wrong cell is here.")
		}
		
		let value = self.allValues[indexPath.row]
		
		fontCell.setFont(value.description)
		
		let selected = self.preselectedValue?.description == value.description
		if selected {
			
			if tableView.indexPathForSelectedRow != indexPath {
				
				tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
			}
			
			fontCell.accessoryType = .checkmark
		}
		else {
			
			fontCell.accessoryType = .none
		}
	}
}
