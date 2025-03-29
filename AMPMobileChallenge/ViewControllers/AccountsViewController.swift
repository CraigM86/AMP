//
//  AccountsViewController.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import UIKit

class AccountsViewController: UIViewController {
    
    private let viewModel = AccountsViewModel()
    private var collectionView: UICollectionView!

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupActivityIndication()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func fetchData() {
        Task {
            activityIndicator.startAnimating()
            await viewModel.getAccounts()
            await fetchBalance()
            collectionView.reloadData()
            
            activityIndicator.stopAnimating()
        }
    }
    
    private func fetchBalance() async {
        for account in viewModel.accounts {
            
            // TODO: Put this in a Group so they're requested concurrently
            await viewModel.getAccountBalanceByID(account.accountUid)
        }
    }
    
    private func setupActivityIndication() {
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension AccountsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AccountCell.reuseIdentifier,
            for: indexPath
        ) as? AccountCell else { return  UICollectionViewCell() }
        let account = viewModel.accounts[indexPath.item]
        let amount = viewModel.balance(for: account.accountUid)
        cell.configure(with: account, amount: amount)
        return cell
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 30, height: 160)
        layout.sectionInset = UIEdgeInsets(top: 40, left: 15, bottom: 20, right: 15)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let acount = viewModel.accounts[indexPath.item]
        let transactionsViewModel = TransactionsViewModel(accountUid: acount.accountUid, categoryUid: acount.defaultCategory)
        let vc = TransactionsViewController(viewModel: transactionsViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
