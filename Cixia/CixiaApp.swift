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
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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

    @Environment(\.openWindow) private var openWindow
    @AppStorage("autoUpdateEnabled") private var autoUpdateEnabled: Bool = true
    @AppStorage("lastUpdateDate") private var lastUpdateDate: Double = 0

    func tryAutoUpdateIfNeeded() {
        guard autoUpdateEnabled else { return }
        let now = Date()
        let lastDate = Date(timeIntervalSince1970: lastUpdateDate)
        let calendar = Calendar.current
        if !calendar.isDate(now, inSameDayAs: lastDate) {
            RimeDictGenerator.updatePersonalDict()
            lastUpdateDate = now.timeIntervalSince1970
        }
    }

    var body: some Scene {
        MenuBarExtra("词匣", systemImage: "star") {
            ContentView()
                .modelContext(sharedModelContainer.mainContext)
                .onAppear {
                    tryAutoUpdateIfNeeded()
                }
            Divider()
            Button("立即更新") {
                RimeDictGenerator.updatePersonalDict()
                AlertHelper.showInfo(title: "词库已更新", message: "请在Rime输入法菜单中选择“重新部署”以应用新词库。")
            }
            Button("设置…") {
                openWindow(id: "settings")
            }
            Divider()
            Button("退出") {
                NSApplication.shared.terminate(nil)
            }
        }
        .modelContainer(sharedModelContainer)
        WindowGroup(id: "settings") {
            SettingsView()
        }
        .defaultSize(width: 900, height: 600)
    }
}

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidBecomeMain(_:)),
            name: NSWindow.didBecomeMainNotification,
            object: nil
        )
    }

    @objc func windowDidBecomeMain(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.styleMask.insert(.fullSizeContentView)
            window.isMovableByWindowBackground = true
        }
    }
}
