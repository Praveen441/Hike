import SwiftUI

struct DetailRow: View {
    @ObservedObject var viewModel: DetailRowViewModel

    init(viewModel: DetailRowViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Text(viewModel.displayLabel)
                .foregroundStyle(.secondary)
            Spacer()
            Text(viewModel.displayValue)
                .fontWeight(.semibold)
                .lineLimit(2)
        }
        .font(.caption)
    }
}
