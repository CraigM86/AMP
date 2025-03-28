//
//  TransactionsCell.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 27/3/2025.
//

import UIKit

class TransactionsCell: UICollectionViewCell {
    static let reuseIdentifier = "TransactionsCell"
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 19, weight: .regular)
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private var amountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    func configure(item: FeedItem) {
        dateLabel.text = Date().formatDateToAEDT(from: item.transactionTime)
        nameLabel.text = item.counterPartyName
        amountLabel.text = CurrencyFormatter.formattedAmount(
            from: item.amount,
            trasactionDirection: item.direction
        )
    }
    
    private func setupSubviews() {
        contentView.addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            amountLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            stackView.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -20)
        ])
    }
}
