import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("autoUpdateEnabled") private var autoUpdateEnabled: Bool = true
    @AppStorage("rimeDBPath") private var rimeDBPath: String = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("Library/Rime/luna_pinyin.userdb").path
    @State private var isEditingRimePath = false
    @State private var tempRimeDBPath = ""
    @FocusState private var inputFocused: Bool

    private var rimeDictOutputPath: String {
        let dbURL = URL(fileURLWithPath: rimeDBPath)
        let dir = dbURL.deletingLastPathComponent()
        return dir.appendingPathComponent("custom_high_freq.dict.yaml").path
    }
    private var rimeConfigPath: String {
        let dbURL = URL(fileURLWithPath: rimeDBPath)
        let dir = dbURL.deletingLastPathComponent()
        return dir.appendingPathComponent("luna_pinyin.custom.yaml").path
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(.shadcnSubtle)
                        .frame(width: 22)
                    Text("每天自动更新")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.shadcnText)
                    Spacer()
                    Toggle("", isOn: $autoUpdateEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .shadcnText))
                        .labelsHidden()
                }
                .padding(.vertical, 10)
                Divider().padding(.leading, 34)
                HStack(spacing: 12) {
                    Image(systemName: "folder")
                        .foregroundColor(.shadcnSubtle)
                        .frame(width: 22)
                    Text("Rime 数据库路径")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.shadcnText)
                    Spacer()
                    InputField(
                        placeholder: "Rime .db 路径",
                        text: isEditingRimePath ? $tempRimeDBPath : .constant(rimeDBPath),
                        isError: isEditingRimePath ? !fileExists(tempRimeDBPath) : false,
                        errorMessage: isEditingRimePath && !fileExists(tempRimeDBPath) ? "文件不存在，请检查路径。" : nil
                    )
                    .frame(maxWidth: 220)
                    .disabled(!isEditingRimePath)
                    .allowsHitTesting(isEditingRimePath)
                    .opacity(isEditingRimePath ? 1 : 0.7)
                    if isEditingRimePath {
                        Button(action: {
                            rimeDBPath = tempRimeDBPath
                            isEditingRimePath = false
                        }) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color.primary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Button(action: {
                            tempRimeDBPath = rimeDBPath
                            isEditingRimePath = true
                        }) {
                            Image(systemName: "pencil")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color.primary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 10)
                Divider().padding(.leading, 34)
                HStack(spacing: 12) {
                    Image(systemName: "doc.text")
                        .foregroundColor(.shadcnSubtle)
                        .frame(width: 22)
                    Text("词库输出文件")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.shadcnText)
                    Spacer()
                    Text(rimeDictOutputPath)
                        .font(.caption)
                        .foregroundColor(.shadcnSubtle)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(width: 260, alignment: .trailing)
                }
                .padding(.vertical, 10)
                Divider().padding(.leading, 34)
                HStack(spacing: 12) {
                    Image(systemName: "gear")
                        .foregroundColor(.shadcnSubtle)
                        .frame(width: 22)
                    Text("Rime 配置文件")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.shadcnText)
                    Spacer()
                    Text(rimeConfigPath)
                        .font(.caption)
                        .foregroundColor(.shadcnSubtle)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(width: 260, alignment: .trailing)
                }
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 8)
            Spacer()
            HStack {
                Spacer()
                Text("如无特殊需求，保持默认即可。")
                    .font(.footnote)
                    .foregroundColor(.shadcnSubtle)
                Spacer()
            }
            .padding(.top, 12)
            Spacer()
                .frame(height: 20)
                .contentShape(Rectangle())
                .onTapGesture {
                    isEditingRimePath = false
                }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 20)
    }

    private func fileExists(_ path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
} 