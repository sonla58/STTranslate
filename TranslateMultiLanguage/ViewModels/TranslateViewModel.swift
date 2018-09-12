//
//  TranslateViewModel.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/8/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TranslateViewModel {
    
    init() {
        if let userRoute = AppAccess.shared.getUser() {
            route = BehaviorRelay<(LanguageSupport, LanguageSupport)>.init(value: userRoute)
        } else {
            if Locale.current.languageCode == "vi" {
                route = BehaviorRelay<(LanguageSupport, LanguageSupport)>.init(value: (.English, .Vietnamese))
            } else {
                route = BehaviorRelay<(LanguageSupport, LanguageSupport)>.init(value: (.English, .French))
            }
        }
    }
    
    var route: BehaviorRelay<(LanguageSupport, LanguageSupport)> = BehaviorRelay<(LanguageSupport, LanguageSupport)>.init(value: (.English, .Vietnamese))
    
    var sourceText = BehaviorRelay<String>.init(value: "")
    var resultText = BehaviorRelay<String>.init(value: "")
    var resultLatinText = BehaviorRelay<String>.init(value: "")
    
    func setFromModel(model: Translate) {
        self.sourceText.accept(model.source)
        self.resultText.accept(model.result)
        if let sourceLang = LanguageSupport.getLanguageFromId(id: model.srcLang), let targetLang = LanguageSupport.getLanguageFromId(id: model.tarLang) {
            route.accept((sourceLang, targetLang))
        }
    }
    
    func getModel() -> Translate {
        let model = Translate()
        model.source = sourceText.value
        model.result = resultText.value
        model.srcLang = route.value.0.id
        model.tarLang = route.value.1.id
        return model
    }
    
}
