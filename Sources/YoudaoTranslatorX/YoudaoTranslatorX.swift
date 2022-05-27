
import ArgumentParser
import Foundation
import CoreMedia
import Alamofire

@main
struct YoudaoTranslatorX: AsyncParsableCommand {
    @Argument(
        help: "the text you want to tranlate")
    var queryText: String
    
    @Option(name:.customLong("appID"),
        help: "youdao appID")
    var appID: String
    
    @Option(name:.customLong("appSecret"),
        help: "youdao appSecret")
    var appSecret: String
    
    @Flag(help: "Include full information in the output.")
    var verbose = false
}

extension YoudaoTranslatorX {
    
    mutating func run() async throws {
        guard #available(macOS 11, *) else {
            print("'YoudaoTranslate' isn't supported on this platform(available(macOS 11+)).")
            return
        }
        
        #if DEBUG
//        verbose = true
//        queryText = "<# queryText #>"
//        appID = "<# Youdao appID #>"
//        appSecret = "<# Youdao AppSecret #>"

        #endif
        
        queryText = queryText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard queryText.count > 0 else {
            var item = Item(JSON: [String : Any]())
            item?.title = "❌ 翻译出了点小问题..."
            item?.subtitle = "查询文本不能为空"
            var alfredItems = AlfredItems(JSON: [String : Any]())
            alfredItems?.items = [Item]()
            alfredItems?.items?.append(item!)
            print(String(describing: alfredItems!.toJSONString()!))
            return
        }
        
        do {
            let youdaoResponse = try await youdaoRequest(queryText: queryText, appID: appID, appSecret: appSecret, verbose: verbose)!
            let alfredItems = getAlfredItem(from: youdaoResponse)
            guard alfredItems != nil else {
                var item = Item(JSON: [String : Any]())
                item?.title = "❌ 翻译出了点小问题..."
                item?.subtitle = "some thing wrong"
                var alfredItems = AlfredItems(JSON: [String : Any]())
                alfredItems?.items = [Item]()
                alfredItems?.items?.append(item!)
                print(String(describing: alfredItems!.toJSONString()!))
                return
            }
            
            guard !verbose else {
                return
            }
            print(String(describing: alfredItems!.toJSONString()!))

        } catch {
            var item = Item(JSON: [String : Any]())
            item?.title = "❌ 翻译出了点小问题..."
            item?.subtitle = error.localizedDescription
            var alfredItems = AlfredItems(JSON: [String : Any]())
            alfredItems?.items = [Item]()
            alfredItems?.items?.append(item!)
            print(String(describing: alfredItems!.toJSONString()!))
        }
    }
}

