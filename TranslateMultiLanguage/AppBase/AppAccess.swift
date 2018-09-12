//
//  AppAccess.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/12/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit

class AppAccess {
    
    struct Key {
        static var kRoute = "kRoute"
    }
    
    static var shared = AppAccess()
    
    var prefs = UserDefaults.standard
    
    // MARK: - Route
    
    func saveRoute(srcLang: LanguageSupport, tarLang: LanguageSupport) {
        prefs.set([srcLang.id, tarLang.id], forKey: Key.kRoute)
        prefs.synchronize()
    }
    
    func getUser() -> (LanguageSupport, LanguageSupport)? {
        if let array = prefs.array(forKey: Key.kRoute) as? [String], array.count == 2 {
            return (LanguageSupport.getLanguageFromId(id: array[0]), LanguageSupport.getLanguageFromId(id: array[1])) as? (LanguageSupport, LanguageSupport)
        }
        return nil
    }
    
    func removeUser() {
        prefs.removeObject(forKey: Key.kRoute)
    }
    
}

