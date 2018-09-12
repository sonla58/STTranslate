//
//  AppDefine.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/7/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit

struct AppDefine {
    static let version = 1
    static var developtMode = true
    
    /// AppID on appstore
    static let appId = "id1365325028"
    
    static var numberOfSwitchScreen = 2
    static var timeInterstitialAppear = 0.0
    
    struct AppColor {
        static var primaryColor = UIColor.init(red: 73/255, green: 177/255, blue: 80/255, alpha: 1)
    }
    
    enum AdMod: String {
        
        case appID = "ca-app-pub-3940256099942544~3347511713"
        case bannerId = "ca-app-pub-3940256099942544/6300978111"
        case interstitialId = "ca-app-pub-3940256099942544/1033173712"
        
        var id: String {
            get {
                switch self {
                case .appID:
                    return self.rawValue
                case .bannerId:
                    if AppDefine.developtMode {
                        return "ca-app-pub-3940256099942544/2934735716"
                    } else {
                        return self.rawValue
                    }
                case .interstitialId:
                    if AppDefine.developtMode {
                        return "ca-app-pub-3940256099942544/4411468910"
                    } else {
                        return self.rawValue
                    }
                }
            }
        }
        
    }
    
    enum StoryBoardID: String {
        case selectLang = "SelectLanguageViewController"
    }
    
    enum Segue: String {
        case splashToHome = "splashToHome"
    }
    
}


