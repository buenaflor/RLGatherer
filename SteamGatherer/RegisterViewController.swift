//
//  RegisterViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class RegisterViewController: BaseFormViewController {
    
    lazy var exitItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_exit_50").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(exitItemTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.RL.mainDarker
        
        navigationItem.rightBarButtonItem = exitItem
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap))
        view.addGestureRecognizer(dismissTap)
        
        loginButton.setTitle("Next", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        view.backgroundColor = UIColor.RL.mainDarker
        
        iconImageView.setImage(#imageLiteral(resourceName: "RL_rocket_100"), with: .alwaysTemplate, tintColor: .white)
        
        informationLabel.lineBreakMode = .byWordWrapping
        informationLabel.text = "Register to start looking for teammates or enemies!"
        
        titleLabel.text = "RLGatherer"
        
        view.add(subview: topContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4)
            ]}
        
        topContainerView.add(subview: iconImageView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: -25),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.25),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.25)
            ]}
        
        topContainerView.add(subview: titleLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 15),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]}
        
        topContainerView.add(subview: informationLabel) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35)
            ]}
        
        view.add(subview: emailTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
        
        view.add(subview: passwordTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
        
        view.add(subview: loginButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
    }
    
    @objc func dismissKeyboardOnTap() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc func loginButtonTapped() {
        
        guard let username = emailTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Error", message: "Something went wrong", completion: {})
            return
        }
        
        if username.isEmpty || password.isEmpty {
            if username.isEmpty && password.isEmpty {
                emailTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                showAlert(title: "Error", message: "Enter your password and username!", completion: {})
            }
            else {
                if username.isEmpty {
                    emailTextField.layer.borderColor = UIColor.red.cgColor
                    showAlert(title: "Error", message: "Enter your username!", completion: {})
                }
                if password.isEmpty {
                    passwordTextField.layer.borderColor = UIColor.red.cgColor
                    showAlert(title: "Error", message: "Enter your password!", completion: {})
                }
            }
        }
        else {
            let registerInfoVC = RegisterInfoViewController(email: username, password: password)
            navigationController?.pushViewController(registerInfoVC, animated: true)
        }
    }
    
    @objc func exitItemTapped() {
        dismiss(animated: true, completion: nil)
    }
}
