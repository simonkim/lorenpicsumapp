//
//  PhotoViewModel.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import Foundation
import Combine
import UIKit

enum PhotoError: Error {
    case imageLoadingFailed
}

extension URL {
    static func picsum(page: Int, limit: Int = 10) -> URL {
        return URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)")!
    }
}

class PhotoViewModel {
    private let navigator: PhotoNavigator
    private let cachedImageStore: CachedImageStore

    private var cancellables: Set<AnyCancellable> = []
    private(set) var photos: [Photo] = []

    var photosPublisher: AnyPublisher<[Photo], Never> {
        return photosSubject.eraseToAnyPublisher()
        
    }
    var photoErrorSubject = PassthroughSubject<PhotoError, Never>()

    private var photosSubject = CurrentValueSubject<[Photo], Never>([])

    init(navigator: PhotoNavigator, cachedImageStore: CachedImageStore = CachedImageStore()) {
        self.navigator = navigator
        self.cachedImageStore = cachedImageStore
    }

    func fetchPhotos(page: Int) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: .picsum(page: page))
            let newPhotos = try JSONDecoder().decode([Photo].self, from: data)
            photos.append(contentsOf: newPhotos)
            photosSubject.value = photos
        } catch {
            photoErrorSubject.send(PhotoError.imageLoadingFailed)
        }
    }
    
    func didSelectPhoto(at index: Int) {
        guard index < photos.count else {
            return
        }
        navigator.presentFullSizePhoto(photos[index])
    }
    
    func getImage(for photo: Photo, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let dq = DispatchQueue.main
        Task {

            do {
                let image = try await cachedImageStore.getImage(from: photo.downloadUrl, targetSize: targetSize)
                dq.async {
                    completion(image)
                }
            } catch {
                photoErrorSubject.send(.imageLoadingFailed)
                dq.async {
                    completion(nil)
                }
            }
        }
    }
}
