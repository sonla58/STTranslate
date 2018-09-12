//
//  ORCService.swift
//  Translate_cn-vi
//
//  Created by Anh Son Le on 6/30/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit
import TesseractOCR
import Alamofire
import RxCocoa
import RxSwift
import SVProgressHUD

class ORCService {
    
    static var shared = ORCService()
    
    var file = FileManager.default
    var cachePath = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask).first
    var tessdataPath: URL? {
        get {
            return cachePath?.appendingPathComponent("tessdata", isDirectory: true)
        }
    }
    
    typealias DownloadQueue = (url: URL?, name: String)
    var downloadQueue: [DownloadQueue] = []
    var completeDownload: ((_ success: Bool)->Void) = {_ in}
    
    var sourceLang: LanguageSupport!
    var fileNames: [String] = []
    var sourceImage: UIImage!
    var complete: (_ text: String) -> Void = {_ in}
    
    public func recognize(image: UIImage, lang: LanguageSupport, complete:@escaping (_ text: String)->Void) {
        self.sourceLang = lang
        self.fileNames = lang.orcCode.components(separatedBy: "+")
        self.sourceImage = image
        self.complete = complete
        
        prepareDataForOrc { [weak self] (success) in
            if success {
                self?._recognize(image: image, lang: lang, complete: complete)
            }
        }
        
    }
    
    func _recognize(image: UIImage, lang: LanguageSupport, complete:(_ text: String)->Void) {
        print("start")
        print(lang.orcCode)
        if let tesseract = G8Tesseract.init(language: lang.orcCode, configDictionary: [:], configFileNames: [], cachesRelatedDataPath: "", engineMode: .tesseractOnly) {
            tesseract.image = image.g8_grayScale().g8_blackAndWhite()
            var result = self.recognize(tesseract: tesseract, pageMode: .auto)
            if result.isBlank {
                result = self.recognize(tesseract: tesseract, pageMode: .singleBlock)
                if result.isBlank {
                    result = self.recognize(tesseract: tesseract, pageMode: G8PageSegmentationMode.singleLine)
                }
            }
            complete(result)
        }
        
        
    }
    
    func recognize(tesseract: G8Tesseract, pageMode: G8PageSegmentationMode) -> String {
        tesseract.pageSegmentationMode = pageMode
        tesseract.recognize()
        if var rawResult = tesseract.recognizedText {
            print(rawResult)
            rawResult = rawResult.trimmingCharacters(in: ["\n"])
            let paras = rawResult.components(separatedBy: "\n").filter({!$0.isBlank})
            let standValue = paras.joined(separator: "\n")
            return standValue
        }
        return ""
    }
    
    func prepareDataForOrc(complete:@escaping ((_ success: Bool)->Void)) {
        
        self.completeDownload = complete
        
        guard let dataPath = tessdataPath else {
            complete(false)
            return
        }
        
        if !file.fileExists(atPath: dataPath.path) {
            do {
                try file.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                complete(false)
                return
            }
        }
        
        var isAlreadyInCaches = true
        var isAlreadyInBundle = true
        
        for fileName in fileNames {
            
            // Check file in Caches/ directory
            
            let filePath = dataPath.appendingPathComponent("\(fileName).traineddata", isDirectory: false)
            if file.fileExists(atPath: filePath.path) {
                print("❤️ file already in Caches/")
            } else {
                isAlreadyInCaches = false
                
                // Check file in Bundle
                if let bundlePath = Bundle.main.url(forResource: fileName, withExtension: "traineddata", subdirectory: "tessdata") {
                    // file exist in bundle, copy to Caches/
                    do {
                        let data = try Data.init(contentsOf: bundlePath)
                        file.createFile(atPath: filePath.path, contents: data, attributes: nil)
                        print("❤️ file already in Bundle, copy success")
                    } catch {
                        isAlreadyInBundle = false
                        print(error)
                    }
                } else {
                    print("👹 file not exist in Bundle, need download")
                    isAlreadyInBundle = false
                    let downloadUrl = LanguageSupport.getURLForORCResource(code: fileName)
                    downloadQueue.append((downloadUrl, fileName))
                }
                
            }
            
        }
        
        if isAlreadyInCaches || isAlreadyInBundle {
            complete(true)
        } else {
            startQueueDownload()
        }
        
    }
    
    func startQueueDownload() {
        if downloadQueue.count > 0 {
            let task = downloadQueue[0]
            downloadData(fileName: task.name, urlDownload: task.url) { [weak self] (success) in
                guard let strongSelf = self else {
                    return
                }
                if success {
                    strongSelf.downloadQueue.remove(at: 0)
                    strongSelf.startQueueDownload()
                } else {
                    strongSelf.exCompleteDownload(success: false)
                }
            }
        } else {
            exCompleteDownload(success: true)
        }
    }
    
    func exCompleteDownload(success: Bool) {
        completeDownload(success)
    }
    
    func downloadData(fileName: String, urlDownload: URL?, complete: @escaping (_ success: Bool)->Void) {
        if let cacheUrl = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask).first {
            let destination: DownloadRequest.DownloadFileDestination = {_, _ in
                let desUrl = cacheUrl.appendingPathComponent("tessdata", isDirectory: true).appendingPathComponent("\(fileName).traineddata", isDirectory: false)
                return (desUrl, [.removePreviousFile, .createIntermediateDirectories])
            }
            if let clearUrlDownload = urlDownload {
                Alamofire.download(clearUrlDownload, to: destination).downloadProgress { (progress) in
                    print(progress.fractionCompleted)
                    SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: NSLocalizedString("Tải gói dữ liệu ngôn ngữ", comment: "Tải gói dữ liệu ngôn ngữ"))
                    }.responseData { (response) in
                        complete(response.result.isSuccess)
                        SVProgressHUD.dismiss()
                }
            } else {
                complete(false)
            }
        } else {
            complete(false)
        }
    }
    
}

