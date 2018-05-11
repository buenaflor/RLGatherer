//
//  SideMenuViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 08.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import FirebaseAuth

fileprivate enum SideMenuOptions {
    case settings
}

extension SideMenuOptions {
    
    var text: String {
        switch self {
        case .settings:
            return "Settings"
        }
    }
    
    static let all: [SideMenuOptions] = [ .settings ]
}

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var allOptions = SideMenuOptions.all
    fileprivate let tableHeaderView = SideMenuHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 200))
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self)
        tv.backgroundColor = UIColor.RL.main
        tv.bounces = false
        tv.tableFooterView = UIView()
        tv.tableHeaderView = tableHeaderView
        return tv
    }()
    
    init(headerImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        tableHeaderView.avatarImageView.image = headerImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.RL.main
        navigationController?.navigationBar.barTintColor = UIColor.RL.main
        
        view.fillToSuperview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        let option = allOptions[indexPath.row]
        
        cell.textLabel?.text = option.text
        
        return cell
    }
    
    
}

fileprivate class SideMenuHeader: UIView {
    
    var avatarImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.RL.mainDarkComplementary
        
        add(subview: avatarImageView) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 15),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.heightAnchor.constraint(equalToConstant: 50),
            v.widthAnchor.constraint(equalToConstant: 50)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
