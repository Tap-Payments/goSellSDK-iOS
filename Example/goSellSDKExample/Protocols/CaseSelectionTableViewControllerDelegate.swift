//
//  CaseSelectionTableViewControllerDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol CaseSelectionTableViewControllerDelegate: class {
    
    func caseSelectionViewController(_ controller: CaseSelectionTableViewController, didFinishWith value: CaseSelectionTableViewController.Value)
}
