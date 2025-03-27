//
//  TransactionsViewController.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 27/3/2025.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    private let viewModel: TransactionsViewModel
    private var collectionView: UICollectionView!
    
    init(viewModel: TransactionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setDate()
        getTransactions()
    }
    
    private func setDate() {
        viewModel.previousTransactionDayThreshold(days: 7)
    }
    
    private func getTransactions() {
        Task {
            await viewModel.getTransactionFeed()
            collectionView.reloadData()
        }
    }
}

extension TransactionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TransactionsCell.reuseIdentifier,
            for: indexPath
        ) as? TransactionsCell else { return  UICollectionViewCell() }
//        let account = viewModel.feedItems[indexPath.item]
//        let amount = viewModel.balance(for: account.accountUid)
        cell.configure()
        return cell
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 30, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(TransactionsCell.self, forCellWithReuseIdentifier: TransactionsCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
