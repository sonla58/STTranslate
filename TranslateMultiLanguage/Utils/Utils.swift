//
//  Utils.swift
//  Translate_cn-vi
//
//  Created by Anh Son Le on 6/27/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

struct Utils {
    
    static func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.topViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let child = base?.childViewControllers.last {
            return topViewController(child)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
    
    static func showActions(with title: String?, buttons: [String], completionHandle: ((_ index: Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        for (index, title) in buttons.enumerated() {
            alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: { (action) in
                completionHandle?(index)
                print("index: \(index)")
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        return alert
    }
    
    static func showAlertDefault(_ title: String?, message: String?, buttons: [String], completed:((_ index: Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        if buttons.count == 1 {
            alert.addAction(UIAlertAction(title: buttons[0], style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
                completed?(0)
            }))
        } else if buttons.count > 1 {
            for (index, title) in buttons.enumerated() {
                alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                    completed?(index)
                }))
            }
        }
        return alert
    }
    
    static func openSeting() {
        if let settingsUrl = URL.init(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    static func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    static func showShareApp(sender: UIView) -> UIActivityViewController? {
        let shareText = "Dịch tiếng Anh - Dịch đa ngôn ngữ"
        if let url = URL.init(string: "https://itunes.apple.com/app/\(AppDefine.appId)") {
            let vc = UIActivityViewController.init(activityItems: [shareText, url], applicationActivities: [])
            if let presenter = vc.popoverPresentationController {
                presenter.sourceView = sender
                presenter.sourceRect = sender.bounds
            }
            return vc
        }
        return nil
    }
    
    static func shareText(text: String) -> UIActivityViewController {
        let vc = UIActivityViewController.init(activityItems: [text], applicationActivities: [])
        return vc
    }
    
    static func rateAppOnAppStore() {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + AppDefine.appId + "?action=write-review") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}

extension String {
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
}

extension UIView{
    var showToastTag :Int {return 999}
    
    //Generic Show toast
    func showToast(message : String, duration:TimeInterval) {
        
        let toastLabel = UILabel(frame: CGRect(x:0, y:0, width: (self.frame.size.width)-60, height: 44))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 0
//        toastLabel.layer.borderColor = UIColor.lightGray.cgColor
//        toastLabel.layer.borderWidth = 1.0
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "HelveticaNeue", size: 14.0)
        toastLabel.text = message
        toastLabel.center = CGPoint.init(x: self.center.x, y: self.center.y * 1.5)
        toastLabel.isEnabled = true
        toastLabel.alpha = 0.99
        toastLabel.tag = showToastTag
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.95
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    //Generic Hide toast
    func hideToast(){
        if let view = self.viewWithTag(self.showToastTag){
            view.removeFromSuperview()
        }
    }
}
