//
//  SpeechToTextViewController.swift
//  Translate_cn-vi
//
//  Created by Anh Son Le on 6/28/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit
import PopupController
import RxCocoa
import RxSwift
import Speech

class SpeechToTextViewController: AppViewController {

    // MARK: - Outlet
    @IBOutlet weak var authorizationView: UIView!
    @IBOutlet weak var lblAuthContent: UILabel!
    @IBOutlet weak var btnRequestAuthorization: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var lblResult: UILabel!
    
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: - Define
    enum State {
        case auth
        case listening
    }
    
    // MARK: - Declare
    var popup: PopupController = PopupController()
    var state: BehaviorRelay<State> = BehaviorRelay<State>.init(value: SpeechToTextViewController.State.listening)
    var resultText: BehaviorRelay<String> = BehaviorRelay<String>.init(value: "")
    
    var completeHandle: ((_ text: String) -> Void) = {_ in}
    
    var isListening = false
    
    var disposeBag = DisposeBag()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "vi-VN"))
    
    var lang: String = "vi-VN"
    
    // MARK: - Set up
    func setViewForState() {
        switch state.value {
        case .auth:
            authorizationView.isHidden = false
            resultView.isHidden = true
            btnClose.setTitle(NSLocalizedString("Đóng", comment: "Đóng"), for: .normal)
            break
        case .listening:
            authorizationView.isHidden = true
            resultView.isHidden = false
            btnClose.setTitle(NSLocalizedString("Xong", comment: "Xong"), for: .normal)
            if !isListening {
                self.startRecording()
            }
            break
        }
    }
    
    func setObserve() {
        state.bind { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            OperationQueue.main.addOperation {
                strongSelf.setViewForState()
            }
        }.disposed(by: self.disposeBag)
        
        resultText.bind(to: lblResult.rx.text).disposed(by: disposeBag)
        
        btnRequestAuthorization.addTarget(self, action: #selector(allowButtonTaped), for: UIControlEvents.touchUpInside)
        btnClose.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        
    }
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setObserve()
        checkAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkAuth() {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            switch AVAudioSession.sharedInstance().recordPermission() {
            case .granted:
                self.state.accept(SpeechToTextViewController.State.listening)
                break
            default:
                self.state.accept(SpeechToTextViewController.State.auth)
                break
            }
            break
        case .notDetermined:
            self.state.accept(SpeechToTextViewController.State.auth)
            break
        default:
            self.state.accept(SpeechToTextViewController.State.auth)
            break
        }
    }
    
    @objc func requestAuth() {
        SFSpeechRecognizer.requestAuthorization { (status) in
            switch status {
            case .authorized:
                AVAudioSession.sharedInstance().requestRecordPermission({ (success) in
                    if success {
                        self.state.accept(SpeechToTextViewController.State.listening)
                    } else {
                        self.state.accept(SpeechToTextViewController.State.auth)
                    }
                })
                break
            case .denied:
                self.state.accept(SpeechToTextViewController.State.auth)
                OperationQueue.main.addOperation {
                    self.lblAuthContent.text = NSLocalizedString("Bạn đã từ chối cho phép ứng dụng sử dụng microphone và dữ liệu giọng nói. Để sử dụng tính năng này vui lòng cấp phép cho ứng dụng", comment: "Bạn đã từ chối cho phép ứng dụng sử dụng microphone và dữ liệu giọng nói. Để sử dụng tính năng này vui lòng cấp phép cho ứng dụng")
                }
                break
            default:
                self.state.accept(SpeechToTextViewController.State.auth)
                break
            }
        }
    }
    
    @objc func allowButtonTaped() {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            switch AVAudioSession.sharedInstance().recordPermission() {
            case .granted:
                self.state.accept(SpeechToTextViewController.State.listening)
                break
            case .denied:
                self.state.accept(SpeechToTextViewController.State.auth)
                Utils.openSeting()
                break
            default:
                self.state.accept(SpeechToTextViewController.State.auth)
                requestAuth()
                break
            }
            break
        case .notDetermined:
            self.requestAuth()
            break
        default:
            self.state.accept(SpeechToTextViewController.State.auth)
            Utils.openSeting()
            break
        }
    }
    
    @objc func cancel() {
        switch state.value {
        case .auth:
            self.popup.dismiss()
            break
        case .listening:
            self.audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
            
            self.recognitionRequest = nil
            self.recognitionTask = nil
            self.isListening = false
            self.popup.dismiss()
            break
        }
    }
    
    @objc func startRecording() {
        
        isListening = true
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        audioEngine.inputNode.removeTap(onBus: 0)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            isListening = false
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            isListening = false
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        speechRecognizer = SFSpeechRecognizer.init(locale: Locale.init(identifier: lang))
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if result != nil {
                
                self.resultText.accept(result?.bestTranscription.formattedString ?? "")
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.isListening = false
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            isListening = false
            print("audioEngine couldn't start because of an error.")
        }
        
    }

}

extension SpeechToTextViewController {
    static func initPopup() -> SpeechToTextViewController {
        let vc = SpeechToTextViewController.init(nibName: "SpeechToTextViewController", bundle: Bundle.main)
        return vc
    }
    
    static func show(in parentVC: UIViewController, withLanguage lang: String, completeHandle:@escaping ((_ resultString: String)->Void)) ->  SpeechToTextViewController {
        let vc = SpeechToTextViewController.init(nibName: "SpeechToTextViewController", bundle: Bundle.main)
        vc.completeHandle = completeHandle
        vc.lang = lang
        vc.popup = PopupController.create(parentVC.navigationController ?? parentVC)
                    .customize([
                        PopupCustomOption.animation(PopupController.PopupAnimation.slideUp),
                        PopupCustomOption.backgroundStyle(PopupController.PopupBackgroundStyle.blackFilter(alpha: 0.7)),
                        PopupCustomOption.dismissWhenTaps(true),
                        PopupCustomOption.layout(PopupController.PopupLayout.bottom),
                        PopupCustomOption.scrollable(false)
                        ]).didCloseHandler({ (popup) in
                            vc.completeHandle(vc.resultText.value)
                        }).show(vc)
        return vc
    }
    
}

extension SpeechToTextViewController: PopupContentViewController {
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return CGSize.init(width: screenSize.width - 16, height: 380)
    }
    
}
