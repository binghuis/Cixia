import SwiftUI
import Charts

struct SettingsView: View {
    @State private var selectedTab = 0
    let tabs: [(icon: String, title: String)] = [
        ("gearshape.fill", "常规"),
        ("chart.bar.fill", "统计"),
        ("brain.head.profile", "大模型")
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(0..<tabs.count, id: \ .self) { idx in
                    Button(action: { selectedTab = idx }) {
                        VStack(spacing: 4) {
                            Image(systemName: tabs[idx].icon)
                                .font(.system(size: 22, weight: .bold))
                            Text(tabs[idx].title)
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(selectedTab == idx ? .black : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.clear)
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 18)
            .background(Color.clear)
            Divider().padding(.bottom, 8)
            ZStack {
                if selectedTab == 0 {
                    GeneralSettingsView()
                } else if selectedTab == 1 {
                    StatsSettingsView()
                } else {
                    AdvancedSettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
        }
        .frame(minWidth: 600, minHeight: 400)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct StatsSettingsView: View {
    @AppStorage("rimeDBPath") private var rimeDBPath: String = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("Library/Rime/luna_pinyin.userdb").path
    @State private var stats: DictStatsHelper.StatsSummary? = nil
    private var rimeDictOutputPath: String {
        let dbURL = URL(fileURLWithPath: rimeDBPath)
        let dir = dbURL.deletingLastPathComponent()
        return dir.appendingPathComponent("custom_high_freq.dict.yaml").path
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.shadcnSubtle)
                    .frame(width: 22)
                Text("词库统计")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.shadcnText)
                Spacer()
                if let stats = stats {
                    HStack(spacing: 18) {
                        Text("总词数：\(stats.totalWords)")
                        Text("总频次：\(stats.totalFreq)")
                        Text("最高频次：\(stats.maxFreq)")
                    }
                    .font(.subheadline)
                } else {
                    Text("暂无数据")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            }
            .padding(.vertical, 10)
            Divider()
            if let stats = stats, !stats.topWords.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 12) {
                        Image(systemName: "list.number")
                            .foregroundColor(.shadcnSubtle)
                            .frame(width: 22)
                        Text("高频词 Top 20")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.shadcnText)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    // 新增：高频词柱状图
                    Chart(stats.topWords) { stat in
                        BarMark(
                            x: .value("词语", stat.word),
                            y: .value("频次", stat.freq)
                        )
                    }
                    .frame(height: 180)
                    .padding(.bottom, 8)
                    // 高频词表
                    ForEach(stats.topWords.enumerated().map { $0 }, id: \ .1.id) { (index, stat) in
                        HStack(spacing: 8) {
                            Text("\(index + 1)")
                                .frame(width: 28, alignment: .trailing)
                                .foregroundColor(.secondary)
                            Text(stat.word)
                                .frame(width: 120, alignment: .leading)
                            ProgressView(value: Double(stat.freq), total: Double(stats.maxFreq))
                                .frame(width: 120)
                            Text("\(stat.freq)")
                                .frame(width: 50, alignment: .trailing)
                        }
                        .font(.system(size: 14))
                        .padding(.vertical, 2)
                        if index < stats.topWords.count - 1 {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 8)
            } else if let stats = stats, stats.topWords.isEmpty {
                HStack {
                    Spacer().frame(width: 34)
                    Text("暂无高频词数据。")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Spacer()
                }
                .padding(.vertical, 10)
            }
            Spacer()
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 20)
        .onAppear(perform: loadStats)
        .onChange(of: rimeDictOutputPath) {
            loadStats()
        }
    }
    private func loadStats() {
        stats = DictStatsHelper.loadStats(from: rimeDictOutputPath)
    }
}

struct AdvancedSettingsView: View {
    @State private var gender: String = ""
    @State private var age: String = ""
    @State private var occupation: String = ""
    @State private var scenario: String = ""
    @State private var result: [String] = []
    @State private var isLoading: Bool = false
    @State private var errorMsg: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                HStack(spacing: 12) {
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(.shadcnSubtle)
                        .frame(width: 22)
                    Text("大模型联想词生成")
                        .font(.system(size: 15))
                        .foregroundColor(.shadcnText)
                    Spacer()
                }
                .padding(.vertical, 10)
                Divider().padding(.leading, 34)
                HStack(spacing: 12) {
                    Image(systemName: "person")
                        .foregroundColor(.shadcnSubtle)
                        .frame(width: 22)
                    Text("性别")
                        .font(.system(size: 15))
                        .foregroundColor(.shadcnText)
                    Spacer(minLength: 12)
                    InputField(placeholder: "男/女", text: $gender)
                        .frame(maxWidth: 220)
                }
                .padding(.vertical, 10)
                Divider().padding(.leading, 34)
                HStack(spacing: 12) {
                    Image(systemName: "number")
                        .foregroundColor(.shadcnSubtle)
                        .frame(width: 22)
                    Text("年龄")
                        .font(.system(size: 15))
                        .foregroundColor(.shadcnText)
                    Spacer(minLength: 12)
                    InputField(placeholder: "28", text: $age)
                        .frame(maxWidth: 220)
                }
                .padding(.vertical, 10)
                Divider().padding(.leading, 34)
                HStack(spacing: 12) {
                    Image(systemName: "briefcase")
                        .foregroundColor(.shadcnSubtle)
                        .frame(width: 22)
                    Text("职业")
                        .font(.system(size: 15))
                        .foregroundColor(.shadcnText)
                    Spacer(minLength: 12)
                    InputField(placeholder: "程序员", text: $occupation)
                        .frame(maxWidth: 220)
                }
                .padding(.vertical, 10)
                Divider().padding(.leading, 34)
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.3.group.bubble.left")
                        .foregroundColor(.shadcnSubtle)
                        .frame(width: 22)
                    Text("场景")
                        .font(.system(size: 15))
                        .foregroundColor(.shadcnText)
                    Spacer(minLength: 12)
                    InputField(placeholder: "办公", text: $scenario)
                        .frame(maxWidth: 220)
                }
                .padding(.vertical, 10)
                Divider().padding(.leading, 34)
            }
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .foregroundColor(.shadcnSubtle)
                    .frame(width: 22)
                Text("生成联想词")
                    .font(.system(size: 15))
                    .foregroundColor(.shadcnText)
                Spacer(minLength: 12)
                Button(action: generateAssociations) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("生成")
                            .font(.system(size: 14))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color(.sRGB, white: 0.97, opacity: 1.0))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color(.sRGB, white: 0.85, opacity: 1.0), lineWidth: 1)
                            )
                            .foregroundColor(.shadcnText)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .fixedSize()
                .disabled(isLoading)
            }
            .padding(.vertical, 10)
            if let errorMsg = errorMsg {
                Text(errorMsg)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 34)
            }
            Divider().padding(.leading, 34)
            if !result.isEmpty {
                Card {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb")
                                .foregroundColor(.shadcnSubtle)
                            Text("联想词")
                                .font(.system(size: 14))
                                .foregroundColor(.shadcnText)
                        }
                        WrapWordsView(words: result)
                            .padding(.top, 2)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 10)
            }
            Spacer()
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 20)
    }

    func generateAssociations() {
        isLoading = true
        errorMsg = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            if gender.isEmpty || age.isEmpty || occupation.isEmpty || scenario.isEmpty {
                errorMsg = "请填写全部信息"
                result = []
                return
            }
            result = [
                "高效", "智能", "便捷", "定制化", "办公助手", "生产力", "AI推荐", "自动化", "个性化", "创新"
            ].shuffled().prefix(6).map { $0 }
        }
    }
}

struct WrapWordsView: View {
    let words: [String]
    var body: some View {
        // 自动换行的词条展示
        VStack(alignment: .leading, spacing: 6) {
            let rows = words.chunked(into: 3)
            ForEach(rows.indices, id: \ .self) { i in
                HStack(spacing: 12) {
                    ForEach(rows[i], id: \ .self) { word in
                        Text(word)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.shadcnText.opacity(0.06))
                            .cornerRadius(6)
                            .font(.system(size: 13))
                    }
                }
            }
        }
    }
}

// 数组分组扩展
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
} 
