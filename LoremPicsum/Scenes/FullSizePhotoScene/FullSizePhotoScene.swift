//
//  FullSizePhotoScene.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import Foundation
import UIKit

protocol FullSizePhotoSceneDelegate: AnyObject {
    func dismissFullSizePhotoScene()
}

/// Full Size Photo Scene construct
/// - Dependencies: 
///   - Photo
///   - FullSizePhotoSceneDelegate
/// - Components
///   - FullSizePhotoViewController
///   - FullSizePhotoViewModel
///   - No Navigator
struct FullSizePhotoScene {
    var photo: Photo
    weak var delegate: FullSizePhotoSceneDelegate?
    
    func viewController() -> UIViewController {
        let viewModel = FullSizePhotoViewModel(
            photo: photo, 
            delegate: delegate
        )
        let viewController = FullSizePhotoViewController(viewModel: viewModel)
        return viewController
    }
}
