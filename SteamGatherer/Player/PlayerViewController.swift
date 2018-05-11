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

class PlayerViewController: UIViewController, Loadable {
    
    func loadData() {
        
    }
    
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
    }
}
