import Foundation

struct RimeDictGenerator {
    static func updatePersonalDict() {
        let dbPath = UserDefaults.standard.string(forKey: "rimeDBPath") ??
        FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Rime/luna_pinyin.userdb").path
        
        let dbURL = URL(fileURLWithPath: dbPath)
        let dir = dbURL.deletingLastPathComponent()
        let dictPath = dir.appendingPathComponent("custom_high_freq.dict.yaml").path
        let configPath = dir.appendingPathComponent("luna_pinyin.custom.yaml").path
        
        // 1. 生成 custom_high_freq.dict.yaml
        let words = RimeDBHelper.extractHighFrequencyWords(from: dbPath, limit: 200)
        var dictYaml = """
        ---
        name: custom_high_freq
        version: \"1.0\"
        sort: by_weight
        ...
        custom_phrase:
        """
        for (word, freq) in words {
            dictYaml += "\n  - \(word) \(freq)"
        }
        FileHelper.write(dictYaml, to: dictPath)
        
        // 2. 生成 luna_pinyin.custom.yaml
        let configYaml = """
        schema: luna_pinyin
        translator:
          dictionary: luna_pinyin
          enable_user_dict: true
          user_dict: custom_high_freq
        """
        FileHelper.write(configYaml, to: configPath)
    }
} 
