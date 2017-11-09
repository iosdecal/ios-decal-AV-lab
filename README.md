# Lab 5 : AVFoundation #
Note: You will need an iPhone or iPad with iOS 11 installed and lightning USB cable for this lab.

## Overview ##

![](/README-images/camera-preview.gif)

In today's lab, you'll get some experience with part of AVFoundation by creating a camera for your Snapchat Clone, while also becoming more familiar with handling user permissions and looking up information in Apple Developer Documentation. Since this lab requires a hardware camera, you'll be testing your application on an iOS device (iPhone/iPad).

This assignment builds off hw3 pt2. Instead of using your own Firebase console, we've connected the project to a shared Firebase project, so that you can send snaps to the entire class. You can view the console here: https://console.firebase.google.com/u/3/project/ios-snapchat, though you will not need to interact with it for this lab. 

## Getting Started ##

Begin by downloading the repo, and opening "Snapchat Camera Lab.xcworkspace". Having finished homwork 3, you should already be familiar with the code provided. 

For this lab, **you will only be editing ImagePickerViewController.swift and it's corresponding View Controller in Storyboard.**

## Part 1: Connecting your iOS Device ##

Before writing any code, you'll need to connect your iPhone or iPad to your computer via a USB cable. Once you've done that, tap on the simulators drop down, and select your device name

![](/README-images/README-1.png)

Try building. You'll see an error pop up saying "Signing for "snapChatProject" requires a development team. Select a development team in the project editor." To fix this, you'll need to add a signing account, which you can do using an Apple ID. To set your Team Profile, **Open your project file in Xcode, and click "Add Account" in the Team dropdown (see image)**.

![](/README-images/README-2.png)

Once you've set your Team as your Apple ID, try running your app again on your device. If everything's working, you'll see a blank gray view with some buttons (that don't work yet). If you still are having an issue, ask one of the TA's for help (you may need to change your deployment target from 11.1 to 11.0 if your phone is not running the lastest iOS version). The first build on your device should take a few minutes to complete, so give Xcode some time to build.

## Part 2: Connecting Outlets ##
Just so you become more familiar with the which views are which, we left the outlets and actions in **ImagePickerViewController.swift** unconnected to storyboard. **Go ahead and connect these outlets and actions in ImagePickerViewController.swift to Main.storyboard**. Make sure to read the comments above each IBOutlet and IBAction, so that you are sure you are connecting them correctly.
 
 > Tip: may find it helpful to open the **Document Outline**. You can drag from Outlets and Actions in code to UI elements in the Document Outline if you find that easier. If you need to delete any connections you made, tap on your ViewController in the Document Outline or in Storyboard, and open the **Connections Inspector** to see all of your connections and delete any if necessary.
 
![](/README-images/README-3.png)

If you connected all of the outlets AND actions correctly, try taking a picture. You should see an image of squirrel with a neat little leaf hat. Though sending squirrel snaps to the rest of the class is fun, let's add in our own custom camera to send some photo snaps!

## Part 3: Getting User Permissions and Capturing from User's Device ##

To view real time data collected from your device's camera, we'll be using AVFoundation's [AVCaptureSession](https://developer.apple.com/reference/avfoundation/avcapturesession). Notice the "AVFoundation" import at the top of the file.

We've defined the following AVFoundation related instance variables for you already, but you should already be familiar with `AVCaptureSession` and `AVCapturePhotoOutput` from lecture. 

```swift
// middleman between AVCaptureInput and AVCaptureOutput
var captureSession: AVCaptureSession?

// view that will let us preview what is being captured from our input
var previewLayer : AVCaptureVideoPreviewLayer?

// used to capture a single photo from our capture device
let photoOutput = AVCapturePhotoOutput()
```
    
### Part 3.1: Configuring Capture Session - creating a preview layer for displaying video###

Notice the two commented out methods in `viewDidLoad`. These are two helper methods we've defined for the lab to help organize our code, but you will need to fill them out. To begin, 

 1.instantiate an `AVCaptureSession` object in `viewDidLoad`, and set it equal to `captureSession`. We will be using only one session throughout this lab, so we need to keep a reference to it. 
 2. uncomment the call to the helper function `createAndLayoutPreviewLayer` in `viewDidLoad`
 3. finish implementing the `createPreviewLayer` function. You can learn about preview layers here [AVCapturePreviewLayer](https://developer.apple.com/reference/avfoundation/avcapturepreviewlayer). All you will need to do is create an instance of AVCapturePreviewLayer, using our captureSession, and set it equal to  `previewLayer`.

Once you've finished this, you've now created a view to display video from your camera. However, you won't see any video showing up yet when you run, since we haven't set our `captureSession`'s input. Let's do that now!

### Part 3.2: Configuring Capture Session - setting inputs and outputs ###
Go back to `viewDidLoad` and uncomment the helper method `configureCaptureSession`. Inside the `configureCaptureSession` function, you will need to do the following:

 1. Create an input using a device, and add it to `captureSession`. This will allow us to receive data from the device (camera) while the session is running.
 2. Create and add an (`AVCapturePhotoOutput`) output for our session . Use the `photoOutput` variable we defined for you, so that we can access this output outside of this method body.
  
> Note: The lecture slides will help you if your not sure what to do. Feel free to rename `someConstantWithABadName`.
    
Once you've finished, try running your app. You should be able to see video data from your camera in the `previewLayer`. Try taking a photo - looks like we still have a problem (you should still see the squirrel at this point). To fix this, we need to capture the photo from our session input, using our session's output, which we'll do in the next step.

## Part 4: Taking a photo using AVCapturePhoto  ##
Now, we'll implement taking a photo, and then displaying this image in our imageView (`imageViewOverlay`). To do this, we will need to use [`AVCapturePhoto`](https://developer.apple.com/documentation/avfoundation/avcapturephoto) and [`AVCapturePhotoCaptureDelegate`](https://developer.apple.com/documentation/avfoundation/avcapturephotocapturedelegate). Specifically, you will need to:

 1. [Capture a photo](https://developer.apple.com/documentation/avfoundation/avcapturephotooutput/1648765-capturephoto) using your `photoOutput` object in the `takePhoto` IBAction. Remember, this doesn't save the image anywhere, we will handle this using `AVCapturePhotoCaptureDelegate` in the next step.
 2. Define the `AVCapturePhotoCaptureDelegate` method [`photoOutput(didFinishProcessingPhoto: ...)`](https://developer.apple.com/documentation/avfoundation/avcapturephotocapturedelegate/2873949-photooutput). (We did not add this in for you, you will need to create it and make sure your view controller class conforms to the delegate protocol).
    
Inside of the photoOutput(didFinishProcessingPhoto: ...) function, you will need to do the following (in this order):

 3. Create a UIImage using the `photo` parameter. [Slide 56](http://iosdecal.com/fall-2017-slides/lecture9.pdf#page=56) from lecture will help you if your stuck.
 4. Set `selectedImage` to this `UIImage`
 5. Call `toggleUI(isInPreviewMode: true)`. This is already implemented for you, and it simply updates the UI elements on the screen - (i.e., once the picture is taken, we want to present the send button, hide the camera flip button, etc.)

Once you've finished this step, you should be able to take and send photos! 

## Part 5 (OPTIONAL BUT ALSO NOT THAT BAD): Supporting front and back camera ## 
Right now, we can only take pictures using the front camera. To add support for toggling between the front camera and the rear facing camera, go back to the function we created at the beginning of the lab, `configureCaptureSession`. Right now `someConstantWithABadName` (which you probably know by is a reference to our front camera device) uses a discovery session to search for all devices with a built in camera. 

To toggle between the front facing camera and the rear facing camera, you'll need to edit this constant, as well as the method `flipCamera`. Some hints:

 1. You'll need to pass in a different `AVCaptureDevice.position` to `someConstantWithABadName`
 2. You may (and should) reuse the same `captureSession` when switching devices/cameras (meaning, you should be calling `configureCaptureSession` again within `flipCamera`), but you must remove your old camera input before adding a new one. You can do this by iterating through you `captureSession.inputs` and calling `captureSession.removeInput`.

If you implemented this correctly, you should be able to toggle back and forth between both of your device's cameras. Nice work!
