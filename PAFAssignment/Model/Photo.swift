//
//  Photo.swift
//  PAFAssignment
//
//  Created by Rajan on 15/04/24.
//

// Struct to represent URLs for different image sizes
struct URLs: Decodable {
    var full: String?       // Full-sized image URL
    var regular: String?    // Regular-sized image URL
    var small: String?      // Small-sized image URL
    var thumb: String?      // Thumbnail-sized image URL
    var small_s3: String?   // URL for small size on S3 storage
}

// Struct to represent a photo
struct Photo: Decodable {
    
    var id: String?         // Unique identifier for the photo
    var width: Double?      // Width of the photo
    var height: Double?     // Height of the photo
    var urls: URLs          // URLs for different sizes of the photo
}




