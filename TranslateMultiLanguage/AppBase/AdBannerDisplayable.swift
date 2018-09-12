//
//  AdBannerDisplayable.swift
//  Translate_cn-vi
//
//  Created by Anh Son Le on 7/2/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol AdBannerDisplayable where Self: GADBannerViewDelegate {
    
    var bannerView: GADBannerView { get set }
    
    func contraintForBottomApp() -> NSLayoutConstraint?
    
    func setBanner()
    func animateBanner()
}

extension AdBannerDisplayable where Self: UIViewController {
    func setBanner() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.rootViewController = self
        bannerView.adUnitID = AppDefine.AdMod.bannerId.id
        bannerView.bounds.size.height = 1
        bannerView.delegate = (self as! GADBannerViewDelegate)
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
        bannerView.load(GADRequest.init())
    }
    
    func animateBanner() {
        self.bannerView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.bannerView.bounds.size.height == 1 {
                strongSelf.contraintForBottomApp()?.constant += 50
            }
            strongSelf.bannerView.bounds.size.height = 50
            strongSelf.view.layoutIfNeeded()
        }
    }
    
    func animateHideBanner() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.bannerView.bounds.size.height == 50 {
                strongSelf.contraintForBottomApp()?.constant -= 50
            }
            strongSelf.bannerView.bounds.size.height = 1
            strongSelf.view.layoutIfNeeded()
        }) { [weak self] (_) in
            self?.bannerView.isHidden = true
        }
    }
    
}
