//
//  SelectLanguageViewController.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/8/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class SelectLanguageViewController: AppViewController, AppNavigatorDisplayable {
    
    var leftBarButton: [BarButtonType] = [.cancel]
    
    var rightBarButton: [BarButtonType] = []
    
    var typeBar: NavigationBarType = .appDefault
    
    var disposeBag: DisposeBag = DisposeBag()

    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Declare
    
    var complete: ((_ index: Int)->Void) = {_ in}
    
    // MARK: - Define
    
    let idCell = "languageCell"
    
    // MARK: - Setup
    
    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - ViewController's life
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigation()
        self.setUpTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func initSelectLanguage(complete:@escaping ((_ index: Int)->Void)) -> UINavigationController? {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if let vc = storyBoard.instantiateViewController(withIdentifier: AppDefine.StoryBoardID.selectLang.rawValue) as? SelectLanguageViewController {
            vc.complete = complete
            let navi = UINavigationController.init(rootViewController: vc)
            return navi
        }
        return nil
    }

}

extension SelectLanguageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageSupport.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as? SelecLanguageTableViewCell {
            cell.lblTitle.text = LanguageSupport.all[indexPath.row].name
            cell.imgFlag.image = UIImage.init(named: LanguageSupport.all[indexPath.row].flag)
            return cell
        }
        return UITableViewCell()
    }
    
}

extension SelectLanguageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) { [weak self] in
            self?.complete(indexPath.row)
        }
    }
    
}

class SelecLanguageTableViewCell: UITableViewCell {
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
}
