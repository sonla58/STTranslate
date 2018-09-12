//
//  FavoriteViewController.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/9/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMobileAds

class FavoriteViewController: AppViewController, AppNavigatorDisplayable, AdBannerDisplayable, GADBannerViewDelegate {
    var bannerView: GADBannerView = GADBannerView.init(adSize: kGADAdSizeSmartBannerPortrait)
    
    func contraintForBottomApp() -> NSLayoutConstraint? {
        return bottomSuperViewContraint
    }
    
    
    var leftBarButton: [BarButtonType] = [.cancel]
    
    var rightBarButton: [BarButtonType] = []
    
    var typeBar: NavigationBarType = .appDefault
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomSuperViewContraint: NSLayoutConstraint!
    
    // MARK: - Declare
    
    var dataSource: [Translate] = []
    
    // MARK: - Define
    
    let idCell = "HomeTableViewCell"
    
    // MARK: - Setup
    
    func setView() {
        self.title = NSLocalizedString("Yêu thích", comment: "Yêu thích")
        tableView.register(UINib.init(nibName: idCell, bundle: Bundle.main), forCellReuseIdentifier: idCell)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - ViewController's life

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigation()
        self.setView()
        loadData()
        setBanner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        dataSource = DatabaseService.shared.getHistoryList().filter({$0.isFav})
        tableView.reloadData()
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.animateBanner()
    }

}

extension FavoriteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as? HomeTableViewCell {
            cell.setCell(for: dataSource[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
    
}
