//
//  THImageManager.swift
//  THTiledImageView
//
//  Created by 홍창남 on 2018. 2. 8..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import Foundation
import Kingfisher

typealias THImageDownloaderCompletion = (UIImage?, URL?, Error?) -> Void
typealias THImageCacheCompletion = () -> Void

class THImageDownloadManager {
    static let `default` = THImageDownloadManager()
    
    func downloadEachTiles(path url: URL, completion: @escaping THImageDownloaderCompletion) {
        ImageDownloader.default.downloadImage(with: url, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let imageResult):
                completion(imageResult.image, imageResult.url, nil)
            case .failure(let error):
                completion(nil, nil, error)
            }
        }
    }
}

class THImageCacheManager {

    static let `default` = THImageCacheManager()

    func cacheTiles(image: UIImage, imageIdentifier: String, completion: @escaping THImageCacheCompletion) {
        ImageCache.default.store(image, original: nil, forKey: imageIdentifier) { result in
            completion()
        }
    }
    
    func retrieveTiles(key: String) async -> UIImage? {
        do {
            let image = try await ImageCache.default.retrieveImageInDiskCache(forKey: key)
            return image
        } catch {
            debugPrint("Failed to retrieve image for key \(key): \(error.localizedDescription)")
            return nil
        }
    }


}
