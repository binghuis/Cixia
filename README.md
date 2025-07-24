# 词匣（Cixia）

一个基于 SwiftUI + SwiftData 的 macOS 菜单栏应用，自动从 Rime 输入历史中提取高频词语，生成个性化词库，并集成到 Rime 输入法中。支持菜单栏一键更新和自定义设置。

## 主要功能

- 菜单栏常驻，轻量便捷
- 自动统计 Rime 输入历史高频词
- 生成并集成个性化 Rime 词库
- 支持一键更新词库
- 计划支持自定义设置（如统计频率、词库路径等）

## 开发与运行环境

- macOS 13 及以上
- Xcode 15 及以上
- Swift 5.9 及以上

## 如何构建和运行

1. 克隆本项目：
   ```sh
   git clone https://github.com/yourname/cixia.git
   cd cixia
   ```
2. 用 Xcode 打开 `Cixia.xcodeproj`
3. 选择“我的 Mac”作为运行目标
4. 点击运行（Cmd+R），应用会出现在菜单栏

## 如何自定义词库

- 词库生成逻辑位于菜单栏“立即更新词库”按钮（待实现）
- 你可以自定义 Rime 输入历史路径、词库输出路径等参数（后续支持设置页面）
- 生成的词库文件可自动集成到 Rime 输入法

## 常见问题

- **Q: 菜单栏没有显示图标？**
  A: 请确认 macOS 版本在 13 及以上，且已用 MenuBarExtra 实现。
- **Q: 如何修改应用名为中文？**
  A: 在 Info.plist 中设置 `CFBundleDisplayName` 和 `CFBundleName`。

## 许可证

MIT License

---

如有建议或问题，欢迎 Issue 或 PR！
