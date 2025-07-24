//
//  CixiaApp.swift
//  Cixia
//
//  Created by 宋秉徽 on 2025/7/24.
//

import SwiftUI
import SwiftData

@main
struct CixiaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        MenuBarExtra("词匣", systemImage: "star") {
            ContentView()
                .modelContext(sharedModelContainer.mainContext)
            Divider()
            Button("立即更新词库") {
                // TODO: 实现词库更新逻辑
            }
            Button("设置…") {
                // TODO: 弹出设置窗口
            }
            Divider()
            Button("退出") {
                NSApplication.shared.terminate(nil)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
