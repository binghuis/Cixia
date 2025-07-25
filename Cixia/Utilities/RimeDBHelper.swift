import Foundation
import SQLite3

struct RimeDBHelper {
    static func extractHighFrequencyWords(from dbPath: String, limit: Int = 200) -> [(String, Int)] {
        var db: OpaquePointer?
        var result: [(String, Int)] = []
        
        // 打开数据库
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            // Rime 的表名和字段名可能因版本不同略有差异，常见表名为“custom_phrase”
            let query = "SELECT phrase, freq FROM custom_phrase ORDER BY freq DESC LIMIT \(limit);"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    if let cString = sqlite3_column_text(statement, 0) {
                        let word = String(cString: cString)
                        let freq = Int(sqlite3_column_int(statement, 1))
                        result.append((word, freq))
                    }
                }
                sqlite3_finalize(statement)
            }
            sqlite3_close(db)
        }
        return result
    }
} 
