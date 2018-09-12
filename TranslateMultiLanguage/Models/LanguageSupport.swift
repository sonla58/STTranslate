//
//  LanguageSupport.swift
//  TranslateMultiLanguage
//
//  Created by Anh Son Le on 7/8/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import Foundation

class Language {
    var name: String = ""
    var languageCode: String = ""
    var locale: String = ""
    var sttCode: String = ""
}

enum LanguageSupport {
    case Arabic
    case Bengali
    case Chinese
    case Danish
    case Dutch
    case English
    case French
    case German
    case Greek
    case Gujarati
    case Hebrew
    case Hindi
    case Hungarian
    case Indonesian
    case Italian
    case Japanese
    case Kannada
    case Khmer
    case Korean
    case Lao
    case Malay
    case Malayalam
    case Marathi
    case Nepali
    case Persian
    case Polish
    case Portuguese
    case Punjabi
    case Russian
    case Sinhala
    case Spanish
    case Tamil
    case Telugu
    case Thai
    case Turkish
    case Ukrainian
    case Urdu
    case Vietnamese
    
    var id: String {
        get {
            switch self {
            case .Arabic:
                return "ar"
            case .Bengali:
                return "bn"
            case .Chinese:
                return "zh-TW"
            case .Danish:
                return "da"
            case .Dutch:
                return "nl"
            case .English:
                return "en"
            case .French:
                return "fr"
            case .German:
                return "de"
            case .Greek:
                return "el"
            case .Gujarati:
                return "gu"
            case .Hebrew:
                return "iw"
            case .Hindi:
                return "hi"
            case .Hungarian:
                return "hu"
            case .Indonesian:
                return "id"
            case .Italian:
                return "it"
            case .Japanese:
                return "ja"
            case .Kannada:
                return "kn"
            case .Khmer:
                return "km"
            case .Korean:
                return "ko"
            case .Lao:
                return "lo"
            case .Malay:
                return "ms"
            case .Malayalam:
                return "ml"
            case .Marathi:
                return "mr"
            case .Nepali:
                return "ne"
            case .Persian:
                return "fa"
            case .Polish:
                return "pl"
            case .Portuguese:
                return "pt"
            case .Punjabi:
                return "pa"
            case .Russian:
                return "ru"
            case .Sinhala:
                return "si"
            case .Spanish:
                return "es"
            case .Tamil:
                return "ta"
            case .Telugu:
                return "te"
            case .Thai:
                return "th"
            case .Turkish:
                return "tr"
            case .Ukrainian:
                return "uk"
            case .Urdu:
                return "ur"
            case .Vietnamese:
                return "vi"
            }
        }
    }
    
    var name: String {
        get {
            switch self {
            case .Arabic:
                return "Arabic"
            case .Bengali:
                return "Bengali"
            case .Chinese:
                return "Chinese"
            case .Danish:
                return "Danish"
            case .Dutch:
                return "Dutch"
            case .English:
                return "English"
            case .French:
                return "French"
            case .German:
                return "German"
            case .Greek:
                return "Greek"
            case .Gujarati:
                return "Gujarati"
            case .Hebrew:
                return "Hebrew"
            case .Hindi:
                return "Hindi"
            case .Hungarian:
                return "Hungarian"
            case .Indonesian:
                return "Indonesian"
            case .Italian:
                return "Italian"
            case .Japanese:
                return "Japanese"
            case .Kannada:
                return "Kannada"
            case .Khmer:
                return "Khmer"
            case .Korean:
                return "Korean"
            case .Lao:
                return "Lao"
            case .Malay:
                return "Malay"
            case .Malayalam:
                return "Malayalam"
            case .Marathi:
                return "Marathi"
            case .Nepali:
                return "Nepali"
            case .Persian:
                return "Persian"
            case .Polish:
                return "Polish"
            case .Portuguese:
                return "Portuguese"
            case .Punjabi:
                return "Punjabi"
            case .Russian:
                return "Russian"
            case .Sinhala:
                return "Sinhala"
            case .Spanish:
                return "Spanish"
            case .Tamil:
                return "Tamil"
            case .Telugu:
                return "Telugu"
            case .Thai:
                return "Thai"
            case .Turkish:
                return "Turkish"
            case .Ukrainian:
                return "Ukrainian"
            case .Urdu:
                return "Urdu"
            case .Vietnamese:
                return "Vietnamese"
            }
        }
    }
    
    var local: String {
        get {
            switch self {
            case .Arabic:
                return "ar-SA"
            case .Bengali:
                return "bn-BD"
            case .Chinese:
                return "zh-CN"
            case .Danish:
                return "da-DK"
            case .Dutch:
                return "nl-NL"
            case .English:
                return "en-US"
            case .French:
                return "fr-FR"
            case .German:
                return "de-DE"
            case .Greek:
                return "el-GR"
            case .Gujarati:
                return "gu-IN"
            case .Hebrew:
                return "iw-IL"
            case .Hindi:
                return "hi-IN"
            case .Hungarian:
                return "hu-HU"
            case .Indonesian:
                return "id-ID"
            case .Italian:
                return "it-IT"
            case .Japanese:
                return "ja-JP"
            case .Kannada:
                return "kn-IN"
            case .Khmer:
                return "km-KH"
            case .Korean:
                return "ko-KR"
            case .Lao:
                return "lo-LA"
            case .Malay:
                return "ms-MY"
            case .Malayalam:
                return "ml-IN"
            case .Marathi:
                return "mr-IN"
            case .Nepali:
                return "ne_NP"
            case .Persian:
                return "fa-IR"
            case .Polish:
                return "pl-PL"
            case .Portuguese:
                return "pt-PT"
            case .Punjabi:
                return "pa"
            case .Russian:
                return "ru-RU"
            case .Sinhala:
                return "si-LK"
            case .Spanish:
                return "es-ES"
            case .Tamil:
                return "ta-LK"
            case .Telugu:
                return "te-IN"
            case .Thai:
                return "th-TH"
            case .Turkish:
                return "tr-TR"
            case .Ukrainian:
                return "uk-UA"
            case .Urdu:
                return "ur-PK"
            case .Vietnamese:
                return "vi-VN"
            }
        }
    }
    
    var idHanWritting: String {
        get {
            switch self {
            case .Chinese:
                return "zh-t-i0-handwrit"
            default:
                return (self.id + "-t-i0-handwrit")
            }
        }
    }
    
    var code: String {
        get {
            return self.id
        }
    }
    
    var orcCode: String {
        get {
            switch self {
            case .Arabic:
                return ""
            case .Bengali:
                return "ben"
            case .Chinese:
                return "chi_sim+chi_tra"
            case .Danish:
                return "eng+dan"
            case .Dutch:
                return "eng+nld"
            case .English:
                return "eng"
            case .French:
                return "eng+fra"
            case .German:
                return "eng+deu"
            case .Greek:
                return "eng+grc"
            case .Gujarati:
                return "guj"
            case .Hebrew:
                return "heb"
            case .Hindi:
                return "hin"
            case .Hungarian:
                return "hun"
            case .Indonesian:
                return "ind"
            case .Italian:
                return "ita"
            case .Japanese:
                return "jpn"
            case .Kannada:
                return "kan"
            case .Khmer:
                return "khm"
            case .Korean:
                return "kor"
            case .Lao:
                return "lao"
            case .Malay:
                return "mal"
            case .Malayalam:
                return "mal"
            case .Marathi:
                return "mar"
            case .Nepali:
                return "nep"
            case .Persian:
                return ""
            case .Polish:
                return "pol"
            case .Portuguese:
                return "por"
            case .Punjabi:
                return ""
            case .Russian:
                return "rus"
            case .Sinhala:
                return "sin"
            case .Spanish:
                return "spa"
            case .Tamil:
                return "tam"
            case .Telugu:
                return "tel"
            case .Thai:
                return "tha"
            case .Turkish:
                return "tur"
            case .Ukrainian:
                return "ukr"
            case .Urdu:
                return "urd"
            case .Vietnamese:
                return "eng+vie"
//            default:
//                return ""
            }
        }
    }
    
    var flag: String {
        get {
            switch self {
            case .Arabic:
                return "sa"
            case .Bengali:
                return "bd"
            case .Chinese:
                return "cn"
            case .Danish:
                return "dk"
            case .Dutch:
                return "nl"
            case .English:
                return "gb"
            case .French:
                return "fr"
            case .German:
                return "de"
            case .Greek:
                return "gr"
            case .Gujarati:
                return "in"
            case .Hebrew:
                return "il"
            case .Hindi:
                return "in"
            case .Hungarian:
                return "hu"
            case .Indonesian:
                return "id"
            case .Italian:
                return "it"
            case .Japanese:
                return "jp"
            case .Kannada:
                return "id"
            case .Khmer:
                return "kh"
            case .Korean:
                return "kr"
            case .Lao:
                return "la"
            case .Malay:
                return "my"
            case .Malayalam:
                return "my"
            case .Marathi:
                return "my"
            case .Nepali:
                return "np"
            case .Persian:
                return "ir"
            case .Polish:
                return "pl"
            case .Portuguese:
                return "pt"
            case .Punjabi:
                return "in"
            case .Russian:
                return "ru"
            case .Sinhala:
                return "lk"
            case .Spanish:
                return "es"
            case .Tamil:
                return "lk"
            case .Telugu:
                return "in"
            case .Thai:
                return "th"
            case .Turkish:
                return "tr"
            case .Ukrainian:
                return "ua"
            case .Urdu:
                return "pk"
            case .Vietnamese:
                return "vn"
            }
        }
    }
    
    static func getURLForORCResource(code: String) -> URL? {
        let orc = code
        if orc.isBlank {
            return nil
        } else {
            let urlString = "https://github.com/tesseract-ocr/tessdata/raw/4d64457aacbc781a94d6aefc125765c3949c8827/\(orc).traineddata"
            return URL.init(string: urlString)
        }
    }
    
    static var all: [LanguageSupport] {
        get {
            return Utils.iterateEnum(LanguageSupport.self).map({$0})
        }
    }
    
    static func getLanguageFromId(id: String) -> LanguageSupport? {
        for item in Utils.iterateEnum(LanguageSupport.self) {
            if item.id == id {
                return item
            }
        }
        return nil
    }
    
}

