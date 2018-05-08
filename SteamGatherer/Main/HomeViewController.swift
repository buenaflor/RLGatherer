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
        tv.register(UITableViewCell.self)
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.RL.mainDarker
        return tv
    }()
    
    lazy var xboxButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(xboxButtonTapped(sender:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "RL_xbox_50").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    lazy var playstationButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(playstationButtonTapped(sender:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "RL_playstation_50").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    lazy var steamButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(steamButtonTapped(sender:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "RL_steam_50").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    lazy var filterButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "RL_filter_100").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    let tableViewContainerView = UIView()
    let steamContainerView = UIView()
    let playStationContainerView = UIView()
    let xboxContainerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.RL.mainDarker
        steamContainerView.backgroundColor = UIColor.RL.selectedGreen
        playStationContainerView.backgroundColor = UIColor.RL.mainDarkComplementary
        xboxContainerView.backgroundColor = UIColor.RL.mainDarkComplementary
        
//        view.add(subview: steamContainerView) { (v, p) in [
//            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
//            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
//            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.283),
//            v.heightAnchor.constraint(equalToConstant: 50)
//            ]}
//
//        view.add(subview: playStationContainerView) { (v, p) in [
//            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
//            v.leadingAnchor.constraint(equalTo: steamContainerView.trailingAnchor),
//            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.283),
//            v.heightAnchor.constraint(equalToConstant: 50)
//            ]}
//
//        view.add(subview: xboxContainerView) { (v, p) in [
//            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
//            v.leadingAnchor.constraint(equalTo: playStationContainerView.trailingAnchor),
//            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.283),
//            v.heightAnchor.constraint(equalToConstant: 50)
//            ]}
        
//        steamContainerView.add(subview: steamButton) { (v, p) in [
//            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
//            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
//            v.widthAnchor.constraint(equalToConstant: 30),
//            v.heightAnchor.constraint(equalToConstant: 30)
//            ]}
//
//        playStationContainerView.add(subview: playstationButton) { (v, p) in [
//            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
//            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
//            v.widthAnchor.constraint(equalToConstant: 30),
//            v.heightAnchor.constraint(equalToConstant: 30)
//            ]}
//
//        xboxContainerView.add(subview: xboxButton) { (v, p) in [
//            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
//            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
//            v.widthAnchor.constraint(equalToConstant: 30),
//            v.heightAnchor.constraint(equalToConstant: 30)
//            ]}
    
        
        view.fillToSuperview(tableView)
        
    }
    
    @objc func playstationButtonTapped(sender: UIButton) {
        playStationContainerView.backgroundColor = UIColor.RL.selectedGreen
        steamContainerView.backgroundColor = UIColor.RL.mainDarkComplementary
        xboxContainerView.backgroundColor = UIColor.RL.mainDarkComplementary
    }
    
    @objc func steamButtonTapped(sender: UIButton) {
        steamContainerView.backgroundColor = UIColor.RL.selectedGreen
        playStationContainerView.backgroundColor = UIColor.RL.mainDarkComplementary
        xboxContainerView.backgroundColor = UIColor.RL.mainDarkComplementary
    }
    
    @objc func xboxButtonTapped(sender: UIButton) {
        xboxContainerView.backgroundColor = UIColor.RL.selectedGreen
        steamContainerView.backgroundColor = UIColor.RL.mainDarkComplementary
        playStationContainerView.backgroundColor = UIColor.RL.mainDarkComplementary
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)

        return cell
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
    
    
    
    lazy var leftBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_burgermenu_50").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftBarItemTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: SideMenuViewController())
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.80), 240)
        
        navigationItem.leftBarButtonItem = leftBarItem
    }
    
    @objc func leftBarItemTapped() {
        print("Hey")
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
