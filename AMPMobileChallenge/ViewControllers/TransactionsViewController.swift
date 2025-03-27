//
//  TransactionsViewController.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 27/3/2025.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    private let viewModel: TransactionsViewModel
    
    init(viewModel: TransactionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.previousTransactionDayThreshold(days: 7)
        Task {
            await viewModel.getTransactionFeed()
        }
    }
}
