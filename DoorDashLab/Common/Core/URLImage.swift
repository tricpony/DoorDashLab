//
//  URLImage.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import Foundation
import UIKit

typealias URLImageCompletion = (UIImage?, URLResponse?, Error?) -> Void

/// Fetches a UIImage from a URL asynchronously, calling the completion handler upon success or failure.
public struct URLImage {

    /// Fetches a UIImage from a URL asynchronously, calling the completion handler upon success or failure.
    ///
    /// - parameter url: The URL of an image to fetch
    /// - parameter completion: An escaping closure called on the Main thread, with
    ///             image, urlResponse, or error
    ///             when the call finishes or an error occurs
    static func fetchImageURL(_ url: URL, completion: @escaping URLImageCompletion) {
        let requestSession = URLSession.shared
        let request = URLRequest(url: url)
        
        requestSession.dataTask(with: request) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            var imageFromURL: UIImage?
            if let data = data {
                imageFromURL = UIImage(data: data)
            }

            DispatchQueue.main.async {
                completion(imageFromURL, urlResponse, error)
            }
            }.resume()
    }
}
