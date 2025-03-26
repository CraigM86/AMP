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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        fetchData()
    }
    
    private func fetchData() {
        Task {
            await viewModel.getAccounts()
            await fetchBalance()
            collectionView.reloadData()
        }
    }
    
    private func fetchBalance() async {
        for account in viewModel.accounts {
            
            await viewModel.getAccountBalanceByID(account.accountUid)
        }
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
        let balance = viewModel.amount
        return cell
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 30, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}
