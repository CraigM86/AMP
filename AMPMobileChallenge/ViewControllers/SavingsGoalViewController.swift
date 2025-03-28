//
//  SavingsGoalViewController.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import UIKit

class SavingsGoalViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let viewModel = SavingsGoalViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func fetchData() {
        Task {
            await viewModel.getAccounts()
            await fetchSavingsGoals()
            collectionView.reloadData()
        }
    }
    
    private func fetchSavingsGoals() async {
        for account in viewModel.accounts {
            
            // TODO: Handle this concurrently
            await viewModel.fetchSavingGoalsForID(account.accountUid)
        }
    }
}

extension SavingsGoalViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.savingsGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AccountCell.reuseIdentifier,
            for: indexPath
        ) as? AccountCell else { return  UICollectionViewCell() }
//        let account = viewModel.accounts[indexPath.item]
//        let amount = viewModel.balance(for: account.accountUid)
//        cell.configure(with: account, amount: amount)
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
}
