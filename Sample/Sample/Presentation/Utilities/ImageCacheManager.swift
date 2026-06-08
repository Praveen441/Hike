import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()

    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "com.sample.imagecache", attributes: .concurrent)

    private init() {
        cache.totalCostLimit = 100 * 1024 * 1024
    }

    func image(forKey key: String) -> UIImage? {
        queue.sync {
            cache.object(forKey: key as NSString)
        }
    }

    func setImage(_ image: UIImage, forKey key: String) {
        queue.async(flags: .barrier) {
            self.cache.setObject(image, forKey: key as NSString, cost: image.pngData()?.count ?? 0)
        }
    }

    func removeImage(forKey key: String) {
        queue.async(flags: .barrier) {
            self.cache.removeObject(forKey: key as NSString)
        }
    }

    func clearCache() {
        queue.async(flags: .barrier) {
            self.cache.removeAllObjects()
        }
    }
}
