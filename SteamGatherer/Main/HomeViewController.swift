//
//  HomeViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: MainController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(PlayerTableViewCell.self)
        tv.bounces = false
        tv.backgroundColor = UIColor.RL.mainDarker
        return tv
    }()
    
    lazy var platformImageView: UIImageView = {
        let iv = UIImageView()
        iv.setImage(#imageLiteral(resourceName: "RL_steam_50"), with: .alwaysTemplate, tintColor: .white)
        return iv
    }()
    
    lazy var searchTextField: InputTextField = {
        let tf = InputTextField()
        tf.backgroundColor = UIColor.RL.main
        tf.attributedPlaceholder = NSAttributedString(string: "Search for a player", attributes: [NSAttributedStringKey.font : UIFont.RLRegularLarge, NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.borderStyle = .none
        tf.tintColor = .white
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.RL.mainDarker
    
        view.add(subview: platformImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 15),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.heightAnchor.constraint(equalToConstant: 35),
            v.widthAnchor.constraint(equalToConstant: 35)
            ]}
        
        view.add(subview: searchTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: platformImageView.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 40)
            ]}
        
        view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -100)
            ]}
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(PlayerTableViewCell.self, for: indexPath)
        
        cell.configureWithModel("")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        
    }
}


class PlayerTableViewCell: UITableViewCell, Configurable {
    var model: String?
    
    func configureWithModel(_: String) {
        customImageView.image = #imageLiteral(resourceName: "Champ I")
        nameLabel.text = "ginooo"
        rankLabel.text = "Diamond II"
    }
    
    let customImageView = UIImageView()
    let nameLabel = Label(font: .RLBoldLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let rankLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.RL.mainDarker
        
        add(subview: customImageView) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.widthAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.6),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.6)
            ]}
        
        add(subview: nameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 20),
            ]}
        
        add(subview: rankLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 20)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MainController: UIViewController, Loadable {
    
    func loadData() {
        SessionManager.shared.start(call: RLClient.GetPlatforms(tag: "data/platforms", query: ["apikey" : BaseConfig.shared.apiKey])) { (result) in
            result.onSuccess { response in
                print("success")
                
                }.onError { err in
                    print(err)
            }
        }
    }
    
    lazy var rightBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_sort_50").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(rightBarItemTapped))
    lazy var leftBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_burgermenu_50").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftBarItemTapped))
    lazy var modeBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_people_50").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(modeBarItemTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: SideMenuViewController())
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.80), 240)
        
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.rightBarButtonItems = [ rightBarItem, modeBarItem ]
    }
    
    @objc func modeBarItemTapped() {
        let alertController = UIAlertController(title: "Choose a platform", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Steam", style: .default, handler: { (RL_) in
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Playstation", style: .default, handler: { (RL_) in
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Xbox", style: .default, handler: { (RL_) in
            
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func rightBarItemTapped() {
        let alertController = UIAlertController(title: "Choose a platform", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Steam", style: .default, handler: { (RL_) in
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Playstation", style: .default, handler: { (RL_) in
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Xbox", style: .default, handler: { (RL_) in
            
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func leftBarItemTapped() {
        print("Hey")
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
