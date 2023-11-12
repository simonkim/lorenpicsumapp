//
//  PhotoViewModel.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import Foundation
import Combine

enum PhotoError: Error {
    case imageLoadingFailed
}

class PhotoViewModel {
    private var cancellables: Set<AnyCancellable> = []
    private(set) var photos: [Photo] = []

    var photosPublisher: AnyPublisher<[Photo], Never> {
        return photosSubject.eraseToAnyPublisher()
    }

    var photoErrorSubject = PassthroughSubject<PhotoError, Never>()

    private var photosSubject = CurrentValueSubject<[Photo], Never>([])

    func fetchPhotos(page: Int) async {
        let url = "https://picsum.photos/v2/list?page=\(page)&limit=10"

        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
            let newPhotos = try JSONDecoder().decode([Photo].self, from: data)
            photos.append(contentsOf: newPhotos)
            photosSubject.value = photos
        } catch {
            photoErrorSubject.send(PhotoError.imageLoadingFailed)
        }
    }
}
