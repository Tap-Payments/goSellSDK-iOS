//
//  PaymentOptionsViewController+UITableView.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIScrollView.UIScrollView
import protocol	UIKit.UIScrollView.UIScrollViewDelegate
import class	UIKit.UITableView.UITableView
import protocol	UIKit.UITableView.UITableViewDataSource
import protocol	UIKit.UITableView.UITableViewDelegate
import class	UIKit.UITableViewCell.UITableViewCell

// MARK: - UIScrollViewDelegate
extension PaymentOptionsViewController: UIScrollViewDelegate {
    
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.view.tap_firstResponder?.resignFirstResponder()
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
		DispatchQueue.main.async {
	
			PaymentContentViewController.tap_findInHierarchy()?.updateHeaderShadowOpacity(with: scrollView.contentOffset.y)
		}
	}
}

// MARK: - UITableViewDataSource
extension PaymentOptionsViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
        return Process.shared.viewModelsHandlerInterface.paymentOptionCellViewModels.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = Process.shared.viewModelsHandlerInterface.paymentOptionViewModel(at: indexPath)
        
        if let currencyCellModel = model as? CurrencySelectionTableViewCellViewModel {
            
            let cell = currencyCellModel.dequeueCell(from: tableView)
            return cell
        }
        else if let emptyCellModel = model as? EmptyTableViewCellModel {
            
            let cell = emptyCellModel.dequeueCell(from: tableView)
            cell.backgroundColor = .clear
            return cell
        }
        else if let groupCellModel = model as? GroupTableViewCellModel {
            
            let cell = groupCellModel.dequeueCell(from: tableView)
            return cell
        }
		else if let groupWithButtonCellModel = model as? GroupWithButtonTableViewCellModel {
			
			let cell = groupWithButtonCellModel.dequeueCell(from: tableView)
			return cell
		}
        else if let cardsContainerCellModel = model as? CardsContainerTableViewCellModel {
            
            let cell = cardsContainerCellModel.dequeueCell(from: tableView)
			cell.bindContent()
            return cell
        }
        else if let webCellModel = model as? WebPaymentOptionTableViewCellModel {
            
            let cell = webCellModel.dequeueCell(from: tableView)
            return cell
        }
        else if let appleCellModel = model as? ApplePaymentOptionTableViewCellModel {
            
            let cell = appleCellModel.dequeueCell(from: tableView)
            return cell
        }
        else if let cardCellModel = model as? CardInputTableViewCellModel {
            
            let cell = cardCellModel.dequeueCell(from: tableView)
			cell.bindContent()
            return cell
        }
        else {
            
            fatalError("Unknown cell model: \(model)")
        }
    }
}

// MARK: - UITableViewDelegate
extension PaymentOptionsViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let model = Process.shared.viewModelsHandlerInterface.paymentOptionViewModel(at: indexPath)

        if let currencyModel = model as? CurrencySelectionTableViewCellViewModel {
            
            currencyModel.updateCell()
        }
        else if let groupModel = model as? GroupTableViewCellModel {
            
            groupModel.updateCell()
        }
		else if let groupWithButtonModel = model as? GroupWithButtonTableViewCellModel {
			
			groupWithButtonModel.updateCell()
		}
        else if let cardsContainerCellModel = model as? CardsContainerTableViewCellModel {
            
            cardsContainerCellModel.updateCell()
        }
        else if let webCellModel = model as? WebPaymentOptionTableViewCellModel {
            
            webCellModel.updateCell()
        }
        else if let applePayCellModel = model as? ApplePaymentOptionTableViewCellModel {
            
            applePayCellModel.updateCell()
        }
        else if let cardCellModel = model as? CardInputTableViewCellModel {
            
            cardCellModel.updateCell()
        }
    }
    
    internal func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let model = Process.shared.viewModelsHandlerInterface.paymentOptionViewModel(at: indexPath) as? TableViewCellViewModel
        return model?.indexPathOfCellToSelect
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let model = Process.shared.viewModelsHandlerInterface.paymentOptionViewModel(at: indexPath) as? TableViewCellViewModel else { return }
        model.tableViewDidSelectCell(tableView)
    }
    
    internal func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let model = Process.shared.viewModelsHandlerInterface.paymentOptionViewModel(at: indexPath) as? TableViewCellViewModel else { return }
        model.tableViewDidDeselectCell(tableView)
    }
}
