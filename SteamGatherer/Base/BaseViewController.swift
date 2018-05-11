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
        return av
    }()
}
