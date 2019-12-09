//
//  CreateAccountViewController.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {
    
    var userExperience: String = ""
    
    //    MARK: - UI Elements
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "BigAPP: Create Account"
        label.font = UIFont(name: "Verdana-Bold", size: 28)
        label.textColor = .cyan
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Email"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
        textField.borderStyle = .bezel
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
        textField.borderStyle = .bezel
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return textField
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var eventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Event", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = .cyan
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(selectEventExperience), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        button.isEnabled = true
        return button
    }()
    
    lazy var artButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Artsy Fartsy", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = .cyan
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(selectArtExperience), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        button.isEnabled = true
        return button
    }()
    
    lazy var selectExperienceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Please Select Your BigAPP Experience"
        return label
    }()
    
    //MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeaderLabel()
        setupCreateStackView()
    }
    
    //MARK: - Objc Functions
    
    @objc func validateFields() {
        guard emailTextField.hasText, passwordTextField.hasText, userExperience != "" else {
            createButton.backgroundColor = .lightGray
            createButton.isEnabled = false
            return
        }
        createButton.isEnabled = true
        createButton.backgroundColor = .cyan
    }
    
    @objc func trySignUp() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(with: "Error", and: "Please fill out all fields.")
            return
        }
        
        guard email.isValidEmail else {
            showAlert(with: "Error", and: "Please enter a valid email")
            return
        }
        
        guard password.isValidPassword else {
            showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
            return
        }
        
        guard userExperience != "" else {showAlert(with: "Error", and: "Please select an experience"); return}
        
        FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password) { [weak self] (result) in
            self?.handleCreateAccountResponse(with: result)
        }
    }
    
    @objc private func selectEventExperience() {
        self.userExperience = UserExperience.event.rawValue
        self.validateFields()
        self.eventButton.backgroundColor = .lightGray
        self.artButton.backgroundColor = .cyan
        print("event")
    }
    
    @objc private func selectArtExperience() {
        self.userExperience = UserExperience.art.rawValue
        self.validateFields()
        self.artButton.backgroundColor = .lightGray
        self.eventButton.backgroundColor = .cyan
        print("art")
    }
    
    //MARK: - Private Functions
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func handleCreateAccountResponse(with result: Result<User, Error>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let user):
                FirestoreService.manager.createAppUser(user: AppUser(from: user)) { [weak self] newResult in
                    self?.handleCreatedUserInFirestore(result: newResult)
                    UserDefaults.standard.set(self?.userExperience, forKey: "userExperience")
                }
            case .failure(let error):
                print(error)
                self?.showAlert(with: "Error creating user", and: "An error occured while creating new account")
            }
        }
    }
    
    private func handleCreatedUserInFirestore(result: Result<(), Error>) {
        switch result {
        case .success:
            
            FirebaseAuthService.manager.updateUserFields(experience: userExperience) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                    self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
                case .success():
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                        else {return}
                    
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        if self.userExperience == UserExperience.event.rawValue {
                            let eventVC = EventSearchViewController()
                            let navController = UINavigationController(rootViewController: eventVC)
                            window.rootViewController = navController
                        } else {
                            let artVC = ArtSearchViewController()
                            let navController = UINavigationController(rootViewController: artVC)
                            window.rootViewController = navController
                        }
                        
                    }, completion: nil)
                }
            }
            
            FirestoreService.manager.updateCurrentUser(userExperience: userExperience) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success():
                    print("success")
                }
            }
            
        case .failure(let error):
            self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
        }
    }
    
    //MARK: - UI Setup
    
    
    private func setupHeaderLabel() {
        view.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            headerLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            headerLabel.heightAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08)])
    }
    
    
    private func setupCreateStackView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,selectExperienceLabel,eventButton,artButton,createButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
    }
}
