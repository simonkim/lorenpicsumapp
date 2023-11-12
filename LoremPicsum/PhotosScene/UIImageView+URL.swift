//
//  UIImageView+URL.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

// UIImageView+Extensions.swift
import UIKit

extension UIImageView {
    /// Asynchronously loads and displays image from the url. Placeholder image is displays until
    /// image from the url is available
    /// - Parameters:
    ///   - url: URL to a web image
    ///   - placeholder: place holder image to be displayed until download is on going
    ///
    /// Example usage:
    /// ```
    /// do {
    /// try await imageView.loadImage(
    ///         from: URL(string: "https://example.com/image.jpg"),
    ///         placeholder: UIImage(named: "placeholderImage")
    ///     )
    /// } catch {
    ///     // Handle error
    ///     print("Failed to load image: \(error)")
    /// }
    /// ```
    func loadImage(from url: URL?, placeholder: UIImage? = nil) async throws {
        self.image = placeholder

        guard let url = url else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            DispatchQueue.main.async {
                let downloadedImage = UIImage(data: data)
                self.image = downloadedImage
            }
        } catch {
            throw error
        }
    }
}


