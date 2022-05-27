//
//  File.swift
//  
//
//  Created by rong on 2022/4/8.
//

import AVFAudio

let IconPath: String = "assets/translate.png"
let IconSayPath: String = "assets/translateSpeak.png"

func getAlfredItem(from response: YoudaoResponse) -> AlfredItems? {
    var alfredItems = AlfredItems(JSON: [String : Any]())
    alfredItems?.items = [Item]()
    
    guard response.statusCode == .success else {
        var item = Item(JSON: [String : Any]())
        item?.title = "❌ 翻译出错啦..."
        item?.subtitle = String(describing: response.statusCode) + ", errorCode: " + response.errorCode!
        alfredItems?.items?.append(item!)

        return alfredItems
    }
    
    
    let translateItem = parseItemTranslate(from: response)
    alfredItems?.items?.append(translateItem!)
    
    let phoneticItem = parsePhonetic(from: response)
    if (phoneticItem != nil) {
        alfredItems?.items?.append(phoneticItem!)
    }
    
    let basicItems = parseBasics(from: response)
    alfredItems?.items?.append(contentsOf: basicItems!)
    
    let webItems = parseWebs(from: response)
    alfredItems?.items?.append(contentsOf: webItems!)
    
    return alfredItems
}

func parseItemTranslate(from response: YoudaoResponse) -> Item? {
    var item = Item(JSON: [String : Any]())
    
    item?.title = response.translation?[0]
    item?.subtitle = response.query
    item?.arg = response.translation?[0]
    item?.valid = true
    
    item?.mods = generateMods(from: response)
    item?.icon = generateIcon(from: IconPath)
    item?.text = generateText(from: response.translation?[0])

    return item
}

func parseBasics(from response: YoudaoResponse) -> [Item]? {
    let explains = response.basic?.explains
    
    guard explains != nil && explains!.count > 0 else {
        return []
    }
    var items = [Item]()
    for explain in explains! {
        var item = Item(JSON: [String : Any]())
        item?.title = explain
        item?.subtitle = response.query
        item?.arg = explain
        
        item?.mods = generateMods(from: response)
        item?.icon = generateIcon(from: IconPath)
        item?.text = generateText(from: explain)
        items.append(item!)
    }
    return items
}

func parsePhonetic(from response: YoudaoResponse) -> Item? {
    guard response.basic?.phonetic != nil else {
        return nil
    }
    let originalPhonetic = "[" + (response.basic?.phonetic ?? "") + "]"
    let ukPhonetic = "[uk: " + (response.basic?.ukPhonetic ?? "") + "]"
    let usPhonetic = "[us: " + (response.basic?.usPhonetic ?? "") + "]"
    let phonetic = originalPhonetic + ukPhonetic + usPhonetic

    var item = Item(JSON: [String : Any]())
    item?.title = phonetic
    item?.subtitle = "回车可听发音"
    item?.arg = "~" + (response.query ?? "")
    
    item?.mods = generateMods(from: response)
    item?.icon = generateIcon(from: IconSayPath)
    item?.text = generateText(from: phonetic)

    return item
}

func parseWebs(from response: YoudaoResponse) -> [Item]? {
    let webs = response.web
    
    guard webs != nil && webs!.count > 0 else {
        return []
    }
    var items = [Item]()
    
    for web: YoudaoWebModel in webs! {
        var item = Item(JSON: [String : Any]())
        let title = web.value?.joined(separator: ", ")
        item?.title = title
        item?.subtitle = web.key
        item?.arg = title
        
        item?.mods = generateMods(from: response)
        item?.icon = generateIcon(from: IconPath)
        item?.text = generateText(from: title)
        items.append(item!)
    }
    return items
}

func generateMods(from response: YoudaoResponse) -> Mods? {
    var mods = Mods(JSON: [String : Any]())
    var cmd = Cmd(JSON: [String : Any]())
    cmd?.subtitle = "🔈 " + response.query!
    cmd?.valid = true
    cmd?.arg = response.query

    var alt = Alt(JSON: [String : Any]())
    alt?.subtitle = "📣 " + response.query!
    alt?.valid = true
    alt?.arg = response.query
    
    mods?.cmd = cmd
    mods?.alt = alt
    return mods
}

func generateIcon(from iconPath:String = IconPath) -> Icon? {
    var icon = Icon(JSON: [String : Any]())
    icon?.path = iconPath
    return icon
}


func generateText(from copy: String?) -> Text? {
    var text = Text(JSON: [String : Any]())
    text?.copy = copy
    return text
}




