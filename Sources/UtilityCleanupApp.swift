import SwiftUI
import AppKit

@main
struct UtilityCleanupApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 460, height: 520)
        }
        .windowResizability(.contentSize)
    }
}

struct ContentView: View {
    @State private var statusMessage = "Ready to optimize your Mac"
    @State private var isCleaning = false

    var body: some View {
        VStack(spacing: 0) {
            // Header Banner
            HStack {
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Utility Cleanup")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("macOS System Optimizer")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.85))
                }
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color(red: 0.0, green: 0.47, blue: 0.83), Color(red: 0.22, green: 0.72, blue: 0.96)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            // Status Card
            VStack(spacing: 12) {
                Image(systemName: isCleaning ? "arrow.triangle.2.circlepath.circle.fill" : "checkmark.shield.fill")
                    .font(.system(size: 48))
                    .foregroundColor(Color(red: 0.22, green: 0.72, blue: 0.96))

                Text(statusMessage)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)

                Button(action: runQuickBoost) {
                    Text(isCleaning ? "Optimizing..." : "Smart Boost")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 200)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.0, green: 0.47, blue: 0.83))
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .disabled(isCleaning)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(12)
            .padding()

            // Action Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ActionCard(title: "Clear App Caches", subtitle: "Free temporary files", icon: "folder.badge.minus") {
                    runShell("rm -rf ~/Library/Caches/* 2>/dev/null", doneText: "User app caches cleared!")
                }
                ActionCard(title: "Clean System Logs", subtitle: "Remove old log data", icon: "doc.text.magnifyingglass") {
                    runShell("rm -rf ~/Library/Logs/* 2>/dev/null", doneText: "Old user logs removed!")
                }
                ActionCard(title: "Flush DNS Cache", subtitle: "Refresh network speed", icon: "network") {
                    runShell("dscacheutil -flushcache", doneText: "DNS cache flushed!")
                }
                ActionCard(title: "Empty Trash", subtitle: "Reclaim disk space", icon: "trash.fill") {
                    runShell("rm -rf ~/.Trash/* 2>/dev/null", doneText: "Trash emptied!")
                }
            }
            .padding(.horizontal)

            Spacer()

            Text("Open-Source macOS Utility • MIT License")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
        }
    }

    func runQuickBoost() {
        runShell("rm -rf ~/Library/Caches/* ~/Library/Logs/* 2>/dev/null; dscacheutil -flushcache",
                 doneText: "Smart Boost complete! Caches and logs cleaned.")
    }

    func runShell(_ command: String, doneText: String) {
        isCleaning = true
        statusMessage = "Running cleanup task..."
        DispatchQueue.global(qos: .userInitiated).async {
            let task = Process()
            task.launchPath = "/bin/zsh"
            task.arguments = ["-c", command]
            try? task.run()
            task.waitUntilExit()

            DispatchQueue.main.async {
                isCleaning = false
                statusMessage = doneText
            }
        }
    }
}

struct ActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Color(red: 0.22, green: 0.72, blue: 0.96))
                    .frame(width: 30)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(12)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}
