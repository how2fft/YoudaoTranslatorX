//
//  YoudaoModel.swift
//  
//
//  Created by rong on 2022/4/7.
//

import ObjectMapper

enum YoudaoErrorCode {
    case success
    
    case lackRequiredParameters
    case doesNotSupportLanguageTypes
    case translatedTextIsTooLong
    case applicationIdIsInvalid
    case withoutValidInstanceRelatedServices
    case developerAccountIsInvalid
    case requestServiceIsInvalid
    case queryIsEmpty
    case signatureVerificationFailed
    case accountHasBeenOverdueBills
    case limitedAccessFrequency
    
    case unknown
}

class YoudaoResponse: Mappable {
    var query: String?
    var errorCode: String?
    var statusCode: YoudaoErrorCode {
        get {
            let code = Int(errorCode ?? "-1")
            switch code {
            case 0:
                return .success
            case 101:
                return .lackRequiredParameters
            case 102:
                return .doesNotSupportLanguageTypes
            case 103:
                return .translatedTextIsTooLong
            case 108:
                return .applicationIdIsInvalid
            case 110:
                return .withoutValidInstanceRelatedServices
            case 111:
                return .developerAccountIsInvalid
            case 112:
                return .requestServiceIsInvalid
            case 113:
                return .queryIsEmpty
            case 202:
                return .signatureVerificationFailed
            case 401:
                return .accountHasBeenOverdueBills
            case 411:
                return .limitedAccessFrequency
            default:
                return .unknown
            }
        }
    }
    var web: Array<YoudaoWebModel>?
    var translation: Array<String>?
    var basic: YoudaoBasicModel?
    var returnPhrase: Array<String>?
    var l: String?//源语言和目标语言
    
    required init?(map: Map) {
            
    }
    
    func mapping(map: Map) {
        query <- map["query"]
        errorCode <- map["errorCode"]
        web <- map["web"]
        translation <- map["translation"]
        basic <- map["basic"]
        returnPhrase <- map["returnPhrase"]
        l <- map["l"]
    }
}

class YoudaoWebModel: Mappable {
    var key: String?
    var value: Array<String>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        key <- map["key"]
        value <- map["value"]
    }
}

class YoudaoBasicModel: Mappable {
    var phonetic: String?
    var explains: Array<String>?
    var usPhonetic: String?
    var ukPhonetic: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        phonetic <- map["phonetic"]
        explains <- map["explains"]
        usPhonetic <- map["us-phonetic"]
        ukPhonetic <- map["uk-phonetic"]
    }
}
