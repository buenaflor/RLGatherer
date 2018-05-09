//
//  ModeViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 09.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class ModeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var exitItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_exit_50").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(exitItemTapped))
    
    lazy var modeBarItem = UIBarButtonItem(title: "Choose Platform", style: .plain, target: self, action: #selector(modeBarItemTapped))
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(ModeCell.self)
        tv.separatorStyle = .none
        tv.bounces = false
        tv.backgroundColor = UIColor.RL.main
        return tv
    }()
    
    let titleView = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    var playlists = [Playlist]()
    var filteredPlaylists = [Playlist]()
    
    init(currentPlatform: String) {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.titleView = self.titleView
        titleView.text = currentPlatform
        
        SessionManager.shared.start(call: RLClient.GetPlaylists(tag: "data/playlists", query: ["apikey": BaseConfig.shared.apiKey])) { (result) in
            result.onSuccess { value in
                
                self.playlists = value.playlists.filter({ (playlist) -> Bool in
                    if playlist.name.contains("Ranked") {
                        return false
                    }
                    return true
                })
                
                self.filteredPlaylists = value.playlists.filter({ (playlist) -> Bool in
                    if playlist.name.contains("Ranked") || playlist.platformName != currentPlatform  {
                        return false
                    }
                    return true
                })
                self.tableView.reloadData()
                }.onError { err in
                    print(err)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.RL.mainDarker
        
        navigationItem.rightBarButtonItem = exitItem
        navigationItem.leftBarButtonItem = modeBarItem
        
        modeBarItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.RLRegularLarge], for: .normal)
        
        view.fillToSuperview(tableView)
    }
    
    @objc func exitItemTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ModeCell.self, for: indexPath)
        let playlist = filteredPlaylists[indexPath.row]
        
        cell.configureWithModel(playlist)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlaylists.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func modeBarItemTapped() {
        let alertController = UIAlertController(title: "Choose a platform", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Steam", style: .default, handler: { (RL_) in
            self.filteredPlaylists = self.playlists.filter({ (playlist) -> Bool in
                if playlist.platformName == "Steam" {
                    return true
                }
                return false
            })
            self.titleView.text = "Steam"
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "PS4", style: .default, handler: { (RL_) in
            self.filteredPlaylists = self.playlists.filter({ (playlist) -> Bool in
                if playlist.platformName == "PS4" {
                    return true
                }
                return false
            })
            self.titleView.text = "PS4"
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "XboxOne", style: .default, handler: { (RL_) in
            self.filteredPlaylists = self.playlists.filter({ (playlist) -> Bool in
                if playlist.platformName == "XboxOne" {
                    return true
                }
                return false
            })
            self.titleView.text = "XboxOne"
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "All", style: .default, handler: { (RL_) in
            self.titleView.text = "All"
            self.filteredPlaylists = self.playlists
            self.tableView.reloadData()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}

class ModeCell: UITableViewCell, Configurable {
    
    var model: Playlist?
    
    func configureWithModel(_ playlist: Playlist) {
        self.model = playlist
        
        modeLabel.text = playlist.modeName
        platformLabel.text = playlist.platformName
    }
    
    let modeLabel = Label(font: .RLBoldLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let platformLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let populationLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.RL.mainDarker
        
        
        add(subview: modeLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]}
        
        add(subview: platformLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: modeLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
