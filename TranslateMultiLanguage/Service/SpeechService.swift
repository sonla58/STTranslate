//
//  SpeechService.swift
//  Translate_cn-vi
//
//  Created by Anh Son Le on 6/26/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import Foundation
import AVFoundation
import Speech
import Alamofire

class SpeechService: NSObject {
    
    static let shared = SpeechService()
    
    var player: AVAudioPlayer?
    
    var urlViTTS = "https://translate.google.com/translate_tts"
    
    // Text to speech
    let speechSynthesizer = AVSpeechSynthesizer()
    
    // Method text to speech
    func textToSpeech(text: String, language: String) {
        
        let speechUtterance = AVSpeechUtterance(string: text)
        
        speechUtterance.rate = 0.5
        speechUtterance.pitchMultiplier = 1
        speechUtterance.volume = 1
        speechUtterance.voice = AVSpeechSynthesisVoice.init(language: language)
        
        speechSynthesizer.speak(speechUtterance)
    }
    
    func ViTTS(text: String) {
        let queryItems = [
            URLQueryItem.init(name: "client", value: "t"),
            URLQueryItem.init(name: "idx", value: "0"),
            URLQueryItem.init(name: "ie", value: "UTF-8"),
            URLQueryItem.init(name: "prev", value: "input"),
            URLQueryItem.init(name: "q", value: text),
            URLQueryItem.init(name: "textlen", value: "\(text.count)"),
            URLQueryItem.init(name: "tl", value: "vi"),
            URLQueryItem.init(name: "total", value: "1"),
            URLQueryItem.init(name: "tk", value: "295551.196271"),
        ]
        if var urlComs = URLComponents.init(string: urlViTTS) {
            urlComs.queryItems = queryItems
            if let url = urlComs.url {
                Alamofire.request(url).responseData { (dataResponse) in
                    dataResponse.result.ifSuccess {
                        do {
                            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                            try AVAudioSession.sharedInstance().setActive(true)

                            try self.player = AVAudioPlayer(data: dataResponse.data!)
                            guard let player = self.player else { return }
                            
                            player.play()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
}
