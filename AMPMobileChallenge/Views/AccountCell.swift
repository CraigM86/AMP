//
//  AccountCell.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import UIKit

class AccountCell: UICollectionViewCell {
    static let reuseIdentifier = "AccountCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    func configure(with account: Account, balance: Amount?) {
        
    }
}
