//
//  TransactionsCell.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 27/3/2025.
//

import UIKit

class TransactionsCell: UICollectionViewCell {
    static let reuseIdentifier = "TransactionsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    func configure() {
        
    }
}
