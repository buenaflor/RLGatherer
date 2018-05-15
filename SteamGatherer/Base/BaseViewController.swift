//
//  BaseViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 11.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(activityIndicatorStyle: .white)
        av.startAnimating()
        av.hidesWhenStopped = true
        return av
    }()
    
    lazy var activityIndicatorItem: UIBarButtonItem = {
        let btn = UIBarButtonItem(customView: self.activityIndicator)
        return btn
    }()
}
