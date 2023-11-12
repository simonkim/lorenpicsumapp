//
//  PhotoNavigator.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import UIKit

/// Responsible for navigation to other scenes
/// View controller construction is delegated to the Scene to be navigated to
/// Navigator's reponsibility is to provide dependencies to the next Scene as well
/// as presenting the Scene view controller via `UIViewController.presentViewController()`
/// or `UINavigationController.pushViewController()`
/// Dependencies are coming in two route:
/// - Parameters of `present...()` functions from ViewModel
/// - Parameters to `init(...)` from its own Scene layer or upper layer
/// `Photo` value is an example dependency coming from ViewModel
/// `navigationController` is an example  dependency from own/upper Scene layer
class PhotoNavigator {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func presentFullSizePhoto(_ photo: Photo) {
        let scene = FullSizePhotoScene(photo: photo, delegate: self)
        let viewController = scene.viewController()

        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PhotoNavigator: FullSizePhotoSceneDelegate {
    func dismissFullSizePhotoScene() {
        // We pushed, we are responsibile pop
        navigationController?.popViewController(animated: true)
    }
}
