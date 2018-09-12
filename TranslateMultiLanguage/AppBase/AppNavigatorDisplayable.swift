//
//  AppNavigatorDisplayable.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/7/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum BarButtonType {
    case menu
    case back
    case cancel
    case textButton(String)
    case imageButton(String)
    case none
}

enum NavigationBarType {
    case appDefault
    case transparent
    case hidden
}

protocol AppNavigatorDisplayable where Self: UIViewController {
    
    var leftBarButton: [BarButtonType] { get set }
    var rightBarButton: [BarButtonType] { get set }
    var typeBar: NavigationBarType { get set }
    var disposeBag: DisposeBag { get set }
    
    func setupNavigation() -> Void
    func barButtonTapped(typeButton: BarButtonType) -> Void
    
}

extension AppNavigatorDisplayable where Self: UIViewController {
    
    func setupNavigation() {
        
        switch typeBar {
        case .hidden:
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            break
        case .appDefault:
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.barTintColor = AppDefine.AppColor.primaryColor
            break
        case .transparent:
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.shadowImage = UIImage()
            break
        }
        
        guard typeBar != .hidden else {
            return
        }
        
        let leftBarItems = getBarItems(barButtonTypes: leftBarButton)
        let rightBarItems = getBarItems(barButtonTypes: rightBarButton)
        
        navigationItem.leftBarButtonItems = leftBarItems
        navigationItem.rightBarButtonItems = rightBarItems
        
    }
    
    func getBarItems(barButtonTypes: [BarButtonType]) -> [UIBarButtonItem] {
        var items: [UIBarButtonItem] = []
        for barButton in barButtonTypes {
            switch barButton {
            case .back:
                let btn = UIBarButtonItem.init()
                btn.image = #imageLiteral(resourceName: "Path")
                btn.rx.tap.bind { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.barButtonTapped(typeButton: barButton)
                    }.disposed(by: disposeBag)
                items.append(btn)
                break
            case .cancel:
                let btn = UIBarButtonItem.init()
                btn.image = #imageLiteral(resourceName: "Path")
                btn.rx.tap.bind { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.barButtonTapped(typeButton: barButton)
                    }.disposed(by: disposeBag)
                items.append(btn)
                break
            case .menu:
                let btn = UIBarButtonItem.init()
                btn.image = UIImage()
                btn.rx.tap.bind { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.barButtonTapped(typeButton: barButton)
                    }.disposed(by: disposeBag)
                items.append(btn)
                break
            case .none:
                break
            case .textButton(let title):
                let btn = UIBarButtonItem.init()
                btn.title = title
                btn.rx.tap.bind { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.barButtonTapped(typeButton: barButton)
                    }.disposed(by: disposeBag)
                items.append(btn)
                break
            case .imageButton(let imageName):
                let btn = UIBarButtonItem.init()
                btn.image = UIImage.init(named: imageName)
                btn.rx.tap.bind { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.barButtonTapped(typeButton: barButton)
                    }.disposed(by: disposeBag)
                items.append(btn)
                break
            }
        }
        return items
    }
    
    func barButtonTapped(typeButton: BarButtonType) {
        switch typeButton {
        case .back:
            self.navigationController?.popViewController(animated: true)
            break
        case .cancel:
            self.dismiss(animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
}

