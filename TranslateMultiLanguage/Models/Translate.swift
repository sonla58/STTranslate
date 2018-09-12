//
//  Translate.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/8/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import Foundation
import RealmSwift

class Translate: Object {
    @objc dynamic var source = ""
    @objc dynamic var result = ""
    @objc dynamic var srcLang = ""
    @objc dynamic var tarLang = ""
    @objc dynamic var isFav = false
}
