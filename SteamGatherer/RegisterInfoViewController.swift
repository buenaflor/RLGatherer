//
//  RegisterInfoViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 09.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class RegisterInfoViewController: UIViewController, UITextFieldDelegate, TiersViewControllerDelegate {
    
    let infoDescLabel = Label(font: .RLBoldLarge, textAlignment: .center, textColor: .white, numberOfLines: 0)
    
    lazy var nameTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Name")
        tf.delegate = self
        return tf
    }()
    
    lazy var steamProfileTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Steam Link")
        tf.delegate = self
        return tf
    }()
    
    lazy var tiersTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Division")
        tf.delegate = self
        tf.tag = 1
        return tf
    }()
    
    lazy var chooseTierButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Choose Tier", for: .normal)
        btn.backgroundColor = UIColor.RL.mainDarkHighlight
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(chooseTierButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    var email: String?
    var password: String?
    
    init(email: String, password: String) {
        super.init(nibName: nil, bundle: nil)
        self.email = email
        self.password = password
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.RL.mainDarker
        
        infoDescLabel.text = "Enter your info that will be visible to other players"
        
        view.add(subview: infoDescLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35)
            ]}
        
        view.add(subview: nameTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: infoDescLabel.bottomAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
        
        view.add(subview: steamProfileTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
        
        view.add(subview: chooseTierButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: steamProfileTextField.bottomAnchor, constant: 24),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.3),
            v.heightAnchor.constraint(equalToConstant: 58)
            ]}
        
        view.add(subview: tiersTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: steamProfileTextField.bottomAnchor, constant: 24),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: chooseTierButton.leadingAnchor, constant: -10),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
    }
    
    @objc func chooseTierButtonTapped() {
        let tiersVC = TiersViewController()
        tiersVC.delegate = self
        navigationController?.pushViewController(tiersVC, animated: true)
    }
    
    func tiersViewController(_ tiersViewController: TiersViewController, didChoose tier: Tier) {
        tiersTextField.text = tier.tierName
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            print("hey")
        }
    }
}
