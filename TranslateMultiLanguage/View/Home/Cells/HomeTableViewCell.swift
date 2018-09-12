//
//  HomeTableViewCell.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/7/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var imgSource: UIImageView!
    @IBOutlet weak var imgTarget: UIImageView!
    @IBOutlet weak var lblSourceLang: UILabel!
    @IBOutlet weak var lblTargetLang: UILabel!
    @IBOutlet weak var lblSourceText: UILabel!
    @IBOutlet weak var lblResultText: UILabel!
    
    @IBOutlet weak var btnSrcCopy: UIButton!
    @IBOutlet weak var btnSrcShare: UIButton!
    @IBOutlet weak var btnSrcSpeaker: UIButton!
    @IBOutlet weak var btnSrcDelete: UIButton!
    
    @IBOutlet weak var btnResCopy: UIButton!
    @IBOutlet weak var btnResShare: UIButton!
    @IBOutlet weak var btnResSpeaker: UIButton!
    @IBOutlet weak var btnResFav: UIButton!
    
    var dataSource: Translate! = Translate()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnSrcCopy.imageView?.contentMode = .scaleAspectFit
        btnSrcShare.imageView?.contentMode = .scaleAspectFit
        btnSrcSpeaker.imageView?.contentMode = .scaleAspectFit
        btnSrcDelete.imageView?.contentMode = .scaleAspectFit
        
        btnResCopy.imageView?.contentMode = .scaleAspectFit
        btnResShare.imageView?.contentMode = .scaleAspectFit
        btnResSpeaker.imageView?.contentMode = .scaleAspectFit
        btnResFav.imageView?.contentMode = .scaleAspectFit
        
    }
    
    func setCell(for data: Translate) {
        self.dataSource = data
        self.lblSourceLang.text = LanguageSupport.getLanguageFromId(id: data.srcLang)?.name ?? ""
        self.lblTargetLang.text = LanguageSupport.getLanguageFromId(id: data.tarLang)?.name ?? ""
        self.imgSource.image = UIImage.init(named: LanguageSupport.getLanguageFromId(id: data.srcLang)?.flag ?? "")
        self.imgTarget.image = UIImage.init(named: LanguageSupport.getLanguageFromId(id: data.tarLang)?.flag ?? "")
        self.lblSourceText.text = data.source
        self.lblResultText.text = data.result
        
        if data.isFav {
            self.btnResFav.setImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        } else {
            self.btnResFav.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        }
        
        setTarget()
        
    }
    
    fileprivate func setTarget() {
        self.btnSrcCopy.addTarget(self, action: #selector(copySource), for: .touchUpInside)
        self.btnResCopy.addTarget(self, action: #selector(copyResult), for: .touchUpInside)
        self.btnSrcSpeaker.addTarget(self, action: #selector(speakSrc), for: .touchUpInside)
        self.btnResSpeaker.addTarget(self, action: #selector(speakRes), for: .touchUpInside)
        self.btnSrcShare.addTarget(self, action: #selector(shareSrc), for: .touchUpInside)
        self.btnResShare.addTarget(self, action: #selector(shareRes), for: .touchUpInside)
        self.btnSrcDelete.addTarget(self, action: #selector(deleteData), for: .touchUpInside)
        self.btnResFav.addTarget(self, action: #selector(fav), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func copySource() {
        Utils.topViewController()?.view.showToast(message: NSLocalizedString("Đã sao chép", comment: "Đã sao chép"), duration: 2)
        UIPasteboard.general.string = dataSource.source
    }
    
    @objc func copyResult() {
        Utils.topViewController()?.view.showToast(message: NSLocalizedString("Đã sao chép", comment: "Đã sao chép"), duration: 2)
        UIPasteboard.general.string = dataSource.result
    }
    
    @objc func shareSrc() {
        let share = Utils.shareText(text: dataSource.source)
        Utils.topViewController()?.present(share, animated: true, completion: nil)
    }
    
    @objc func shareRes() {
        let share = Utils.shareText(text: dataSource.result)
        Utils.topViewController()?.present(share, animated: true, completion: nil)
    }
    
    @objc func deleteData() {
        let topVC = Utils.topViewController()
        let alert = Utils.showAlertDefault(NSLocalizedString("Xác nhận", comment: ""), message: NSLocalizedString("Bạn có chắc muốn xoá bản dịch này?", comment: ""), buttons: [NSLocalizedString("Không", comment: ""), NSLocalizedString("Có", comment: "")]) { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            if index == 1 {
                DatabaseService.shared.deleteHistory(translate: strongSelf.dataSource)
                if let vc = topVC as? HomeViewController {
                    if let curIndex = vc.tableView.indexPath(for: strongSelf) {
                        vc.dataSource.remove(at: curIndex.row)
                        vc.tableView.deleteRows(at: [curIndex], with: UITableViewRowAnimation.automatic)
                    }
                } else if let vc = topVC as? FavoriteViewController {
                    if let curIndex = vc.tableView.indexPath(for: strongSelf) {
                        vc.dataSource.remove(at: curIndex.row)
                        vc.tableView.deleteRows(at: [curIndex], with: UITableViewRowAnimation.automatic)
                    }
                }
            }
        }
        topVC?.present(alert, animated: true, completion: nil)
    }
    
    @objc func fav() {
        if DatabaseService.shared.setFavorite(transelate: dataSource) {
            btnResFav.setImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        } else {
            btnResFav.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        }
    }
    
    @objc func speakSrc() {
        SpeechService.shared.textToSpeech(text: dataSource.source, language: LanguageSupport.getLanguageFromId(id: dataSource.srcLang)?.local ?? "")
    }
    
    @objc func speakRes() {
        SpeechService.shared.textToSpeech(text: dataSource.result, language: LanguageSupport.getLanguageFromId(id: dataSource.tarLang)?.local ?? "")
    }
    
}

