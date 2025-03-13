![IMG_0148](https://github.com/user-attachments/assets/e62652de-6e3f-494a-b8a4-ec6cfd6f91f5)
![IMG_0149](https://github.com/user-attachments/assets/63c01e5a-cba1-49d2-afb6-9219694ce0ea)
![IMG_0150](https://github.com/user-attachments/assets/1d3a11e9-219b-4f49-829c-09a9434d21bf)

TouchArt is an app that provides visual and auditory features to enhance the artwork-viewing experience for low-vision users in a mobile environment.


I used images of Vincent van Gogh’s The Starry Night and Claude Monet’s Poppy Field.
Both works are in the public domain, as their copyrights have expired, allowing free use.
I downloaded these images from a website operated by the Korean Copyright Commission.  


This app aims to help low vision users who can distinguish colors but have difficulty recognizing the structure of images to appreciate artwork even in mobile environments. 
The main target users are those who use VoiceOver, so accessibility features such as SwiftUI's AccessibilityHint are utilized to guide app usage.

In the image appreciation stage, the app detects the user's drag gesture and displays the color at that location across the entire screen, allowing users to perceive color changes in the image more clearly.
In addition, through a double-tap gesture, the app provides an explanation of the image at that location to deliver additional information.

To implement these two features, the app must accurately recognize the coordinates of user interaction, which necessitates temporarily disabling VoiceOver.
While VoiceOver is disabled, voice guidance is provided using AVFoundation's AVSpeechSynthesizer to provide users with a smooth interaction experience. 
