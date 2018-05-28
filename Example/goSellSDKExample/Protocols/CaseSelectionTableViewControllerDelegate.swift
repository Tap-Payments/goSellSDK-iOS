//
//  CaseSelectionTableViewControllerDelegate.swift
//  goSellSDKExample
//
//  Created by Dennis Pashkov on 5/26/18.
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol CaseSelectionTableViewControllerDelegate: class {
    
    func caseSelectionViewController(_ controller: CaseSelectionTableViewController, didFinishWith value: CaseSelectionTableViewController.Value)
}
