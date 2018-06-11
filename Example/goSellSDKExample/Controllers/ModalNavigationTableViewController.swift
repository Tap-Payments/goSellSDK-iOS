//
//  ModalNavigationTableViewController.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class Dispatch.DispatchQueue
import class UIKit.UIBarButtonItem.UIBarButtonItem
import class UIKit.UITableViewController.UITableViewController

internal class ModalNavigationTableViewController: UITableViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Point to override.
    internal var isDoneButtonEnabled: Bool {
        
        return false
    }
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.updateDoneButtonState()
    }
    
    /// Updates done button state.
    internal func updateDoneButtonState() {
        
        self.doneButton?.isEnabled = self.isDoneButtonEnabled
    }
    
    /// Point to override. Is called when done button is clicked right before the screen dismissal.
    internal func doneButtonClicked() {
        
        fatalError("Should be implemented in subclasses.")
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var doneButton: UIBarButtonItem?
    
    // MARK: Methods
    
    @IBAction private func cancelButtonTouchUpInside(_ sender: Any) {
        
        self.close()
    }
    
    @IBAction private func doneButtonTouchUpInside(_ sender: Any) {
        
        guard self.isDoneButtonEnabled else { return }
        
        self.doneButtonClicked()
        self.close()
    }
    
    private func close() {
        
        DispatchQueue.main.async {
            
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
