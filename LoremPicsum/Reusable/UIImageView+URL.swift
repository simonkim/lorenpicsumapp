//
//  UIImageView+URL.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import UIKit
import Combine

import UIKit
import Combine

extension UIImageView {
    /// Asynchronously loads an image from the specified URL, displaying a placeholder while fetching.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to load.
    ///   - placeholder: An optional placeholder image to display while fetching the actual image.
    ///   - targetSize: The target size (in points) of the image to be displayed.
    ///   - scale: The scale factor to be applied when creating the thumbnail. Default is 1.0.
    /// - Throws: An error if the image cannot be loaded or created.
    func loadImage(from url: URL, targetSize: CGSize? = nil, scale: CGFloat = 1.0, placeholder: UIImage? = nil) async throws {
        self.image = placeholder
        do {
            self.image = try await .load(from: url, targetThumbnailSize: targetSize, scale: scale)
        } catch {
            throw error
        }
    }
}
