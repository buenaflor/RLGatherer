//
//  Shared.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class BaseConfig {
    static let shared = BaseConfig()
    
    var baseURL: URL {
        return URL(string: "https://api.rocketleaguestats.com/v1/")!
    }
}

// MARK: - Custom Fonts

extension UIFont {
    public class var RLBlack: UIFont {
        return UIFont(name: "DINPro-Black", size: 15.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightBlack)
    }
    public class var RLBlackLarge: UIFont {
        return UIFont(name: "DINPro-Black", size: 20.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightBlack)
    }
    public class var RLBold: UIFont {
        return UIFont(name: "DINPro-Bold", size: 15.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightBold)
    }
    public class var RLBoldLarge: UIFont {
        return UIFont(name: "DINPro-Bold", size: 20.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightBold)
    }
    public class var RLBoldExtraLarge: UIFont {
        return UIFont(name: "DINPro-Bold", size: 30.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightBold)
    }
    public class var RLLight: UIFont {
        return UIFont(name: "DINPro-Light", size: 15.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightLight)
    }
    public class var RLMedium: UIFont {
        return UIFont(name: "DINPro-Medium", size: 15.0)!// ?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightMedium)
    }
    public class var RLRegular: UIFont {
        return UIFont(name: "DINPro-Regular", size: 15.0)! //?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightRegular)
    }
    public class var RLRegularMedium: UIFont {
        return UIFont(name: "DINPro-Regular", size: 17.5)! //?? UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightRegular)
    }
    public class var RLRegularLarge: UIFont {
        return UIFont(name: "DINPro-Regular", size: 20.0)!
    }
}
