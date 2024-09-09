//
//  PhotoViewModel.swift
//  PAFAssignment
//
//  Created by Rajan on 15/04/24.
//

import UIKit

class PhotoViewModel: NSObject {
    
    var photos: [Photo] = []    // Array to store fetched photos
    
    // Function to fetch photos from the API
    // Parameters:
    //   - page: Page number of photos to fetch
    //   - perPage: Number of photos per page
    //   - completion: Closure to be called after fetching photos, returns an optional error message
    
    func fetchPhotos(page: Int, perPage: Int, completion: @escaping (String?) -> Void) {
        
        // Request photos from the API using shared instance of APIManager
        APIManager.shared.request(url: APPURL.apiURL(mode: .getPhotos(perPage, page)), expecting: [Photo].self) { data, error in
            
            // Check if there's an error returned from the API request
            if let error = error {
                completion(error.localizedDescription)   // Pass error message to completion handler
            }
            
            // Check if data is returned from the API request
            else if let data = data {
                self.photos += data    // Append fetched photos to the array
                
                completion(nil)    // Call completion handler with no error
            }
            else {
                completion("Unable to load more photos.")    // If neither data nor error is returned, indicate failure
            }
        }
    }
}
