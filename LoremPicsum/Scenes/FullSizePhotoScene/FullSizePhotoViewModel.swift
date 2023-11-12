//
//  FullSizePhotoViewModel.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import Foundation
import Combine
import UIKit

class FullSizePhotoViewModel {
    enum Action {
        case dismiss
    }
    var imageUrl: URL { photo.downloadUrl }
    var attribugedCaption: NSAttributedString { photo.makeOverlayLabelAttributedString() }

    private let photo: Photo
    private weak var delegate: FullSizePhotoSceneDelegate?
    
    init(photo: Photo, delegate: FullSizePhotoSceneDelegate?) {
        self.photo = photo
        self.delegate = delegate
    }
    
    func send(_ action: Action) {
        switch action {
        case .dismiss:
            delegate?.dismissFullSizePhotoScene()
        }
    }
}

extension Photo {
    func makeOverlayLabelAttributedString() -> NSAttributedString {
        let authorAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.white
        ]

        let sizeAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
            .foregroundColor: UIColor.white
        ]

        let authorText = NSAttributedString(string: "Author: \(self.author)\n", attributes: authorAttributes)
        let sizeText = NSAttributedString(string: "Size: \(self.width) x \(self.height)", attributes: sizeAttributes)

        let combinedText = NSMutableAttributedString()
        combinedText.append(authorText)
        combinedText.append(sizeText)

        return combinedText
    }
}
