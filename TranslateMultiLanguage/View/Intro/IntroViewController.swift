//
//  IntroViewController.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/9/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit
import RxSwift

class IntroViewController: AppViewController, AppNavigatorDisplayable {
    
    var leftBarButton: [BarButtonType] = [.cancel]
    
    var rightBarButton: [BarButtonType] = []
    
    var typeBar: NavigationBarType = .appDefault
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Outlet
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnRate: UIButton!
    
    // MARK: - Declare
    
    // MARK: - Define
    
    // MARK: - Setup
    
    // MARK: - ViewController's life

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func share(_ sender: Any) {
        if let vc = Utils.showShareApp(sender: sender as! UIButton) {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func rate(_ sender: Any) {
        Utils.rateAppOnAppStore()
    }
    
    
}
