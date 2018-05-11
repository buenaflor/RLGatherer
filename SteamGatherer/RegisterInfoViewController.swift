//
//  RegisterInfoViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 09.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import SDWebImage

class RegisterInfoViewController: UIViewController, UITextFieldDelegate, TiersViewControllerDelegate {
    
    lazy var nameTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Name")
        tf.delegate = self
        return tf
    }()
    
    lazy var platformIDTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Platform Link")
        tf.delegate = self
        tf.tag = 2
        return tf
    }()
    
    lazy var tiersTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Division")
        tf.delegate = self
        tf.tag = 3
        return tf
    }()
    
    lazy var platformTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Platform")
        tf.delegate = self
        tf.tag = 1
        tf.isEnabled = false
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
    
    lazy var choosePlatformButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Platform", for: .normal)
        btn.backgroundColor = UIColor.RL.mainDarkHighlight
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(choosePlatformButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    let oneVoneLabel = Label(font: .RLRegularLarge, textAlignment: .center, textColor: .white, numberOfLines: 1)
    let twoVtwoLabel = Label(font: .RLRegularLarge, textAlignment: .center, textColor: .white, numberOfLines: 1)
    let threeVthreeSoloLabel = Label(font: .RLRegularLarge, textAlignment: .center, textColor: .white, numberOfLines: 1)
    let threeVthreeStandardLabel = Label(font: .RLRegularLarge, textAlignment: .center, textColor: .white, numberOfLines: 1)
    
    let oneVoneRankLabel = Label(font: .RLRegularLarge, textAlignment: .center, textColor: .white, numberOfLines: 1)
    let twoVtwoRankLabel = Label(font: .RLRegularLarge, textAlignment: .center, textColor: .white, numberOfLines: 1)
    let threeVthreeSoloRankLabel = Label(font: .RLRegularLarge, textAlignment: .center, textColor: .white, numberOfLines: 1)
    let threeVthreeStandardRankLabel = Label(font: .RLRegularLarge, textAlignment: .center, textColor: .white, numberOfLines: 1)
    
    let oneVoneRankImageView = UIImageView()
    let twoVtwoRankImageView = UIImageView()
    let threeVthreeSoloRankImageView = UIImageView()
    let threeVthreeStandardRankImageView = UIImageView()
    
    
    let infoDescLabel = Label(font: .RLBoldLarge, textAlignment: .center, textColor: .white, numberOfLines: 0)
    
    let avatarImageView = UIImageView()
    let displayNameLabel = Label(font: .RLBoldLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let platformIDLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)

    var email: String?
    var password: String?
    
    var currentPlatform = ""
    
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        infoDescLabel.text = "Link your Steam ID to start matching"
        
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
    
        view.add(subview: choosePlatformButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.3),
            v.heightAnchor.constraint(equalToConstant: 58)
            ]}
        
        view.add(subview: platformTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: choosePlatformButton.leadingAnchor, constant: -10),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
    
        view.add(subview: platformIDTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: platformTextField.bottomAnchor, constant: 24),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
    }
    
    @objc func endEditing() {
        platformIDTextField.resignFirstResponder()
        platformTextField.resignFirstResponder()
    }
    
    @objc func chooseTierButtonTapped() {
        let tiersVC = TiersViewController()
        tiersVC.delegate = self
        navigationController?.pushViewController(tiersVC, animated: true)
    }
    
    @objc func choosePlatformButtonTapped() {
        let alertController = UIAlertController(title: "Choose a platform", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Steam", style: .default, handler: { (RL_) in
            self.platformIDTextField.placeholder = "Steam Profile Link or Steam ID"
            self.platformTextField.text = "Steam"
            self.currentPlatform = "Steam"
        }))
        
        alertController.addAction(UIAlertAction(title: "PS4", style: .default, handler: { (RL_) in
            self.platformIDTextField.placeholder = "PSN Username"
            self.platformTextField.text = "PS4"
            self.currentPlatform = "PS4"
        }))
        
        alertController.addAction(UIAlertAction(title: "XboxOne", style: .default, handler: { (RL_) in
            self.platformIDTextField.placeholder = "Xbox GamerTag or XUID"
            self.platformTextField.text = "XboxOne"
            self.currentPlatform = "XboxOne"
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func tiersViewController(_ tiersViewController: TiersViewController, didChoose tier: Tier) {
        tiersTextField.text = tier.tierName
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            if textField.text != "" {
                SessionManager.shared.start(call: RLClient.GetPlayer(tag: "player", query: ["apikey": BaseConfig.shared.apiKey, "unique_id": "vel72027", "platform_id": "1"])) { (result) in
                    result.onSuccess { value in
                        
                        let player = value.player
                        
                        if let avatarURL = URL(string: player.avatar) {
                            
                            self.oneVoneLabel.text = "1v1"
                            self.twoVtwoLabel.text = "2v2"
                            self.threeVthreeStandardLabel.text = "Stand. 3v3"
                            self.threeVthreeSoloLabel.text = "Solo 3v3"
                            
                            var tempSeason = 0
                            
                            player.rankedSeasons.forEach({ (_, _) in
                                tempSeason = tempSeason + 1
                            })
                            
                            let season = player.rankedSeasons["\(tempSeason)"]
                            season?.forEach({ (key, value) in
                                SessionManager.shared.tiers.forEach({ (sharedTier) in
                                    guard let tier = value.tier else { return }
                                    if sharedTier.tierId == tier {
                                        switch Int(key) {
                                        case 10:
                                            self.oneVoneRankLabel.text = "\(sharedTier.shortedTierName)"
                                            self.oneVoneRankImageView.image = UIImage(named: sharedTier.tierName)
                                        case 11:
                                            self.twoVtwoRankLabel.text = "\(sharedTier.shortedTierName)"
                                            self.twoVtwoRankImageView.image = UIImage(named: sharedTier.tierName)
                                        case 12:
                                            self.threeVthreeSoloRankLabel.text = "\(sharedTier.shortedTierName)"
                                        case 13:
                                            self.threeVthreeStandardRankLabel.text = "\(sharedTier.shortedTierName)"
                                        default:
                                            break
                                        }
                                    }
                                })
                            })
                            
                            
                            self.avatarImageView.sd_setImage(with: avatarURL)
                            self.displayNameLabel.text = player.displayName
                            self.platformIDLabel.text = "\(self.currentPlatform) ID: \(player.uniqueId)"
                            
                            
                            
                            let topContainerView = UIView()
                            topContainerView.addSeparatorLine(color: UIColor.RL.mainDarkHighlight)
                        
                            self.view.add(subview: topContainerView, createConstraints: { (v, p) in [
                                v.topAnchor.constraint(equalTo: self.platformIDTextField.bottomAnchor, constant: 25),
                                v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
                                v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
                                v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.15)
                                ]})
                            
                            topContainerView.add(subview: self.avatarImageView, createConstraints: { (v, p) in [
                                v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
                                v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
                                v.heightAnchor.constraint(equalToConstant: 80),
                                v.widthAnchor.constraint(equalToConstant: 80)
                                ]})

                            topContainerView.add(subview: self.displayNameLabel, createConstraints: { (v, p) in [
                                v.topAnchor.constraint(equalTo: p.topAnchor, constant: 20),
                                v.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 20)
                                ]})

                            topContainerView.add(subview: self.platformIDLabel, createConstraints: { (v, p) in [
                                v.topAnchor.constraint(equalTo: self.displayNameLabel.bottomAnchor, constant: 5),
                                v.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 20)
                                ]})

                            self.avatarImageView.layer.masksToBounds = true
                            self.avatarImageView.layer.cornerRadius = 40
                            
                            self.view.add(subview: self.oneVoneLabel, createConstraints: { (v, p) in [
                                v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 20),
                                v.centerXAnchor.constraint(equalTo: p.centerXAnchor, constant: -70)
                                ]})
                            
                            self.view.add(subview: self.twoVtwoLabel, createConstraints: { (v, p) in [
                                v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 20),
                                v.centerXAnchor.constraint(equalTo: p.centerXAnchor, constant: 70)
                                ]})
                            
                            self.view.add(subview: self.oneVoneRankLabel, createConstraints: { (v, p) in [
                                v.topAnchor.constraint(equalTo: self.oneVoneLabel.bottomAnchor, constant: 5),
                                v.centerXAnchor.constraint(equalTo: p.centerXAnchor, constant: -70)
                                ]})
                            
                            self.view.add(subview: self.twoVtwoRankLabel, createConstraints: { (v, p) in [
                                v.topAnchor.constraint(equalTo: self.twoVtwoLabel.bottomAnchor, constant: 5),
                                v.centerXAnchor.constraint(equalTo: p.centerXAnchor, constant: 70)
                                ]})
                            
                            self.view.add(subview: self.oneVoneRankImageView, createConstraints: { (v, p) in [
                                v.topAnchor.constraint(equalTo: self.oneVoneRankLabel.bottomAnchor, constant: 5),
                                v.centerXAnchor.constraint(equalTo: p.centerXAnchor, constant: -70),
                                v.heightAnchor.constraint(equalToConstant: 50),
                                v.widthAnchor.constraint(equalToConstant: 50)
                                ]})
                            
                            self.view.add(subview: self.twoVtwoRankImageView, createConstraints: { (v, p) in [
                                v.topAnchor.constraint(equalTo: self.twoVtwoRankLabel.bottomAnchor, constant: 5),
                                v.centerXAnchor.constraint(equalTo: p.centerXAnchor, constant: 70),
                                v.heightAnchor.constraint(equalToConstant: 50),
                                v.widthAnchor.constraint(equalToConstant: 50)
                                ]})
                            
                        }
                        
                        }.onError { err in
                            self.showAlert(title: "Error", message: err.localizedDescription)
                    }
                }
            } else {
                if platformTextField.text == "" {
                    showAlert(title: "Missing Characters", message: "Choose a platform!")
                }
                else {
                    showAlert(title: "Missing Characters", message: "Enter the appropriate tags based on your platform!")
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
