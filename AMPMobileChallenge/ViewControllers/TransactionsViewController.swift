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
        addButton()
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
        let feedItem = viewModel.feedItems[indexPath.item]
        cell.configure(item: feedItem)
        return cell
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 30, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(
            TransactionsCell.self,
            forCellWithReuseIdentifier: TransactionsCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func addButton() {
        let roundUpButton = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Round Up"
        config.image = UIImage(systemName: "arrow.up", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        config.imagePlacement = .trailing
        config.imagePadding = 8
        
        roundUpButton.configuration = config
        view.addSubview(roundUpButton)
        roundUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roundUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            roundUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        roundUpButton.addTarget(self, action: #selector(roundUpTapped), for: .touchUpInside)
    }
    
    @objc func roundUpTapped() {
        print("round uptapped")
        let roundUpVC = RoundUpViewController()
        roundUpVC.modalPresentationStyle = .pageSheet
        if let sheet = roundUpVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(roundUpVC, animated: true)
    }
}
