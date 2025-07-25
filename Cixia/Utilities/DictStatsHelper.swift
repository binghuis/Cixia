import Foundation

struct DictStatsHelper {
    struct WordStat: Identifiable {
        let id = UUID()
        let word: String
        let freq: Int
    }
    
    struct StatsSummary {
        let totalWords: Int
        let totalFreq: Int
        let maxFreq: Int
        let topWords: [WordStat]
    }
    
    static func loadStats(from path: String, topN: Int = 20) -> StatsSummary? {
        guard let content = try? String(contentsOfFile: path, encoding: .utf8) else { return nil }
        var stats: [WordStat] = []
        var inPhraseSection = false
        for line in content.components(separatedBy: .newlines) {
            if line.trimmingCharacters(in: .whitespaces).hasPrefix("custom_phrase:") {
                inPhraseSection = true
                continue
            }
            if inPhraseSection {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.hasPrefix("-") {
                    let parts = trimmed.dropFirst().trimmingCharacters(in: .whitespaces).split(separator: " ")
                    if parts.count >= 2, let freq = Int(parts[1]) {
                        stats.append(WordStat(word: String(parts[0]), freq: freq))
                    }
                }
            }
        }
        let sorted = stats.sorted { $0.freq > $1.freq }
        let totalFreq = stats.reduce(0) { $0 + $1.freq }
        let maxFreq = sorted.first?.freq ?? 0
        return StatsSummary(
            totalWords: stats.count,
            totalFreq: totalFreq,
            maxFreq: maxFreq,
            topWords: Array(sorted.prefix(topN))
        )
    }
} 
