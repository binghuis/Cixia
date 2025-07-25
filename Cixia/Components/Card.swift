import SwiftUI

struct Card<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            content
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.shadcnCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.shadcnBorder, lineWidth: 1)
                )
                .shadow(color: Color.shadcnShadow, radius: 8, x: 0, y: 2)
        )
        .padding(.vertical, 10)
    }
} 