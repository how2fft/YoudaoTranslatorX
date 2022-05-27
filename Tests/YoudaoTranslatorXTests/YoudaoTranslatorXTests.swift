import XCTest
import class Foundation.Bundle
@testable import YoudaoTranslatorX

final class YoudaoTranslateTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 11.0, *) else {
            return
        }

        // Mac Catalyst won't have `Process`, but it is supported for executables.
        #if !targetEnvironment(macCatalyst)
        

        let fooBinary = productsDirectory.appendingPathComponent("YoudaoTranslatorX")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

//        process.arguments = [ "<# queryText #>", "--appID=<# Youdao appID #>", "--appSecret=<# Youdao AppSecret #>", "--verbose"]
//        process.arguments = [ "<# queryText #>", "--appID=<# Youdao appID #>", "--appSecret=<# Youdao AppSecret #>"]

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        let items = AlfredItems(JSONString: output!)
        
        let correctItems = AlfredItems(JSONString: outputStr)

        XCTAssertEqual(items, correctItems)
    
        #endif
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}

let outputStr = "{\"items\":[{\"valid\":true,\"text\":{\"copy\":\"赢得\"},\"icon\":{\"path\":\"assets\\/translate.png\"},\"subtitle\":\"win\",\"arg\":\"赢得\",\"title\":\"赢得\",\"mods\":{\"cmd\":{\"subtitle\":\"🔈 win\",\"arg\":\"win\",\"valid\":true},\"alt\":{\"subtitle\":\"📣 win\",\"arg\":\"win\",\"valid\":true}}},{\"text\":{\"copy\":\"[wɪn][uk: wɪn][us: wɪn]\"},\"mods\":{\"alt\":{\"subtitle\":\"📣 win\",\"valid\":true,\"arg\":\"win\"},\"cmd\":{\"subtitle\":\"🔈 win\",\"valid\":true,\"arg\":\"win\"}},\"arg\":\"~win\",\"icon\":{\"path\":\"assets\\/translate-say.png\"},\"subtitle\":\"回车可听发音\",\"valid\":true,\"title\":\"[wɪn][uk: wɪn][us: wɪn]\"},{\"icon\":{\"path\":\"assets\\/translate.png\"},\"mods\":{\"alt\":{\"subtitle\":\"📣 win\",\"arg\":\"win\",\"valid\":true},\"cmd\":{\"subtitle\":\"🔈 win\",\"valid\":true,\"arg\":\"win\"}},\"text\":{\"copy\":\"v. （在战斗、比赛、游戏等中）赢，获胜；赢得（奖品等）；通过努力得到（某物）；为……赢得，使……获得；采（矿）；晾（干草）\"},\"subtitle\":\"win\",\"arg\":\"v. （在战斗、比赛、游戏等中）赢，获胜；赢得（奖品等）；通过努力得到（某物）；为……赢得，使……获得；采（矿）；晾（干草）\",\"valid\":true,\"title\":\"v. （在战斗、比赛、游戏等中）赢，获胜；赢得（奖品等）；通过努力得到（某物）；为……赢得，使……获得；采（矿）；晾（干草）\"},{\"text\":{\"copy\":\"n. （在比赛、竞赛等中的）胜利\"},\"arg\":\"n. （在比赛、竞赛等中的）胜利\",\"icon\":{\"path\":\"assets\\/translate.png\"},\"mods\":{\"cmd\":{\"subtitle\":\"🔈 win\",\"valid\":true,\"arg\":\"win\"},\"alt\":{\"subtitle\":\"📣 win\",\"arg\":\"win\",\"valid\":true}},\"subtitle\":\"win\",\"valid\":true,\"title\":\"n. （在比赛、竞赛等中的）胜利\"},{\"text\":{\"copy\":\"【名】 （Win）（德、荷、缅）温，（英）温（女子教名 Winifred 的昵称）（人名）\"},\"arg\":\"【名】 （Win）（德、荷、缅）温，（英）温（女子教名 Winifred 的昵称）（人名）\",\"subtitle\":\"win\",\"valid\":true,\"title\":\"【名】 （Win）（德、荷、缅）温，（英）温（女子教名 Winifred 的昵称）（人名）\",\"icon\":{\"path\":\"assets\\/translate.png\"},\"mods\":{\"alt\":{\"arg\":\"win\",\"subtitle\":\"📣 win\",\"valid\":true},\"cmd\":{\"arg\":\"win\",\"valid\":true,\"subtitle\":\"🔈 win\"}}},{\"valid\":true,\"text\":{\"copy\":\"助手, 运行, 赢得, 获胜\"},\"title\":\"助手, 运行, 赢得, 获胜\",\"subtitle\":\"Win\",\"icon\":{\"path\":\"assets\\/translate.png\"},\"arg\":\"助手, 运行, 赢得, 获胜\",\"mods\":{\"alt\":{\"subtitle\":\"📣 win\",\"valid\":true,\"arg\":\"win\"},\"cmd\":{\"subtitle\":\"🔈 win\",\"arg\":\"win\",\"valid\":true}}},{\"valid\":true,\"icon\":{\"path\":\"assets\\/translate.png\"},\"subtitle\":\"Ne Win\",\"mods\":{\"alt\":{\"valid\":true,\"arg\":\"win\",\"subtitle\":\"📣 win\"},\"cmd\":{\"arg\":\"win\",\"valid\":true,\"subtitle\":\"🔈 win\"}},\"text\":{\"copy\":\"吴奈温, 温将军, 奈温, 尼温将军\"},\"arg\":\"吴奈温, 温将军, 奈温, 尼温将军\",\"title\":\"吴奈温, 温将军, 奈温, 尼温将军\"},{\"arg\":\"双赢, 双赢关系, 暗物质\",\"subtitle\":\"WIN-WIN\",\"mods\":{\"cmd\":{\"valid\":true,\"arg\":\"win\",\"subtitle\":\"🔈 win\"},\"alt\":{\"valid\":true,\"subtitle\":\"📣 win\",\"arg\":\"win\"}},\"text\":{\"copy\":\"双赢, 双赢关系, 暗物质\"},\"valid\":true,\"icon\":{\"path\":\"assets\\/translate.png\"},\"title\":\"双赢, 双赢关系, 暗物质\"}]}\n"
