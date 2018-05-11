//
//  EditProfileViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 11.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

protocol EditProfileViewControllerDelegate: class {
    func editProfileViewControllerUpdatedSuccess(_ editProfileViewController: EditProfileViewController)
}

class EditProfileViewController: BaseViewController, Loadable, UITextFieldDelegate, TiersViewControllerDelegate, ModeViewControllerDelegate {
    
    func loadData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let coverView = UIView()
        coverView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        view.fillToSuperview(coverView)
        view.bringSubview(toFront: coverView)
        
        let loadingLabel = Label(font: .RLRegularLarge, textAlignment: .center, textColor: .white, numberOfLines: 1)
        loadingLabel.text = "Loading Data"
        
        let activityBarButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = activityBarButton
        
        coverView.add(subview: loadingLabel, createConstraints: { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]})
        
        FirebaseManager.shared.fetchCurrentUser(uid: uid) { (player, err) in
            if let err = err {
                self.showAlert(title: "Error", message: err.localizedDescription, completion: nil)
            }
            else {
                
                guard let player = player else { return }
                self.player = player
                self.currentPlatform = player.platform
                
                coverView.removeFromSuperview()
                loadingLabel.removeFromSuperview()
                
                self.checkMarkBarItem.tintColor = .orange
                self.navigationItem.rightBarButtonItem = self.checkMarkBarItem
                
                self.platformDescLabel.text = "Enter your \(player.platform) ID"
                self.nameTextField.attributedText = NSAttributedString(string: "\(player.name)", attributes: [NSAttributedStringKey.font : UIFont.RLRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.white])
                
                self.modeTextField.attributedText = NSAttributedString.String(player.mode.isEmpty ? "Mode" : player.mode, font: .RLRegularLarge, color: .white)
                self.rankTextField.attributedText = NSAttributedString.String(player.rank.isEmpty ? "Rank" : player.rank, font: .RLRegularLarge, color: .white)
                self.gatherActionTextField.attributedText = NSAttributedString.String(player.gatherAction.isEmpty ? "Gather Action" : player.gatherAction, font: .RLRegularLarge, color: .white)
                
                
                if player.platformID == "" {
                    self.platformIDTextField.attributedPlaceholder = NSAttributedString(string: "\(player.platform) ID", attributes: [NSAttributedStringKey.font : UIFont.RLRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.white])
                }
                else {
                    self.platformIDTextField.attributedText = NSAttributedString(string: "\(player.platformID)", attributes: [NSAttributedStringKey.font : UIFont.RLRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.white])
                }
            
            }
        }
    }
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    var player: Player?
    var previewShown = false
    var currentPlatform = ""
    
    lazy var checkMarkBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_checkmark_50").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(self.checkMarkItemTapped))
    
    lazy var platformIDTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "")
        tf.backgroundColor = UIColor.RL.mainDarkComplementary
        tf.delegate = self
        return tf
    }()
    
    lazy var nameTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "")
        tf.backgroundColor = UIColor.RL.mainDarkComplementary
        tf.delegate = self
        return tf
    }()
    
    lazy var modeTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "")
        tf.backgroundColor = UIColor.RL.mainDarkComplementary
        tf.delegate = self
        tf.isEnabled = false
        return tf
    }()
    
    lazy var gatherActionTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "")
        tf.backgroundColor = UIColor.RL.mainDarkComplementary
        tf.delegate = self
        tf.isEnabled = false
        return tf
    }()
    
    lazy var rankTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "")
        tf.backgroundColor = UIColor.RL.mainDarkComplementary
        tf.delegate = self
        tf.isEnabled = false
        return tf
    }()
    
    lazy var modeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Choose Mode", for: .normal)
        btn.backgroundColor = UIColor.RL.mainDarkHighlight
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(modeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var gatherActionButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Choose GA", for: .normal)
        btn.backgroundColor = UIColor.RL.mainDarkHighlight
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(gaButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var rankButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Choose Rank", for: .normal)
        btn.backgroundColor = UIColor.RL.mainDarkHighlight
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(rankButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    let avatarImageView = UIImageView()
    
    let platformDescLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let nameDescLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let modeDescLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let gatherActionDescLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let rankDescLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    let namePrevLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    let topContainerView = UIView()
    let middleContainerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameDescLabel.text = "Name"
        modeDescLabel.text = "Mode"
        rankDescLabel.text = "Rank"
        gatherActionDescLabel.text = "Gather Action"
        
        view.backgroundColor = UIColor.RL.mainDarker
        topContainerView.backgroundColor = UIColor.RL.mainDarkHighlight.withAlphaComponent(0.6)
        
        let exitBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_exit_50"), style: .plain, target: self, action: #selector(exitItemTapped))
        navigationItem.leftBarButtonItem = exitBarButtonItem
    
        view.add(subview: topContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.15)
            ]}
        
        // Platform
        
        topContainerView.add(subview: platformIDTextField) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4)
            ]}
        
        topContainerView.add(subview: platformDescLabel) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: platformIDTextField.topAnchor, constant: -5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]}
        
        
        // Container
        
        view.add(subview: middleContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.6)
            ]}
        
        middleContainerView.addSeparatorLine(color: UIColor.RL.mainDarkHighlight)
        
        
        // Name
        
        middleContainerView.add(subview: nameDescLabel, createConstraints: { (v, p) in [
            v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]})
        
        middleContainerView.add(subview: nameTextField, createConstraints: { (v, p) in [
            v.topAnchor.constraint(lessThanOrEqualTo: nameDescLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.4)
            ]})
        
        
        // Mode
        
        middleContainerView.add(subview: modeDescLabel, createConstraints: { (v, p) in [
            v.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]})
        
        middleContainerView.add(subview: modeButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: modeDescLabel.bottomAnchor, constant: 5),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.3),
            v.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.4)
            ]}
        
        middleContainerView.add(subview: modeTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: modeDescLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: modeButton.leadingAnchor, constant: -10),
            v.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.4)
            ]}
        
        
        // Rank
        
        middleContainerView.add(subview: rankDescLabel, createConstraints: { (v, p) in [
            v.topAnchor.constraint(equalTo: modeTextField.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]})
        
        middleContainerView.add(subview: rankButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: rankDescLabel.bottomAnchor, constant: 5),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.3),
            v.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.4)
            ]}
        
        middleContainerView.add(subview: rankTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: rankDescLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: modeButton.leadingAnchor, constant: -10),
            v.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.4)
            ]}
        
        
        // Gather Action
        
        middleContainerView.add(subview: gatherActionDescLabel, createConstraints: { (v, p) in [
            v.topAnchor.constraint(equalTo: rankTextField.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]})
        
        middleContainerView.add(subview: gatherActionButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: gatherActionDescLabel.bottomAnchor, constant: 5),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.3),
            v.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.4)
            ]}
        
        middleContainerView.add(subview: gatherActionTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: gatherActionDescLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: modeButton.leadingAnchor, constant: -10),
            v.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.4)
            ]}
        
        
    }
    
    
    // MARK: - Action Handlers
    
    @objc func checkMarkItemTapped() {
        guard let player = player, let platformIDText = platformIDTextField.text else { return }
        
        if !previewShown {
            SessionManager.shared.start(call: RLClient.GetPlayer(tag: "player", query: ["apikey": BaseConfig.shared.apiKey, "unique_id": platformIDText, "platform_id": "\(player.platformNameID)"]), completion: { (result) in
                result.onSuccess { value in
                    self.showAlert(title: "Success", message: "ID is valid", completion: {
                        let player = value.player
                        
                        if player.platform.name == "Ps4" {
                            print("here")
                            if let avatarURLString = player.avatar {
                                self.avatarImageView.sd_setImage(with: URL(string: avatarURLString)!)
                            }
                            else {
                                print("here")
                                self.avatarImageView.image = #imageLiteral(resourceName: "RL_psn")
                            }
                        }
                        
                        self.view.add(subview: self.avatarImageView, createConstraints: { (v, p) in [
                            v.topAnchor.constraint(equalTo: self.middleContainerView.bottomAnchor, constant: 10),
                            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
                            v.heightAnchor.constraint(equalToConstant: 80),
                            v.widthAnchor.constraint(equalToConstant: 80)
                            ]})
                        
                        self.checkMarkBarItem.image = nil
                        self.checkMarkBarItem.title = "Submit"
                        
                        self.previewShown = true
                    })
                    }.onError { err in
                        print(err.localizedDescription)
                        self.showAlert(title: "Error", message: "\(player.platform) ID is not valid", completion: {
                            self.platformIDTextField.becomeFirstResponder()
                        })
                }
            })
        }
        else {
            guard let platformIDText = platformIDTextField.text, let nameText = nameTextField.text, let modeText = modeTextField.text, let rankText = rankTextField.text, let gatherActionText = gatherActionTextField.text, let uid = Auth.auth().currentUser?.uid else { return }
            
            let player = Player(id: uid, name: nameText, rank: rankText, platformID: platformIDText, platform: currentPlatform, mode: modeText, gatherAction: gatherActionText)
            FirebaseManager.shared.updateCurrentUser(player: player) { (err) in
                if let err = err {
                    self.showAlert(title: "Error", message: err.localizedDescription, completion: nil)
                }
                else { 
                    SessionManager.shared.setNewUser(false)
                    self.delegate?.editProfileViewControllerUpdatedSuccess(self)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func rankButtonTapped() {
        let tiersVC = TiersViewController()
        tiersVC.delegate = self
        navigationController?.pushViewController(tiersVC, animated: true)
    }
    
    @objc func gaButtonTapped() {
        let alertController = UIAlertController(title: "Choose a Gather Action", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Team Up", style: .default, handler: { (_) in
            self.gatherActionTextField.attributedText = NSAttributedString.String("Team Up", font: .RLRegularLarge, color: .white)
        }))
        
        alertController.addAction(UIAlertAction(title: "Versus", style: .default, handler: { (_) in
            self.gatherActionTextField.attributedText = NSAttributedString.String("Versus", font: .RLRegularLarge, color: .white)
        }))
        
        alertController.addAction(UIAlertAction(title: "Scrim", style: .default, handler: { (_) in
            self.gatherActionTextField.attributedText = NSAttributedString.String("Scrim", font: .RLRegularLarge, color: .white)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func modeButtonTapped() {
        guard let player = player else { return }
        let modeVC = ModeViewController(currentPlatform: player.platform, presentationStyle: .push)
        modeVC.delegate = self
        navigationController?.pushViewController(modeVC, animated: true)
    }
    
    @objc func exitItemTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - ModeVC Delegate
    
    func modeViewController(_ modeViewController: ModeViewController, didSelect mode: Playlist) {
        modeTextField.attributedText = NSAttributedString.String(mode.modeName, font: .RLRegularLarge, color: .white)
    }
    
    
    // MARK: - TiersVC Delegate
    
    func tiersViewController(_ tiersViewController: TiersViewController, didChoose tier: Tier) {
        rankTextField.attributedText = NSAttributedString.String(tier.tierName, font: .RLRegularLarge, color: .white)
    }

    
    // MARK: - TextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == platformIDTextField {
            textField.returnKeyType = .done
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
