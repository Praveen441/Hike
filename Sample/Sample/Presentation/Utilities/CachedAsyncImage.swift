import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else if isLoading {
                Color.gray.opacity(0.2)
                ProgressView()
            } else {
                Color.gray.opacity(0.2)
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        guard let url = url else { return }

        let cacheKey = url.absoluteString

        if let cachedImage = ImageCacheManager.shared.image(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        isLoading = true

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    ImageCacheManager.shared.setImage(uiImage, forKey: cacheKey)
                    await MainActor.run {
                        self.image = uiImage
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}
