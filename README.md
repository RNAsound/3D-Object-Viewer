3D Object Viewer
====
Created by: Aren Akian

## About
This is an app that allows the user to sign in, choose a 3D object scan from a gallery of thumbnails, and interact with it in a 3D scene (by rotating, zooming, and panning around the object).  

## Demos
<img src="Screenshots/ObjectViewer Short Demo.gif" width="300" />
<img src="Screenshots/ObjectViewer Full Demo.gif" width="300" />


## Screenshots
<img src="Screenshots/ObjectViewer1.png" width="300" />
<img src="Screenshots/ObjectViewer2.png" width="300" />
<img src="Screenshots/ObjectViewer3.png" width="300" />
<img src="Screenshots/ObjectViewer4.png" width="300" />


## Design 
- I structured the app following MVVM principles, using dependency injection to share data across the app. 
- I used SwiftData to store the 3D .usdz files, and persist the user’s log-in state. 
- Rather than using singletons (which are considered an “anti-pattern”), I implemented dependency injection using @Environment and SwiftData ModelContext. 
    - This allows for access to the persistent store and authentication service across the app, wherever needed. 
    - Also improves testability and flexibility

<img src="3D Object Viewer System-1.png" width="700" />

## Models
### User
Represents the user
- var id - the UUID of the user
- var email - the user’s email address
- var password - the user’s password (we would not store this)

### ScanModel
Represents a 3D scan
- var fileURL - the URL of the 3D scan file (in .usdz format)

## Auth
I abstracted out the Auth layer into AuthViewModel and AuthService to simulate a mock AWS integration. 

### AuthService 
Contains the current user (if logged in), and AuthService.signIn() returns a User object. 
- Right now, it simply checks against our mock user data, but here AWS could be integrated, and return decoded JSON data from our database as a User.

### AuthViewModel 
interfaces with AuthService to facilitate log-in, and handles SwiftData storage of the current User in order to persist log-in State.


## Views
### Main.App View
If the user is not logged in, we show the AuthView. 
- Otherwise, we show the GalleryView.
- This is controlled by the AuthViewModel’s isAuthenticated Boolean 


### AuthView
This is where the User logs in. AuthView captures the AuthViewModel from the environment, and passes user inputs through it to the authService. 
To log into the app, the required credentials are:
- email: user@example.com
- password: password

### GalleryView
Once the user is logged in, GalleryView serves as the main view of our app.
- Thumbnails are presented in a gallery, contained in a SwiftUI list.
- Each thumbnail is an instance of ThumbnailView. 
- Tapping on a list item in the gallery navigates to a ScanFileView for that specific file.
- User can delete a file by swiping left on a list item, and can restore any deleted files by pulling down to refresh. 

### ThumbnailView
Displays a thumbnail of a .usdz file, 
- Thumbnail generated using Swift’s QuickLookThumbnailing framework, and displayed along with  the name of the input file. 

### ScanFileView
Using SceneKit, this file loads and displays provided 3D object files in a view that allows the user to rotate, zoom, and pan around the object in a 3D scene. 
- There is also a resetView() function, that is triggered via double tapping the 3D scene or the button at the bottom of the view. 


## Basic Workflow Overview
### 1. User launches the app
- AuthViewModel will try fetchSavedUser to see if user has previously logged in
- If no user is found, AuthView is shown
    - Once user enters information and presses “Sign In”, AuthViewModel saves their credentials to persistent store using saveUserCredentials(), 
    - and sets isAuthenticated to true. This triggers a State change in the main app view, and GalleryView is shown. 
- Else, user is automatically logged in, and GalleryView is shown

### 2. GalleryView appears
- The program loads the mock data into the model context, and updates the view to display a gallery of ThumbnailViews corresponding to each file.  
- Each ThumbnailView receives a URL pointing to the mock data in the app bundle
- The Thumbnail view generates a thumbnail for the input file using QuickLook Thumbnailing, and displays the file name alongside it.

### 3. ScanFileView appears
- The user selects a 3D model from the gallery, and the app navigates to a ScanFileView
- The ScanFileView receives a URL for a 3D object file, sets up a scene using SceneKit, loads in the input 3D file, and positions the camera node. 
- the user can interact with the 3D object in the ScanFileView by dragging, rotating, and zooming to view the object from any angle. 


## Future considerations
- The app has been left open to integration of some backend service (eg. AWS)  in the AuthService
    - Combined with proper Row Level Security, this would integrate very nicely with the authViewModel to provide safe and secure authentication
- I would abstract the SwiftData layer into a LocalStorageService, allowing for more flexibility and testability
- GalleryView could also provide an “add scan” button, that would navigate the user to a view where they can scan an object of their own. Similarly, a “load scan” button could launch a FileImporter, allowing the user to load .usdz files from their device.  

