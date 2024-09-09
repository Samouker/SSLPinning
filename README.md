# Image Viewer iOS Application

This iOS application is developed to efficiently load and display images in a scrollable grid using the Unsplash API. It incorporates a caching mechanism for storing images retrieved from the API for efficient retrieval and gracefully handles network errors and image loading failures. Additionally, it highlights security implementations using SSL Pinning for enhanced security.

## Features

- Asynchronously loads images from the Unsplash API URLs.
- Implements caching mechanism for efficient retrieval of images.
- Handles network errors and image loading failures gracefully.
- Implements SSL Pinning for enhanced security.
- Developed using Swift 5.0.
- Follows the MVVM (Model-View-ViewModel) architecture pattern.

## Requirements

- Xcode (Version 15.3)
- Swift (Version 5.0)
- Internet connection for API data retrieval

## Setup Instructions

1. Clone or download the repository to your local machine.
2. Open the project in Xcode.
3. Build and run the project on a simulator or a physical iOS device.

## Implementation Details

### Models

The application includes two main models:

- `URLs`: Contains URLs for various image sizes.
- `Photo`: Represents a photo object retrieved from the API, containing an ID, dimensions, and URLs for different image sizes.

### ViewModel

- `PhotoViewModel`: Manages the retrieval and handling of photo data from the Unsplash API. It fetches photos asynchronously and stores them for display.

### Controller and Views

The main controller `ViewController` manages the collection view displaying the photos. It interacts with the `PhotoViewModel` to fetch and display photos efficiently. The `PhotoCell` class represents the collection view cell used to display individual photos.

### Networking and Security

- **APIManager**: Handles API requests using URLSession and implements SSL pinning for enhanced security. It ensures that the server's certificate matches a locally stored certificate for verification.
- **SSL Pinning**: Provides an additional layer of security by validating the server's SSL certificate against a locally stored certificate. This prevents potential attacks, such as man-in-the-middle attacks, by ensuring that the app only communicates with trusted servers.

### Image Caching
The `ImageCache` class is responsible for caching images retrieved from URLs to improve performance and reduce network usage. It utilizes a singleton pattern to ensure a single instance throughout the application.

### Usage

- When the app is launched, photos will be loaded and displayed in a scrollable grid. At the bottom of the grid, a label is included to provide a reference for the number of images displayed.
- If any image fails to load for any reason, a button is provided in the top corner of the grid to re-fetch the respective image. By tapping the button, you will be able to re-fetch the image.
- If the device is offline, a message will inform the user to check their internet connection.
- When the user scrolls to the bottom of the collection view, the app will automatically fetch the latest images from the API and display them. The page size for each fetch is 30 images. Page size can be change by changing value of constatn veriable `perPage = 30`
- Tapping the retry button on any failed image load will attempt to reload the image.

<div style="display: flex; flex-direction: row;">
    <img src="ScreenShots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-04-16%20at%2002.20.06.png" alt="Screenshot" width="400">
    <img src="ScreenShots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-04-16%20at%2002.35.40.png" alt="Screenshot" width="400">
</div>

## Note

- Ensure that the latest Xcode version is installed to avoid compilation issues.
- Effective error handling and informative messages are implemented throughout the application.

## Authors

- Rajan Samouker.

## Acknowledgments

- This project utilizes the Unsplash API for fetching images.

