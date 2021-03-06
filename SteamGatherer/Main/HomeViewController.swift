//
//  HomeViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage
import SideMenu

class HomeViewController: MainController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    let barContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.RL.mainDarkHighlight
        return view
    }()
    
    let rankDescLabel = Label(font: .RLRegularMedium, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let playerDescLabel = Label(font: .RLRegularMedium, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let gameDescLabel = Label(font: .RLRegularMedium, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let actionDescLabel = Label(font: .RLRegularMedium, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        rankDescLabel.text = "Rank"
        playerDescLabel.text = "Player"
        gameDescLabel.text = "Mode"
        actionDescLabel.text = "Gather Action"
        
        view.backgroundColor = UIColor.RL.mainDarker
        
        navigationItem.searchController = searchController
        
        view.add(subview: barContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 30)
            ]}
        
        barContainerView.add(subview: rankDescLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]}
        
        barContainerView.add(subview: playerDescLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: rankDescLabel.trailingAnchor, constant: 17)
            ]}
        
        barContainerView.add(subview: gameDescLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: playerDescLabel.trailingAnchor, constant: 60)
            ]}
        
        barContainerView.add(subview: actionDescLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: gameDescLabel.trailingAnchor, constant: 40)
            ]}
        
        view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: barContainerView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -100)
            ]}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(PlayerTableViewCell.self, for: indexPath)
        let player = players[indexPath.row]
        
        cell.configureWithModel(player)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        let player = players[indexPath.row]
        
        let playerVC = PlayerViewController(presentationStyle: .push)
        playerVC.configureWithModel(player)
        navigationController?.pushViewController(playerVC, animated: true)
    }
}


class PlayerTableViewCell: UITableViewCell, Configurable {
    var model: Player?
    
    func configureWithModel(_ player: Player) {
        customImageView.image = UIImage(named: player.rank)
        nameLabel.text = player.name
        rankLabel.text = player.shortedTierName
        modeLabel.text = player.shortedMode
        platformLabel.text = player.platform
        gatherLabel.text = player.gatherAction
    }
    
    let customImageView = UIImageView()
    let nameLabel = Label(font: .RLBoldLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let rankLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let modeLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let platformLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let gatherLabel = Label(font: .RLBoldLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
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
        
        add(subview: modeLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            ]}
        
        add(subview: platformLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: modeLabel.bottomAnchor),
            v.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            ]}
        
        add(subview: rankLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: modeLabel.leadingAnchor)
            ]}
        
        add(subview: gatherLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -42)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MainController: BaseViewController, Loadable {
    
    var players = [Player]()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(PlayerTableViewCell.self)
        tv.bounces = false
        tv.backgroundColor = UIColor.RL.mainDarker
        tv.tableFooterView = UIView()
        return tv
    }()
    
    func loadData() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        FirebaseManager.shared.fetchCurrentUser(uid: (userUID)) { (player, err) in
            if let err = err {
                self.showAlert(title: "Error", message: err.localizedDescription, completion: {})
            }
            else {
                guard let player = player else { return }
                
                SessionManager.shared.start(call: RLClient.GetPlayer(tag: "player", query: ["apikey": BaseConfig.shared.apiKey, "unique_id": "76561198118155495", "platform_id": "1"]), completion: { (result) in
                    result.onSuccess { value in
                        let playerData = value.player
                        
                        FirebaseManager.shared.fetchUsers(uid: userUID, completion: { (players, err) in
                            if let err = err {
                                print(err.localizedDescription)
                            }
                            else {
                                
                                if let players = players {
                                    self.players = players
                                    self.tableView.reloadData()
                                }
                                
                                if let avatarURLString = playerData.avatar {
                                    SDWebImageDownloader.shared().downloadImage(with: URL(string: avatarURLString)!, options: SDWebImageDownloaderOptions.lowPriority, progress: nil, completed: { (image, data, err, finished) in
                                        if let image = image {
                                            if finished {
                                                let sideMenuVC = SideMenuViewController(headerImage: image, name: playerData.displayName, platform: playerData.platform.name)
                                                let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideMenuVC)
                                                SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
                                                SideMenuManager.default.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.80), 240)
                                                
                                                self.navigationItem.leftBarButtonItem = self.leftBarItem
                                                self.navigationItem.rightBarButtonItems = [ self.rightBarItem, self.modeBarItem ]
                                            }
                                        }
                                    })
                                }
                            }
                        })
                        
                 
                        }.onError { err in
                            self.showAlert(title: "Error", message: err.localizedDescription, completion: {})
                    }
                })
            }
        }
    }
    
    var currentUserImage = UIImage()
    var currentPlatform = "Steam"
    
    lazy var rightBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_sort_50").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(rightBarItemTapped))
    lazy var leftBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_burgermenu_50").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftBarItemTapped))
    lazy var modeBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_people_50").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(modeBarItemTapped))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func modeBarItemTapped() {
        let modeVC = ModeViewController(currentPlatform: currentPlatform, presentationStyle: .present)
        present(modeVC.wrapped(), animated: true, completion: nil)
    }
    
    @objc func rightBarItemTapped() {
        let alertController = UIAlertController(title: "Choose a platform", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Steam", style: .default, handler: { (RL_) in
            self.currentPlatform = "Steam"
        }))
        
        alertController.addAction(UIAlertAction(title: "PS4", style: .default, handler: { (RL_) in
            self.currentPlatform = "PS4"
        }))
        
        alertController.addAction(UIAlertAction(title: "XboxOne", style: .default, handler: { (RL_) in
            self.currentPlatform = "XboxOne"
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func leftBarItemTapped() {

        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
