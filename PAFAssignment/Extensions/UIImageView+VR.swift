//
//  UIImageView+VR.swift
//  PAFAssignment
//
//  Created by Rajan on 15/04/24.
//

import Foundation
import UIKit

// Typealias for image completion handler
public typealias ImageCompletionHandler = ((_ status: Bool) -> Void)

// Extension for UIImageView to set thumbnail image
extension UIImageView {
    
    // Function to set thumbnail image for UIImageView
    func setThumbImage(path: String, completion: ImageCompletionHandler?) {
        // Set placeholder image
        self.image = UIImage(named: "noImageThumb")
        
        // Get image from cache or download it
        ImageCache.shared.getImage(urlString: path) { image in
            DispatchQueue.main.async {
                if let image = image {
                    // Set downloaded image
                    self.image = image
                    completion?(true)
                } else {
                    // Set placeholder image if download fails
                    self.image = UIImage(named: "noImageThumb")
                    completion?(false)
                }
            }
        }
    }
}

// Class for caching images
class ImageCache {
    // Singleton instance
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    // Function to get image from cache or download it
    func getImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check if image is already cached
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
        } else {
            // If not cached, download the image
            downloadImage(urlString: urlString) { image in
                // Cache the downloaded image
                if let image = image {
                    self.cache.setObject(image, forKey: urlString as NSString)
                }
                // Return the downloaded image
                completion(image)
            }
        }
    }
    
    // Function to download image from URL
    private func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check if URL is valid
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
              let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Create URLSession data task to download image
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check if there's any error or data
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            // Return the downloaded image
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        // Start the data task
        task.resume()
    }
}
