//
//  PhotoScene.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import UIKit

/// Lorem Picsum Photo thumbnail browser scene
///
/// Make an instance and call `viewController()` to create the View Controller
/// to present.
/// Encapsulates a Photo Scene constructs such as its View Controller
/// and major components playing their own responsibilities such as:
/// - PhotoViewModel
/// - PhotoNavigator
/// - PhotoViewController
struct PhotoScene {
    func viewController() -> UIViewController {
        let navigationController = UINavigationController()
        let viewModel = PhotoViewModel(
            navigator: PhotoNavigator(navigationController: navigationController)
        )
        let viewController = PhotoViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
        return navigationController
    }
}
