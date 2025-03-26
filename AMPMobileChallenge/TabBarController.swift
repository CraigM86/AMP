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
        let roundUpVC = RoundUpViewController()
        let savingsGoalVC = SavingsGoalViewController()
        
        accountsVC.tabBarItem = UITabBarItem(title: "Accounts", image: UIImage(systemName: "creditcard"), tag: 0)
        roundUpVC.tabBarItem = UITabBarItem(title: "Round Up", image: UIImage(systemName: "arrow.up"), tag: 1)
        savingsGoalVC.tabBarItem = UITabBarItem(title: "Savings Goal", image: UIImage(systemName: "wallet.bifold"), tag: 2)
        
        accountsVC.title = "Accounts"
        roundUpVC.title = "Round Up"
        savingsGoalVC.title = "Savings Goal"
        
        let accountsNav = UINavigationController(rootViewController: accountsVC)
        let roundUpNav = UINavigationController(rootViewController: roundUpVC)
        let savingsGoalNav = UINavigationController(rootViewController: savingsGoalVC)
        
        setViewControllers([accountsNav, roundUpNav, savingsGoalNav], animated: false)
    }
}
