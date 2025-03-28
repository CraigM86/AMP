//
//  TabBarController.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let accountsVC = AccountsViewController()
        let savingsGoalVC = SavingsGoalViewController()
        
        accountsVC.tabBarItem = UITabBarItem(title: "Accounts", image: UIImage(systemName: "creditcard"), tag: 0)
        savingsGoalVC.tabBarItem = UITabBarItem(title: "Savings Goals", image: UIImage(systemName: "wallet.bifold"), tag: 2)
        
        accountsVC.title = "Accounts"
        savingsGoalVC.title = "Savings Goal"
        
        let accountsNav = UINavigationController(rootViewController: accountsVC)
        let savingsGoalNav = UINavigationController(rootViewController: savingsGoalVC)
        
        setViewControllers([accountsNav, savingsGoalNav], animated: false)
    }
}
