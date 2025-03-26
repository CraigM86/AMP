//
//  AccountCell.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import UIKit

class AccountCell: UICollectionViewCell {
    static let reuseIdentifier = "AccountCell"
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    func configure(with account: Account, amount: Amount?) {
        if let amount = amount {
            balanceLabel.text = "\(amount.currency) \(amount.minorUnits)"
        }
    }
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, balanceLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9)
        ])
        
        contentView.backgroundColor = .systemGray6
    }
}
