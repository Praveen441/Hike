import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onTextChange: (String) -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)

            TextField("Search characters...", text: $text)
                .textFieldStyle(.plain)
                .onChange(of: text) { oldValue, newValue in
                    onTextChange(newValue)
                }

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    SearchBar(text: .constant(""), onTextChange: { _ in })
}
