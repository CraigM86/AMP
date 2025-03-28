//
//  SavingGoalsCell.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 28/3/2025.
//

import UIKit

class SavingGoalsCell: UICollectionViewCell {
    static let reuseIdentifier = "SavingGoalsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 8
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var headingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private var savingsHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .left
        return label
    }()
    
    private var savingsBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    func configure(with goal: SavingsGoal) {
        headingLabel.text = goal.name
        savingsHeaderLabel.text = "SAVINGS"
        let totalSaved = goal.totalSaved.minorUnits
        let target = goal.target.minorUnits
        let balanceText = "£\(CurrencyFormatter.convertCentsToDollar(cents: totalSaved))/£\(CurrencyFormatter.convertCentsToDollar(cents: target))"
        savingsBalanceLabel.text = balanceText
    }
    
    private func setupViews() {
        contentView.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(savingsHeaderLabel)
        stackView.addArrangedSubview(savingsBalanceLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
        
}
