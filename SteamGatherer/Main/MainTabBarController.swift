//
//  MainTabBarController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import FirebaseAuth
//import SideMenu

class TabBarPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate ,UIScrollViewDelegate, EditProfileViewControllerDelegate {
    
    // Declare it outside of orderedVC so we can call loadData
    lazy var mainVC = HomeViewController()
    lazy var groupVC = GroupViewController()
    
    lazy var mainVCWrapped = mainVC.wrapped()
    lazy var groupVCWrapped = groupVC.wrapped()
    
    let tabbarView = UIView()
    
    var vcIndex = 0
    var lastPosition: CGFloat = 0
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [ mainVCWrapped, groupVCWrapped ]
    }()
    
    lazy var tabbarStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [homeButton, chatGroupButton])
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var homeButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(homeButtonTapped(sender:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "RL_rocket_50").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    lazy var chatGroupButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(watchListButtonTapped(sender:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "RL_group_50").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .lightGray
        return btn
    }()
    
    let coverView = UIView()
    let informationLabel = Label(font: .RLRegularLarge, textAlignment: .center, textColor: .white, numberOfLines: 0)
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Set newUser to false if successfully filled out information
        if SessionManager.shared.newUser {
            
            // Block UI as long as user didnt update information
            coverView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverViewTapped)))
            
            informationLabel.text = "Tap anywhere to add the rest of your data and start matching right away!"
            
            view.fillToSuperview(coverView)
            view.bringSubview(toFront: coverView)
            
            showAlert(title: "Success", message: "Before you can start matching, fill in the rest of your profile information.\nHappy Gathering!") {
                
                self.coverView.add(subview: self.informationLabel) { (v, p) in [
                    v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
                    v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
                    v.centerYAnchor.constraint(equalTo: p.centerYAnchor)
                    ]}
            }
        }
    }
    
    func editProfileViewControllerUpdatedSuccess(_ editProfileViewController: EditProfileViewController) {
        coverView.removeFromSuperview()
        informationLabel.removeFromSuperview()
        
    }
    
    @objc func coverViewTapped() {
        
        // Present User profile
        let editProfileVC = EditProfileViewController()
        editProfileVC.loadData()
        editProfileVC.delegate = self
        self.mainVC.present(editProfileVC.wrapped(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            scrollView.delegate = self
        }
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        tabbarView.backgroundColor = UIColor.RL.mainDarkComplementary
        
        view.add(subview: tabbarView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 60)
            ]}
        
        tabbarView.fillToSuperview(tabbarStackView)
    }
    
    @objc func watchListButtonTapped(sender: UIButton) {
        vcIndex = 1
        chatGroupButton.tintColor = .white
        homeButton.tintColor = .lightGray
        setViewControllers([orderedViewControllers[vcIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func homeButtonTapped(sender: UIButton) {
        vcIndex = 0
        chatGroupButton.tintColor = .lightGray
        homeButton.tintColor = .white
        setViewControllers([orderedViewControllers[vcIndex]], direction: .reverse, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if previousViewControllers.first != mainVCWrapped {
                chatGroupButton.tintColor = .lightGray
                homeButton.tintColor = .white
            }
            else {
                chatGroupButton.tintColor = .white
                homeButton.tintColor = .lightGray
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
