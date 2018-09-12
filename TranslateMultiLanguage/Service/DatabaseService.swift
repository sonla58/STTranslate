//
//  DatabaseService.swift
//  Translate_cn-vi
//
//  Created by Anh Son Le on 6/27/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import Foundation
import RealmSwift

struct DatabaseService {
    
    static let shared = DatabaseService()
    
    var realm = try! Realm.init()
    
    func getHistoryList() -> [Translate] {
        return realm.objects(Translate.self).reversed()
    }
    
    func addHistory(translate: Translate) {
        let filters = realm.objects(Translate.self).filter { (e) -> Bool in
            return (e.source == translate.source) && (e.result == translate.result)
        }
        do {
            try realm.write {
                for item in filters {
                    realm.delete(item)
                }
                realm.add(translate)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteHistory(translate: Translate) {
        do {
            try realm.write {
                realm.delete(translate)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
    
    func setFavorite(transelate: Translate) -> Bool {
        let obj = getHistoryList().filter { (org) -> Bool in
            return (org.source == transelate.source) && (org.result == transelate.result)
        }.first
        if let clrObj = obj {
            do {
                try realm.write {
                    clrObj.isFav = !clrObj.isFav
                }
                return clrObj.isFav
            } catch {
                print(error)
                return clrObj.isFav
            }
        } else {
            return transelate.isFav
        }
    }
    
}
