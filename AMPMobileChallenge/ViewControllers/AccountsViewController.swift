//
//  AccountsViewController.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import UIKit

class AccountsViewController: UIViewController {
    
    private let viewModel = AccountsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchData()
    }
    
    private func fetchData() {
        Task {
            await viewModel.getAccounts()
            print("Accounts fetched: \(viewModel.accounts)")
            
            for account in viewModel.accounts {
                
                await viewModel.getAccountBalanceByID(account.accountUid)
            }
        }
    }
}
