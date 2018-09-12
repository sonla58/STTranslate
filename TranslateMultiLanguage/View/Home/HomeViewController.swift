//
//  HomeViewController.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/7/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CropViewController
import SVProgressHUD
import GoogleMobileAds

class HomeViewController: AppViewController, AppNavigatorDisplayable, AdBannerDisplayable, GADBannerViewDelegate {
    
    var bannerView: GADBannerView = GADBannerView.init(adSize: kGADAdSizeSmartBannerPortrait)
    
    func contraintForBottomApp() -> NSLayoutConstraint? {
        return bottomSuperViewContraint
    }
    
    
    // MARK: - Conform AppNavigatorDisplayable
    
    var leftBarButton: [BarButtonType] = []
    
    var rightBarButton: [BarButtonType] = []
    
    var typeBar: NavigationBarType = .hidden
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Outlet
    
    @IBOutlet weak var btnSourceSelect: UIButton!
    @IBOutlet weak var btnTargetSelect: UIButton!
    @IBOutlet weak var switchLanguage: UIButton!
    @IBOutlet weak var imgSource: UIImageView!
    @IBOutlet weak var imgTarget: UIImageView!
    
    @IBOutlet weak var sourceView: UIView!
    @IBOutlet weak var targetView: UIView!
    
    @IBOutlet weak var imgSourceLanguage: UIImageView!
    @IBOutlet weak var tfTranslateSource: UITextField!
    @IBOutlet weak var btnTranslate: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnTools: UIButton!
    @IBOutlet weak var btnSpeak: UIButton!
    @IBOutlet weak var btnDeleteHistory: UIButton!
    @IBOutlet weak var btnIntro: UIButton!
    
    @IBOutlet weak var bottomSuperViewContraint: NSLayoutConstraint!
    
    // MARK: - Declare
    
    // Service
    let service = TranslateService.init()
    
    // Variable
    var viewModel = TranslateViewModel.init()
    var isTranslating = BehaviorRelay<Bool>.init(value: false)
    
    var dataSource: [Translate] = []
    
    // MARK: - Define
    
    let cellID = "HomeTableViewCell"
    
    // MARK: - Setup
    
    func setUpView() {
        sourceView.layer.cornerRadius = sourceView.bounds.size.height / 2
        targetView.layer.cornerRadius = targetView.bounds.size.height / 2
        switchLanguage.imageView?.contentMode = .scaleAspectFit
        tableView.register(UINib.init(nibName: cellID, bundle: Bundle.main), forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setObserve() {
        
        // Target
        btnSourceSelect.addTarget(self, action: #selector(showSelectSource), for: .touchUpInside)
        btnTargetSelect.addTarget(self, action: #selector(showSelectTarget), for: .touchUpInside)
        switchLanguage.addTarget(self, action: #selector(switchSource), for: .touchUpInside)
        btnTranslate.addTarget(self, action: #selector(translate), for: .touchUpInside)
        btnSpeak.addTarget(self, action: #selector(showSpeechToText), for: .touchUpInside)
        btnDeleteHistory.addTarget(self, action: #selector(deleteAllHistory), for: .touchUpInside)
        btnTools.addTarget(self, action: #selector(orc), for: .touchUpInside)
        
        // Observer
        
        viewModel.route.bind { [weak self] (route) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.btnSourceSelect.setTitle(route.0.name, for: .normal)
            strongSelf.imgSource.image = UIImage.init(named: route.0.flag)
            strongSelf.btnTargetSelect.setTitle(route.1.name, for: .normal)
            strongSelf.imgTarget.image = UIImage.init(named: route.1.flag)
            strongSelf.imgSourceLanguage.image = UIImage.init(named: route.0.flag)
            AppAccess.shared.saveRoute(srcLang: route.0, tarLang: route.1)
        }.disposed(by: self.disposeBag)
        
        viewModel.sourceText.bind(to: tfTranslateSource.rx.text).disposed(by: self.disposeBag)
        tfTranslateSource.rx.text.asObservable().map({$0 ?? ""}).bind(to: viewModel.sourceText).disposed(by: self.disposeBag)
        
        tfTranslateSource.addDoneOnKeyboardWithTarget(self, action: #selector(translate))
        
    }
    
    // MARK: - ViewController's life
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setUpView()
        setObserve()
        setBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showSelectSource() {
        if let navi = SelectLanguageViewController.initSelectLanguage(complete: { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.route.accept((LanguageSupport.all[index], strongSelf.viewModel.route.value.1))
        }) {
            self.present(navi, animated: true, completion: nil)
        }
    }
    
    @objc func showSelectTarget() {
        if let navi = SelectLanguageViewController.initSelectLanguage(complete: { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.route.accept((strongSelf.viewModel.route.value.0, LanguageSupport.all[index]))
        }) {
            self.present(navi, animated: true, completion: nil)
        }
    }
    
    @objc func switchSource() {
        let source = self.viewModel.route.value.0
        let target = self.viewModel.route.value.1
        viewModel.route.accept((target, source))
    }
    
    @objc func translate() {
        self.view.endEditing(true)
        if viewModel.sourceText.value.isBlank {
            return
        }
        if !Utils.isInternetAvailable() {
            let vc = Utils.showAlertDefault(NSLocalizedString("Không có kết nối", comment: "Không có kết nối"), message: NSLocalizedString("Vui lòng kiểm tra kết nối Internet", comment: "Vui lòng kiểm tra kết nối Internet"), buttons: [NSLocalizedString("Đóng", comment: "Đóng")], completed: nil)
            self.present(vc, animated: true, completion: nil)
            return
        }
        isTranslating.accept(true)
        let source = viewModel.route.value.0
        let target = viewModel.route.value.1
        SVProgressHUD.show(withStatus: NSLocalizedString("Đang dịch", comment: "Đang dịch"))
        service.translateText(text: viewModel.sourceText.value, sourceLang: source.id, targetlang: target.id) { [weak self] (success, result) in
            SVProgressHUD.dismiss()
            guard let strongSelf = self else {
                return
            }
            strongSelf.isTranslating.accept(false)
            if success {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.viewModel.resultLatinText.accept(result.1)
                    strongSelf.viewModel.resultText.accept(result.0)
                    let model = strongSelf.saveHistory()
                    strongSelf.dataSource.insert(model, at: 0)
                    strongSelf.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableViewRowAnimation.middle)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.viewModel.resultLatinText.accept("")
                    strongSelf.viewModel.resultText.accept("")
                }
            }
        }
    }
    
    func saveHistory() -> Translate {
        let model = self.viewModel.getModel()
        DatabaseService.shared.addHistory(translate: model)
        return model
    }
    
    func loadData() {
        dataSource = DatabaseService.shared.getHistoryList()
        self.tableView.reloadData()
    }
    
    @objc func showSpeechToText() {
        _ = SpeechToTextViewController.show(in: self, withLanguage: self.viewModel.route.value.0.local) { [weak self] (result) in
            self?.viewModel.sourceText.accept((self?.viewModel.sourceText.value ?? "") + " " + result)
        }
    }
    
    @objc func deleteAllHistory() {
        let alert = Utils.showActions(with: NSLocalizedString("Xoá toàn bộ lịch sử dịch?", comment: "Xoá toàn bộ lịch sử dịch?"), buttons: [NSLocalizedString("Xoá", comment: "Xoá")]) { [weak self] (_) in
            DatabaseService.shared.deleteAll()
            self?.loadData()
        }
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.btnDeleteHistory
            presenter.sourceRect = self.btnDeleteHistory.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func orc() {
        ImagePicker.sharedInstance.pickImageWithPreferedCameraDevice(UIImagePickerControllerCameraDevice.rear, parent: self, sourceView: self.btnTools, resize: CGSize.zero) { (image) in
            let cropVC = CropViewController.init(croppingStyle: CropViewCroppingStyle.default, image: image)
            cropVC.delegate = self
            self.present(cropVC, animated: true, completion: nil)
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.animateBanner()
    }

}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? HomeTableViewCell {
            let data = dataSource[indexPath.row]
            cell.setCell(for: data)
            return cell
        }
        return UITableViewCell()
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
}

extension HomeViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let precessedImage = image.toGrayScale().binarise().scaleImage()
        ORCService.shared.recognize(image: precessedImage, lang: self.viewModel.route.value.0, complete: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.sourceText.accept((self?.viewModel.sourceText.value ?? "") + " " + result)
        })
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
