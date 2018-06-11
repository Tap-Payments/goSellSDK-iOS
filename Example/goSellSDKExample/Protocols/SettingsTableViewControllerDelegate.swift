//
//  SettingsTableViewControllerDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol SettingsTableViewControlerDelegate: class {
    
    func settingsViewController(_ controller: SettingsTableViewController, didFinishWith settings: Settings)
}
