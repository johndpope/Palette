//
//  FlikrAPIModel.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-24.
//  Copyright © 2016 Malecks. All rights reserved.
//

/* API KEY: d23df03e03b9043a43b88e43af741293  SECRET: 5df5d7425e97861d */

import Foundation
import Alamofire

class FlikrPhoto {
    let photoURL: String!
    let photoTitle: String!
    
    init (url: String, title: String) {
        self.photoURL = url
        self.photoTitle = title
    }
}

class FlikrAPIManager {
    private let apiKey = "d23df03e03b9043a43b88e43af741293"
    private let method = "flickr.interestingness.getList"
    private let perPage = 10
    
    var pageNumber = 1
    var maxPage = 50
    
    func retrievePhotos (completion:@escaping (_ photos: [FlikrPhoto], _ error: Error?) -> ()) {
        let url = "https://api.flickr.com/services/rest/?" +
                "method=\(method)" +
                "&api_key=\(apiKey)" +
                "&per_page=\(perPage)" +
                "&page=\(pageNumber)" +
                "&extras=url_m" +
                "&format=json" +
                "&nojsoncallback=1"

        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.result.value as? NSDictionary,
                    let photos = data["photos"] as? NSDictionary,
                    let photo = photos["photo"] as? [NSDictionary] else {
                        
                        print("Error parsing JSON")
                        return
                }
                
                    var flikrPhotos: [FlikrPhoto] = []
                    for item in photo {
                        let imageURL: String = item["url_m"] as! String
                        let imageTitle: String = item["title"] as! String
                        
                        let newFlikrPhoto = FlikrPhoto(url: imageURL, title: imageTitle)
                        flikrPhotos.append(newFlikrPhoto)
                    }
                    completion(flikrPhotos, nil)
                
            case .failure(let error):
                completion([], error)
            }
        }
        
    }
}
