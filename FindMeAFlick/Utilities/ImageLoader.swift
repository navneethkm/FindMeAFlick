//
//  ImageLoader.swift
//  FindMeAFlick
//
//  Created by P10 on 15/09/25.
//


import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    private let session = URLSession(configuration: .default)

    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else { completion(nil); return }
        if let cached = cache.object(forKey: url.absoluteString as NSString) {
            completion(cached); return
        }
        session.dataTask(with: url) { data, resp, err in
            guard let data = data, let img = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }; return
            }
            self.cache.setObject(img, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async { completion(img) }
        }.resume()
    }
}
