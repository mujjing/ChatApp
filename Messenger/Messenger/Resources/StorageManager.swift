//
//  StorageManager.swift
//  Messenger
//
//  Created by Jh's MacbookPro on 2020/06/26.
//  Copyright © 2020 JH. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager{
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    // /images/accont_picture.png
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    // uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            guard error == nil else {
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else{
                    print("")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("download url return : \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors : Error{
        case failedToUpload
        case failedToGetDownloadURL
    }
}
