//
//  File.swift
//  YoudaoAPI
//
//  Created by rong on 2022/3/25.
//

import Foundation
import CryptoKit
import Alamofire
import AVFoundation

let YOUDAO_URL = "https://openapi.youdao.com/api"

// CryptoKit.Digest utils
extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}

private func encrypt(_ signStr: String) -> String? {
    guard let data = signStr.data(using:.utf8) else { return nil }
    let digest = SHA256.hash(data: data)
    
//    #if DEBUG
//        debugPrint("digest.hexStr:\(digest.hexStr)")
//    #endif

    return digest.hexStr
}

private func truncate(_ str: String) -> String {
    if str.count <= 20 {
        return str
    } else {
        return str.prefix(10) + String(str.count) + str.suffix(10)
    }
}

func youdaoRequest(queryText: String, appID: String?, appSecret: String?, verbose: Bool) async throws -> YoudaoResponse? {
    var parameters = Dictionary<String, String>()
    
    parameters["q"] = queryText
    parameters["from"] = "auto"
    parameters["to"] = "auto"
    
    let salt = UUID().uuidString
    let curtime = String(Int(Date().timeIntervalSince1970))
    let signStr = (appID ?? "") + truncate(queryText) + salt + curtime + (appSecret ?? "")
    let sign = encrypt(signStr)
    
    parameters["appKey"] = appID ?? ""
    parameters["salt"] = salt
    parameters["sign"] = sign
    parameters["signType"] = "v3"
    parameters["curtime"] = curtime
    parameters["ext"] = "mp3"
    
    let dataTask = AF.request(YOUDAO_URL,
                              method: .post,
                              parameters: parameters,
                              encoder: URLEncodedFormParameterEncoder.default,
                              requestModifier: { $0.timeoutInterval = 5 }
    ).serializingString()
    
    
    // Later...
    let response = await dataTask.response // Returns full DataResponse<Value, AFError>
    if verbose {
        print("""
              queryText:\(queryText)
              ---------------------------------------------------
              parameters:\(parameters)
              ---------------------------------------------------
              response:\(String(describing: response.debugDescription))
              """)
    }

    // Elsewhere...
//    let result = await dataTask.result // Returns Result<Value, AFError>
    // And...
    let value = try await dataTask.value // Returns the Value or throws the AFError as an Error
    
    let YoudaoResponse = YoudaoResponse(JSONString: value)
    return YoudaoResponse
}
