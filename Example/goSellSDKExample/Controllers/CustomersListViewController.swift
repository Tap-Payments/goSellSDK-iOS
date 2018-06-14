//
//  CustomersListViewController.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    Dispatch.DispatchQueue
import struct   Foundation.NSIndexPath.IndexPath
import class    goSellSDK.CustomerInfo
import class    UIKit.UIBarButtonItem.UIBarButtonItem
import class    UIKit.UINavigationController.UINavigationController
import class    UIKit.UIStoryboardSegue.UIStoryboardSegue
import class    UIKit.UITableView.UITableView
import class    UIKit.UITableView.UITableViewRowAction
import class    UIKit.UITableViewCell.UITableViewCell
import class    UIKit.UITableViewController.UITableViewController
import class    UIKit.UIView.UIView

internal class CustomersListViewController: UITableViewController {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var delegate: CustomersListViewControllerDelegate?
    
    internal var selectedCustomer: CustomerInfo?
    
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
        
        if let customerController = (segue.destination as? UINavigationController)?.rootViewController as? CustomerViewController {
            
            customerController.delegate = self
            customerController.customer = self.selectedCustomer
        }
    }
    
    internal override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.customers.count
    }
    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomerTableViewCell.className) as? CustomerTableViewCell else {
            
            fatalError("Failed to load \(CustomerTableViewCell.className) from storyboard.")
        }
        
        return cell
    }
    
    internal override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let customerCell = cell as? CustomerTableViewCell else {
            
            fatalError("Somehow cell class is wrong")
        }
        
        let customer = self.customers[indexPath.row]
        
        customerCell.fill(with: customer.firstName,
                          middleName: customer.middleName,
                          lastName: customer.lastName,
                          email: customer.emailAddress?.value,
                          phoneISDNumber: customer.phoneNumber?.isdNumber,
                          phoneNumber: customer.phoneNumber?.phoneNumber,
                          id: customer.identifier)
    }
    
    internal override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let customer = self.customers[indexPath.row]
        self.showCustomerViewController(with: customer)
    }
    
    internal override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, cellIndexPath) in
            
            self.customers.remove(at: cellIndexPath.row)
            tableView.deleteRows(at: [cellIndexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var customers: [CustomerInfo] = Serializer.deserialize()
    
    // MARK: Methods
    
    private func addAddButtonToNavigationBar() {
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouchUpInside(_:)))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func addButtonTouchUpInside(_ sender: Any) {
        
        self.showCustomerViewController()
    }
    
    private func showCustomerViewController(with customer: CustomerInfo? = nil) {
        
        self.selectedCustomer = customer
        self.show(CustomerViewController.self)
    }
    
    private func setupBackButton() {
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTouchUpInside(_:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func selectPreselectedCustomer() {
        
        if let customer = self.selectedCustomer, let index = self.customers.index(of: customer), self.tableView.numberOfRows(inSection: 0) > index {
            
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
        
        guard let index = self.tableView.indexPathForSelectedRow?.row else { return }
        
        self.delegate?.customersListViewController(self, didFinishWith: self.customers[index])
    }
}

// MARK: - CustomerViewControllerDelegate
extension CustomersListViewController: CustomerViewControllerDelegate {
    
    internal func customerViewController(_ controller: CustomerViewController, didFinishWith customer: CustomerInfo) {
        
        if let nonnullSelectedCustomer = self.selectedCustomer {
            
            if let index = self.customers.index(of: nonnullSelectedCustomer) {
                
                self.customers.remove(at: index)
                self.customers.insert(customer, at: index)
            }
            else {
                
                self.customers.append(customer)
            }
        }
        else {
            
            self.customers.append(customer)
        }
        
        Serializer.serialize(self.customers)
        
        self.tableView.reloadData()
    }
}

// MARK: - SeguePresenter
extension CustomersListViewController: SeguePresenter { }
