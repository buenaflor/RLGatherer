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
    fileprivate let tableHeaderView = SideMenuHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 180))
    
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
    
    init(headerImage: UIImage, name: String, platform: String) {
        super.init(nibName: nil, bundle: nil)
        tableHeaderView.setData(image: headerImage, name: name, platform: platform)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.RL.main
        navigationController?.navigationBar.barTintColor = UIColor.RL.main
        navigationController?.setNavigationBarHidden(true, animated: true)
        
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
    
    private let avatarImageView = UIImageView()
    private let moreAccButton = UIButton()
    private let nameLabel = Label(font: .RLBoldLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    private let platformLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    private let avatarImageSize: CGFloat = 70
    private let buttonImageSize: CGFloat = 20
    
    private var rotated = false;
    
    fileprivate func setData(image: UIImage, name: String, platform: String) {
        self.avatarImageView.image = image
        self.nameLabel.text = name
        self.platformLabel.text = platform
        
        self.moreAccButton.setImage(#imageLiteral(resourceName: "RL_triangledown_50").withRenderingMode(.alwaysTemplate), for: .normal)
        self.moreAccButton.addTarget(self, action: #selector(moreAccButtonTapped), for: .touchUpInside)
        self.moreAccButton.tintColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.RL.mainDarkComplementary
        
        add(subview: avatarImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 15),
            v.heightAnchor.constraint(equalToConstant: avatarImageSize),
            v.widthAnchor.constraint(equalToConstant: avatarImageSize)
            ]}
        
        add(subview: nameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 15)
            ]}
        
        add(subview: platformLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 15)
            ]}
        
        add(subview: moreAccButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -15),
            v.widthAnchor.constraint(equalToConstant: buttonImageSize),
            v.heightAnchor.constraint(equalToConstant: buttonImageSize)
            ]}
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageSize / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func moreAccButtonTapped() {
        
        if !rotated {
            UIView.animate(withDuration: 0.3, animations: {
                self.moreAccButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            })
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                self.moreAccButton.transform = .identity
            })
        }
        
        rotated = !rotated
    }
}
