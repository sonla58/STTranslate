//
//  TranslateService.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/8/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import Foundation
import SwiftSoup

struct TranslateService {
    
    let serviceUrl = "http://translate.google.com/m"
    
    enum UserAgent: String {
        case userAgent1 = "Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"
        case userAgent2 = "Mozilla/5.0 (Linux; U; Android 2.3; en-us) AppleWebKit/999+ (KHTML, like Gecko) Safari/999.9"
    }
    
    func translateText(text: String, sourceLang: String, targetlang: String, complete:@escaping ((_ success: Bool, _ text: (String, String)) -> Void)) {
        
        let queryItems = [
            URLQueryItem.init(name: "hl", value: sourceLang),
            URLQueryItem.init(name: "sl", value: sourceLang),
            URLQueryItem.init(name: "tl", value: targetlang),
            URLQueryItem.init(name: "ie", value: "UTF-8"),
            URLQueryItem.init(name: "prev", value: "_m"),
            URLQueryItem.init(name: "q", value: text)
        ]
        if var urlComponent = URLComponents(string: serviceUrl) {
            urlComponent.queryItems = queryItems
            if let url = urlComponent.url {
                print(url)
                var urlRequest: URLRequest = NSMutableURLRequest.init(url: url) as URLRequest
                urlRequest.addValue(UserAgent.userAgent1.rawValue, forHTTPHeaderField: "User-Agent")
                let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if error == nil {
                        if let clearData = data, let clearResponse = response as? HTTPURLResponse {
                            if clearResponse.statusCode/200 == 1 {
                                var result = ""
                                var resultLatin = ""
                                let str = String.init(data: clearData, encoding: String.Encoding.utf8)
                                do {
                                    let document: Document = try SwiftSoup.parse(str ?? "")
                                    let meanElement = try document.select("div.t0")
                                    let meanElement2 = try document.select("div.o1")
                                    for mean in meanElement {
                                        result = try mean.text()
                                    }
                                    for mean in meanElement2 {
                                        resultLatin += try mean.text()
                                    }
                                    complete(true, (result, resultLatin))
                                    return
                                } catch {
                                    print(error)
                                    complete(false, ("", ""))
                                }
                            } else {
                                complete(false, ("", ""))
                            }
                        } else {
                            complete(false, ("", ""))
                        }
                    } else {
                        complete(false, ("", ""))
                    }
                }
                task.resume()
            }
        }
    }
    
}
