import SwiftUI

struct InputField: View {
    var placeholder: String
    @Binding var text: String
    var isError: Bool = false
    var errorMessage: String? = nil

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color(.sRGB, white: 1.0, opacity: 1.0))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(isError ? Color.red : Color(.sRGB, white: 0.7, opacity: 1.0), lineWidth: isError ? 1.2 : 0.8)
                    )
            )
            .font(.system(size: 13))
            .frame(minWidth: 240, maxWidth: 280) // 更长
            .textFieldStyle(PlainTextFieldStyle())
            .help(isError ? (errorMessage ?? "") : "")
    }
} 