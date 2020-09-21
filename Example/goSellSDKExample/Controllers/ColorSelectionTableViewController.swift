//
//  ColorSelectionTableViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import class	UIKit.UITableView.UITableView
import class	UIKit.UITableViewCell.UITableViewCell

internal class ColorSelectionTableViewController: CaseSelectionTableViewController {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.tap_className) as? ColorTableViewCell else {
			
			fatalError("Failed to load \(ColorTableViewCell.tap_className) from storyboard.")
		}
		
		return cell
	}
	
	internal override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		guard let colorCell = cell as? ColorTableViewCell else {
			
			fatalError("Somehow wrong cell is here.")
		}
		
		let value = self.allValues[indexPath.row] as! Color
		
		colorCell.setColor(value)
		
		let selected = self.preselectedValue?.description == value.description
		if selected {
			
			if tableView.indexPathForSelectedRow != indexPath {
				
				tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
			}
			
			colorCell.accessoryType = .checkmark
		}
		else {
			
			colorCell.accessoryType = .none
		}
	}
}
