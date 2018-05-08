//
//  LoginViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let topContainerView = UIView()
    let iconImageView = UIImageView()
    let informationLabel = Label(font: .RLRegularMedium, textAlignment: .center, textColor: .white, numberOfLines: 1)

    lazy var userNameTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Username")
        tf.delegate = self
        return tf
    }()
    
    lazy var passwordTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Password")
        tf.delegate = self
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginButton: RLButton = {
        let btn = RLButton(title: "Login", titleColor: .white, backgroundColor: UIColor.RL.mainDarker, font: .RLRegularLarge)
        return btn
    }()
    
    lazy var registerButton: RLButton = {
        let btn = RLButton(title: "Create new account", titleColor: .white, backgroundColor: .clear, font: .RLRegularMedium)
        return btn
    }()
    
    lazy var forgotPasswordButton: RLButton = {
        let btn = RLButton(title: "Forgot password?", titleColor: .white, backgroundColor: .clear, font: .RLRegularMedium)
        return btn
    }()
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [forgotPasswordButton, registerButton])
        sv.distribution = .equalSpacing
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap))
        view.addGestureRecognizer(dismissTap)
        
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        view.backgroundColor = UIColor.RL.main
        
        iconImageView.setImage(#imageLiteral(resourceName: "RL_rocket_100"), with: .alwaysTemplate, tintColor: .white)
        
        informationLabel.text = "Login to see and match with other players"
        
        view.add(subview: topContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4)
            ]}
        
        topContainerView.add(subview: iconImageView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.25),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.25)
            ]}
        
        topContainerView.add(subview: informationLabel) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]}
        
        view.add(subview: userNameTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
        
        view.add(subview: passwordTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 24),
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
        
        view.add(subview: bottomStackView) { (v, p) in [
            v.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 17),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.heightAnchor.constraint(equalToConstant: 20)
            ]}
    }

    @objc func dismissKeyboardOnTap() {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc func registerButtonTapped() {
        let registerVC = RegisterViewController()
        present(registerVC, animated: true, completion: nil)
    }
    
    @objc func forgotPasswordButtonTapped() {
        
    }
    
    @objc func loginButtonTapped() {
        guard let username = userNameTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Error", message: "Something went wrong")
            return
        }

        if username.isEmpty || password.isEmpty {
            if username.isEmpty && password.isEmpty {
                userNameTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                showAlert(title: "Error", message: "Enter your password and username!")
            }
            else {
                if username.isEmpty {
                    userNameTextField.layer.borderColor = UIColor.red.cgColor
                    showAlert(title: "Error", message: "Enter your username!")
                }
                if password.isEmpty {
                    passwordTextField.layer.borderColor = UIColor.red.cgColor
                    showAlert(title: "Error", message: "Enter your password!")
                }
            }
        }
        else {
            Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
                else {
                    SessionManager.shared.updateAuthentication()
                    self.dismiss(animated: true, completion: nil)
                    print(SessionManager.shared.isLoggedIn)
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Customize Color
        textField.layer.borderColor = UIColor.green.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField {
            textField.returnKeyType = .done
        } else {
            textField.returnKeyType = .next
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            return true
        }
        passwordTextField.becomeFirstResponder()
        return true
    }
    
}

