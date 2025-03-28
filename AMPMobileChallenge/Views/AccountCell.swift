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
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private var accountTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .left
        return label
    }()
    
    private var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        balanceLabel.text = nil
    }
    
    func configure(with account: Account, amount: Amount?) {
        nameLabel.text = account.name
        accountTypeLabel.text = account.accountType.uppercased()
        
        if let amount = amount {
            let dollarAmount = CurrencyFormatter.convertCentsToDollar(cents: amount.minorUnits)
            let dollarString = String(format: "%.2f", dollarAmount)
            balanceLabel.text = "£" + dollarString
        }
    }
    
    private func setupConstraints() {
        contentView.addSubview(balanceLabel)
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            balanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            balanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
        
        
        let stackView = UIStackView(arrangedSubviews: [accountTypeLabel, nameLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 28
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: balanceLabel.leadingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
        ])
        
        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 8
    }
}
