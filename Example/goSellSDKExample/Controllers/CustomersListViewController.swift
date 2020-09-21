//
//  CustomersListViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import ObjectiveC

import class    Dispatch.DispatchQueue
import Foundation
import class    goSellSDK.Customer
import enum     goSellSDK.SDKMode
import class    UIKit.UIBarButtonItem.UIBarButtonItem
import class    UIKit.UINavigationController.UINavigationController
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView
import class    UIKit.UITableView.UITableViewRowAction
import class    UIKit.UITableViewCell.UITableViewCell
import class    UIKit.UITableViewController.UITableViewController
import class    UIKit.UIView.UIView
import class    UIKit.UITraitCollection

internal class CustomersListViewController: UITableViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: CustomersListViewControllerDelegate?
    
    internal var mode: SDKMode = .sandbox {
        
        didSet {
            
            self.filterVisibleCustomers(true)
        }
    }
    
    internal var selectedCustomer: EnvironmentCustomer?
    private var customerForCustomerController: EnvironmentCustomer?
    
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupBackButton()
        self.addAddButtonToNavigationBar()
        
        self.title = "Customers"
        self.tableView.tableFooterView = UIView()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.selectPreselectedCustomer()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let customerController = (segue.destination as? UINavigationController)?.tap_rootViewController as? CustomerViewController {
            
            customerController.delegate = self
            customerController.customer = self.customerForCustomerController
        }
    }
    
    internal override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.visibleCustomers.count
    }
    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomerTableViewCell.tap_className) as? CustomerTableViewCell else {
            
            fatalError("Failed to load \(CustomerTableViewCell.tap_className) from storyboard.")
        }
        
        return cell
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self.tableView.reloadData()
        
    }
    
    internal override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let customerCell = cell as? CustomerTableViewCell else {
            
            fatalError("Somehow cell class is wrong")
        }
        
        let envCustomer = self.visibleCustomers[indexPath.row]
        let selected = envCustomer == self.selectedCustomer
        
        if selected {
            
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        else {
            
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        cell.setSelected(selected, animated: false)
        
        let customer = envCustomer.customer
        
        customerCell.fill(with:             customer.firstName,
                          middleName:       customer.middleName,
                          lastName:         customer.lastName,
                          email:            customer.emailAddress?.value,
                          phoneISDNumber:   customer.phoneNumber?.isdNumber,
                          phoneNumber:      customer.phoneNumber?.phoneNumber,
                          id:               customer.identifier)
    }
    
    internal override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let customer = self.visibleCustomers[indexPath.row]
        self.showCustomerViewController(with: customer)
    }
    
    internal override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, cellIndexPath) in
            
            let customer = self.visibleCustomers[cellIndexPath.row]
            if let index = self.allCustomers.firstIndex(of: customer) {
                
                self.allCustomers.remove(at: index)
            }
            
            tableView.deleteRows(at: [cellIndexPath], with: .automatic)
            
            Serializer.serialize(self.allCustomers)
        }
        
        return [deleteAction]
    }
    
    internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedCustomer = self.visibleCustomers[indexPath.row]
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var allCustomers: [EnvironmentCustomer] = Serializer.deserialize() {
        
        didSet {
            
            self.filterVisibleCustomers(false)
        }
    }
    
    private var visibleCustomers: [EnvironmentCustomer] = []
    
    // MARK: Methods
    
    private func filterVisibleCustomers(_ reloadData: Bool = false) {
        
        self.visibleCustomers = self.allCustomers.filter { $0.environment == self.mode }
        
        if reloadData { self.tableView.reloadData() }
    }
    
    private func addAddButtonToNavigationBar() {
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouchUpInside(_:)))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func addButtonTouchUpInside(_ sender: Any) {
        
        self.showCustomerViewController()
    }
    
    private func showCustomerViewController(with customer: EnvironmentCustomer? = nil) {
        
        self.customerForCustomerController = customer
        self.show(CustomerViewController.self)
    }
    
    private func setupBackButton() {
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTouchUpInside(_:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func selectPreselectedCustomer() {
        
        if let customer = self.selectedCustomer, let index = self.visibleCustomers.firstIndex(of: customer), self.tableView.numberOfRows(inSection: 0) > index {
            
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    @objc private func backButtonTouchUpInside(_ sender: Any) {
        
        self.notifyDelegateAboutCustomerSelection()
        
        DispatchQueue.main.async {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func notifyDelegateAboutCustomerSelection() {
        
        if let index = self.tableView.indexPathForSelectedRow?.row, self.visibleCustomers.count > index {
            
            self.delegate?.customersListViewController(self, didFinishWith: self.visibleCustomers[index])
        }
        else if let firstCustomer = self.visibleCustomers.first {
            
            self.delegate?.customersListViewController(self, didFinishWith: firstCustomer)
        }
    }
}

// MARK: - CustomerViewControllerDelegate
extension CustomersListViewController: CustomerViewControllerDelegate {
    
    internal func customerViewController(_ controller: CustomerViewController, didFinishWith customer: EnvironmentCustomer) {
        
        customer.environment = self.mode
        
        if let nonnullSelectedCustomer = self.selectedCustomer {
            
            if let index = self.allCustomers.firstIndex(of: nonnullSelectedCustomer) {
                
                self.allCustomers.remove(at: index)
                self.allCustomers.insert(customer, at: index)
            }
            else {
                
                self.allCustomers.append(customer)
            }
        }
        else {
            
            self.allCustomers.append(customer)
        }
        
        Serializer.serialize(self.allCustomers)
        
        self.tableView.reloadData()
    }
}

// MARK: - SeguePresenter
extension CustomersListViewController: SeguePresenter { }
