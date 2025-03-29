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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupActivityIndication()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.savingsGoals.removeAll()
    }
    
    private func fetchData() {
        Task {
            activityIndicator.startAnimating()
            
            await viewModel.getAccounts()
            await fetchSavingsGoals()
            collectionView.reloadData()
            
            activityIndicator.stopAnimating()
        }
    }
    
    private func fetchSavingsGoals() async {
        for account in viewModel.accounts {
            
            // TODO: Handle this concurrently
            await viewModel.fetchSavingGoalsForID(account.accountUid)
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

extension SavingsGoalViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.savingsGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SavingGoalsCell.reuseIdentifier,
            for: indexPath
        ) as? SavingGoalsCell else { return  UICollectionViewCell() }
        let savingsGoal = viewModel.savingsGoals[indexPath.row]
        cell.configure(with: savingsGoal)
        return cell
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 30, height: 160)
        layout.sectionInset = UIEdgeInsets(top: 40, left: 15, bottom: 20, right: 15)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(SavingGoalsCell.self, forCellWithReuseIdentifier: SavingGoalsCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
