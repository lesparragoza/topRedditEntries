//
//  Extension+UIImage.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 13/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            DispatchQueue.main.async { self.image = image }
        } else {
            DispatchQueue.main.async { self.image = placeholder }
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async { self.image = image }
                }
            }).resume()
        }
    }
}
