//
//  TiersViewController.swift
//  SteamGatherer
//
//  Created by Giancarlo on 09.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol TiersViewControllerDelegate: class {
    func tiersViewController(_ tiersViewController: TiersViewController, didChoose tier: Tier)
}

class TiersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: TiersViewControllerDelegate?
    
    let tiers = SessionManager.shared.tiers
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor.RL.main
        tv.register(TierCell.self)
        tv.separatorStyle = .none
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.RL.mainDarker
        
        view.fillToSuperview(tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TierCell.self, for: indexPath)
        let tier = tiers[indexPath.row]
        
        cell.configureWithModel(tier)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tiers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        let tier = tiers[indexPath.row]
        delegate?.tiersViewController(self, didChoose: tier)
        navigationController?.popViewController(animated: true)
    }
}

class TierCell: UITableViewCell, Configurable {
    
    var model: Tier?
    
    func configureWithModel(_ tier: Tier) {
        self.model = tier
        
        divisionImageView.image = UIImage(named: tier.tierName)
        divisionLabel.text = tier.tierName
    }
    
    let divisionImageView = UIImageView()
    let divisionLabel = Label(font: .RLRegularLarge, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.RL.mainDarker
        
        add(subview: divisionImageView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.widthAnchor.constraint(equalToConstant: 50),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        add(subview: divisionLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: divisionImageView.trailingAnchor, constant: 20)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

