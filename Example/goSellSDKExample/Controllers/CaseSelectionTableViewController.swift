//
//  CaseSelectionTableViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import ObjectiveC

import class	Dispatch.DispatchQueue
import struct	Foundation.NSIndexPath.IndexPath
import class	UIKit.UIBarButtonItem.UIBarButtonItem
import class	UIKit.UITableView.UITableView
import class	UIKit.UITableViewCell.UITableViewCell
import class	UIKit.UITableViewController.UITableViewController

internal class CaseSelectionTableViewController: UITableViewController {
    
    // MARK: - Internal -
    
    internal typealias Value = CustomStringConvertible
    
    // MARK: Properties
    
    internal weak var delegate: CaseSelectionTableViewControllerDelegate?
    
    internal var preselectedValue: Value?
    
    internal var allValues: [Value] = []
    
    // MARK: Methods
	
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.replaceBackButton()
    }
    
    internal override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.allValues.count
    }
    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.tap_className) as? TitleTableViewCell else {
            
            fatalError("Failed to load \(TitleTableViewCell.tap_className) from storyboard.")
        }
        
        return cell
    }
    
    internal override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let titleCell = cell as? TitleTableViewCell else {
            
            fatalError("Somehow wrong cell is here.")
        }
        
        let value = self.allValues[indexPath.row]
        
		titleCell.setTitle(self.allValues[indexPath.row])
        
        let selected = self.preselectedValue?.description == value.description
        if selected {
            
            if tableView.indexPathForSelectedRow != indexPath {
                
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            
            titleCell.accessoryType = .checkmark
        }
        else {
            
            titleCell.accessoryType = .none
        }
    }
    
    internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    internal override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func replaceBackButton() {
        
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTouchUpInside(_:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTouchUpInside(_ sender: Any) {
        
        self.callDelegate()
        
        DispatchQueue.main.async {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func callDelegate() {
        
        guard let index = self.tableView.indexPathForSelectedRow?.row else { return }
        
        let value = self.allValues[index]
        self.delegate?.caseSelectionViewController(self, didFinishWith: value)
    }
}
