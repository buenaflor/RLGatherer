//
//  PlayerViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 09.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

enum PresentationStyle {
    case present
    case push
}

class PlayerViewController: UIViewController, Configurable {
    
    var model: Player?

    func configureWithModel(_ player: Player) {
        self.model = player
        
        self.platformImageView.setImage(UIImage(named: player.platform)!, with: .alwaysTemplate, tintColor: .white)
    }
    
    let headerView = UIView()
    let platformImageView = UIImageView()
    
    let platformImageSize: CGFloat = 30
    
    init(presentationStyle: PresentationStyle) {
        super.init(nibName: nil, bundle: nil)
        if presentationStyle == .present {
            let exitBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RL_exit_50"), style: .plain, target: self, action: #selector(exitItemTapped))
            navigationItem.rightBarButtonItem = exitBarButtonItem
        }
    }
    
    @objc func exitItemTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.RL.mainDarker
        
        view.add(subview: headerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.25)
            ]}
        
        headerView.add(subview: platformImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.heightAnchor.constraint(equalToConstant: platformImageSize),
            v.widthAnchor.constraint(equalToConstant: platformImageSize)
            ]}
        
//        headerView.backgroundColor = .white
    }
}
