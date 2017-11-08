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

Once you've set your Team as your Apple ID, try running your app again on your device. If everything's working, you'll see a blank gray view with some buttons (that don't work yet). If you still are having an issue, ask one of the TA's for help (you may need to change your deployment target if your phone is not updated to the lastest iOS version). We've found it takes a while for devices to run the app for the first time, too.

## Part 2: Connecting Outlets ##
Just so you become more familiar with the which views are which, we left the outlets and actions in **ImagePickerViewController.swift** unconnected to storyboard. **Go ahead and connect these outlets and actions in ImagePickerViewController.swift to Main.storyboard**. Make sure to read the comments above each IBOutlet and IBAction, so that you are sure you are connecting the correct outlets and actions. 
 
Since some of the outlets and actions you'll need to connect are overlapping UI elements, you may find it helpful to open the **Document Outline**. You can drag from Outlets and Actions in code to UI elements in the Document Outline if you find that easier. If you need to delete any connections you made, tap on your ViewController in the Document Outline or in Storyboard, and open the **Connections Inspector** to see all of your connections and delete any if necessary.
![](/README-images/README-3.png)

If you connected all of the outlets AND actions correctly, try taking a picture. You should see an image of squirrel with a neat little leaf hat. Though sending squirrel snaps to the rest of the class is fun, let's add in our own custom camera to send some photo snaps!

## Part 3: Getting User Permissions and Capturing from User's Device ##

To view real time data collected from your device's camera, we'll be using AVFoundation's [AVCaptureSession](https://developer.apple.com/reference/avfoundation/avcapturesession). Notice the "AVFoundation" import at the top of the file.

We've defined the following AVFoundation related instance variables for you already, but you should already be familiar with `AVCaptureSession` and `AVCapturePhotoOutput` from lecture. 
    
    // middleman between AVCaptureInput and AVCaptureOutput
    var captureSession: AVCaptureSession?

    // view that will let us preview what is being captured from our input
    var previewLayer : AVCaptureVideoPreviewLayer?

    // used to capture a single photo from our capture device
    let photoOutput = AVCapturePhotoOutput()
    
### Part 3.1: Configuring Capture Session - creating a preview layer for displaying video###

Notice the two commented out methods in `viewDidLoad`. These are two helper methods we've defined for the lab to help organize our code, but you will need to fill them out. To begin, 

 1. uncomment the call to the helper function `createPreviewLayer` in `viewDidLoad`
 2. instantiate an `AVCaptureSession` object in `viewDidLoad`, and set it equal to `captureSession`. We will be using only one session throughout this lab, so we need to keep a reference to it.
 3. finish implementing the `createPreviewLayer` function. You can learn about preview layers here [AVCapturePreviewLayer](https://developer.apple.com/reference/avfoundation/avcapturepreviewlayer). All you will need to do is initialize the `previewLayer` variable with our capture session.

Once you've finished this, you've now created a spot in our view to display video from your camera. However, you won't see anything yet when you run, since we haven't set our `captureSession`'s input yet. Let's do that now!

### Part 3.2: Configuring Capture Session - setting inputs and outputs ###
Go back to `viewDidLoad` and uncomment the helper method `configureCaptureSession`. Inside the `configureCaptureSession` function, you will need to do the following:

 1. Uncomment the helper function `createPreviewLayer` in `viewDidLoad`
 2. Update this helper method as per the instructions within the body of the function. The lecture slides will help you if your not sure what to do. Feel free to rename `someConstantWithABadName`.
    
Once you've finished, try running your app. You should be able to see video data from your camera in the `previewLayer`. Try taking a photo - looks like we still have a problem.

## Part 4: Taking a photo using AVCapturePhoto  ##
Now, we will need to implement taking a photo, and then displaying this image in our imageView (`imageViewOverlay`). To do this, we will need to use [`AVCapturePhoto`](https://developer.apple.com/documentation/avfoundation/avcapturephoto) and [`AVCapturePhotoCaptureDelegate`](https://developer.apple.com/documentation/avfoundation/avcapturephotocapturedelegate). Specifically, you will need to:

 1. [Capture a photo](https://developer.apple.com/documentation/avfoundation/avcapturephotooutput/1648765-capturephoto) using your `photoOutput` object in the `takePhoto` IBAction. Remember, this doesn't save the image anywhere, we will handle this using `AVCapturePhotoCaptureDelegate` in the next step.
 2. Define the `AVCapturePhotoCaptureDelegate` method [`photoOutput(didFinishProcessingPhoto: ...)`](https://developer.apple.com/documentation/avfoundation/avcapturephotocapturedelegate/2873949-photooutput). (We did not add this in for you, you will need to create it and make sure your view controller class conforms to the delegate protocol).
    
Inside of the photoOutput(didFinishProcessingPhoto: ...) function, you will need to do the following (in this order):

 3. Create a UIImage using the `photo` parameter. [Slide 56](http://iosdecal.com/fall-2017-slides/lecture9.pdf#page=56) from lecture will help you if your stuck.
 4. Set `selectedImage` to this `UIImage`
 5. Call `toggleUI(isInPreviewMode: true)`. This is already implemented for you, and it simply updates the UI elements on the screen - (i.e., once the picture is taken, we want to present the send button, hide the camera flip button, etc.)

Once you've finished this step, you should be able to take and send photos! 

**Before you try fixing this method, add a function call to `captureNewSession(devicePostion: nil)` to your `viewDidLoad()` method, and  try running your app on your device.** You may get following error (if you don't, just continue on with the lab. You will probably need to refer back to this section later on, since you will get this error at some point):  

> This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an SOME-DESCRIPTION-KEY-NAME key with a string value explaining to the user how the app uses this data.

All this means is that we need to provide a message to our users asking for permission to use their camera. Let's take a detour from our code to do that now. 

### TODO: not sure where this should go. Getting User Permission for Camera Access ##

    To request permission to use the user's camera, you'll need to do the following (see the image below for clarification):
     - Navigate to your Project File
     - Click "snapChatProject" from the Targets list
     - Open the "Info" tab (this is linked to that Info.plist file you've probably seen in past projects)
     - Under the section "Custom iOS Target Properties", add a new property with the key given to you in the console crash output
     - Set the value to be whatever you want to be displayed to the user when they try to use your app (typically an explanation of what you are using their camera for)
     
    ![](/README-images/README-4.png)
        
    Now, try running your app again. If all is well, your app should run, except this time you should see an alert asking for permission to use your device's camera. 

## Part 5 (OPTIONAL BUT ALSO NOT THAT BAD): Supporting front and back camera ## 
Right now, we can only take pictures using the front camera. To add support for toggling between the front camera and the read facing camera, go back to the function we created at the beginning of the lab, `configureCaptureSession`. Right now `someConstantWithABadName` (which you probably know by is a reference to our front camera device) uses a discovery session to search for all devices with a built in camera. 

To toggle between the front facing camera and the rear facing camera, you'll need to edit this constant, as well as the method `flipCamera`. Some hints:

 1. You'll need to pass in a different `AVCaptureDevice.position` to `someConstantWithABadName`
 2. You may reuse the same `captureSession` when switching devices (meaning, you should be calling `configureCaptureSession` again within `flipCamera`), but you must remove your old camera input before adding a new one. You can do this by iterating through you `captureSession.inputs` and calling `captureSession.removeInput(input)`.

If you implemented this correctly, you should be able to toggle back and forth between both of your device's cameras. Nice work!
