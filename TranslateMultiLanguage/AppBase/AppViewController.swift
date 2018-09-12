//
//  AppViewController.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/11/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AppViewController: UIViewController, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!
    
    func setInterstitial() {
        
        let period = Date().timeIntervalSince1970 - AppDefine.timeInterstitialAppear
        if AppDefine.numberOfSwitchScreen >= 5 && period > 180 {
            AppDefine.numberOfSwitchScreen = 1
            AppDefine.timeInterstitialAppear = Date().timeIntervalSince1970
            interstitial = GADInterstitial.init(adUnitID: AppDefine.AdMod.interstitialId.rawValue)
            interstitial.delegate = self
            interstitial.load(GADRequest.init())
        } else if AppDefine.numberOfSwitchScreen < 5 {
            AppDefine.numberOfSwitchScreen += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInterstitial()
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }

}
