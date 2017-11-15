//
//  AppPhotoAlbum.swift
//  ReceiptBox
//
//  Created by Nick Hultz on 11/11/17.
//  Copyright © 2017 nhultz. All rights reserved.
//

import Foundation
import Photos

class AppPhotoAlbum {

    static let albumTitle = "Receipts"
    static let shared = AppPhotoAlbum()

    internal var assetCollection: PHAssetCollection?

    private init() {}

    func save(_ image: UIImage?) {
        guard let image = image else { return }

        requestAuthorizationIfNeeded { (authorized) in
            guard authorized == true else {
                print("Not authorized to save image to album.  Returning.")
                return
            }

            guard let assetCollection = self.assetCollection else { return }

            PHPhotoLibrary.shared().performChanges({

                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                guard
                    let createdAsset = request.placeholderForCreatedAsset,
                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                else {
                    return
                }

                albumChangeRequest.addAssets([createdAsset] as NSArray)

            }, completionHandler: nil)
        }
    }
}

internal extension AppPhotoAlbum {

    func requestAuthorizationIfNeeded(_ completion: @escaping ((_ success: Bool) -> Void)) {
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {
                completion(false)
                return
            }

            if let collection = self.fetchAssetCollectionForAlbum() {
                self.assetCollection = collection
                completion(true)
            } else {
                self.createAlbum(completion)
            }
        }
    }

    func createAlbum(_ completion: @escaping ((_ success: Bool) -> Void)) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: AppPhotoAlbum.albumTitle)
        }) { (success, error) in
            defer {
                completion(success)
            }

            guard error == nil else {
                print("Error creating new album: \(error!)!")
                return
            }

            self.assetCollection = self.fetchAssetCollectionForAlbum()
        }
    }

    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", AppPhotoAlbum.albumTitle)

        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collection.firstObject
    }
}
