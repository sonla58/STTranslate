//
//  AppSetting.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/7/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import GoogleMobileAds

struct AppSeting {
    
    // Singleton
    static let share = AppSeting()
    
    func setupkeyBoard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func setupUI() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setupAdMob() {
        GADMobileAds.configure(withApplicationID: AppDefine.AdMod.appID.rawValue)
    }
    
}

