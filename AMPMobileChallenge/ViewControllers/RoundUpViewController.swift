//
//  RoundUpViewController.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import UIKit

class RoundUpViewController: UIViewController {
    
    private let viewModel: RoundUpViewModel
    private let picker = UIPickerView()
    private let pickerOptions = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    
    var selectedSavingsGoal: String?
    
    init(viewModel: RoundUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private var titleLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private var roundUpLabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 60, weight: .bold)
        return label
    }()
    
    private var pickerLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private var submitButton = {
        let button = UIButton(type: .system)
        button.configuration = UIButton.Configuration.filled()
        button.setTitle("ADD TO SAVINGS GOAL", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupActivityIndication()
        fetchSavingsGoals()
        picker.delegate = self
        picker.dataSource = self
        titleLabel.text = "Round Up Amount"
        pickerLabel.text = "Select Savings Goal"
        roundUpLabel.text = String(format: "£%.2f", viewModel.roundUpAmount ?? 0)
    }
    
    private func fetchSavingsGoals() {
        Task {
            activityIndicator.startAnimating()
            
            await viewModel.fetchSavingGoalsForID(viewModel.accountUid)
            picker.reloadAllComponents()
            
            activityIndicator.stopAnimating()
        }
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(roundUpLabel)
        roundUpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roundUpLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            roundUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roundUpLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(pickerLabel)
        pickerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerLabel.topAnchor.constraint(equalTo: roundUpLabel.bottomAnchor, constant: 32),
            pickerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: pickerLabel.bottomAnchor, constant: 4),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            picker.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 48),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActivityIndication() {
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func handleSubmit() {
        guard let selectedSavingsGoal else { return }
        Task {
            await viewModel.addMoneyToSavingsGoal(savingsGoalID: selectedSavingsGoal)
            self.dismiss(animated: true)
        }
    }
}

extension RoundUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.savingsGoals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.savingsGoals[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSavingsGoal = viewModel.savingsGoals[row].savingsGoalUid
        submitButton.isEnabled = true
    }
}
