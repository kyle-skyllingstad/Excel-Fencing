# Excel-Fencing

Welcome!

The Excel Fencing mobile iOS application is an interactive user application that allows the user to command the Excel Fencing interactive Target Board. In the app, the user logs into their personal account where they can tell the board to provide a user-defined interactive fencing training exercise, to which the user will fence against. The Excel Fencing interactive Target Board is an interactive, easily mountable 2’ by 3’ panel that is shaped like the torso and arms of a fencer. When prompted by a user on the mobile application, the different targets flash red on the board, one at a time. They go on for as long as the user inputs them to, and the user’s goal is to hit as many of them in time as possible. When a user hits one in time, i.e. while it is red, it turns green and the user scores a point. The number of points is totaled at the end of the round duration. This is the user’s score for that round. The user can control the duration as well as how quickly the targets flash, changing the difficulty to fit his or her training needs.

The mobile application controls the Fencing board via WiFi. The user application can be uploaded and run on any iOS device, such as an iPhone or iPad. When running, the app sends requests to the board, which then sends results to an online Google Firestore user profile for the fencer. All user data, including current performance as well as user-selected performance history data, are stored online in a custom-made user profile in Google’s Firestore database. The mobile application then calls data from this database and analyzes it, creating a user performance history database onboard the app as well as in Firestore. The mobile application then performs a basic analysis on the user’s performance during the current round compared to previous ones, giving the user a performance comparison analysis. This allows users to track their progress and identify their desired difficulty level.


Instructions for Excel Fencing interactive Target Board Use

To train on the system, the user must first turn on the Excel Fencing interactive Target Board and make sure it is charged, as denoted by the battery bar on the left side. Then, the user must open the Excel Fencing iOS application. In the app, the user will navigate to the main command interface, where he or she will enter the desired round duration (how long the flashing will go on for) and the length of each red flash (shorter is more difficult). Once these have been entered, the user prepares to fence and then taps the GO! button in the mobile app. There is no need to rush super quickly to one’s stance after this; the system takes roughly three seconds to translate the user’s commands, transmit them to the interactive Target Board, and begin the round of flashing. Once the flashing begins, the fencer can fence away! When finished, the lights stop flashing, and the app then displays the users score: number of hits out of number of flashes. The user can then tap his or her score to see the comparative analytics of this round and previous ones. To turn the system off, the user need only power down the Excel Fencing interactive Target Board, as well as close the mobile application. The user can clear all performance history at any time in the application without any outside assistance, and he or she can delete her account at any time without any service required. All data is constrained to the app and the board and Google Firestore, and it can be deleted from all three in an instant. See the in-app Terms of Use and Privacy Policy pages for more information regarding usage of personal and entered information. 


Mounting the Excel Fencing interactive Target Board

To begin a round, the user must firmly mount the Excel Fencing interactive Target Board to a hard, stable, vertical surface, such as a wall or a large vertical test dummy. To mount safely, the user must firmly suction the board to the wall using the attached plastic suction cups, if mounting to a wall. If the user is attaching the interactive Target Board to the front of a dummy, the user must strap it to the dummy using both attached straps. Both straps must be firmly tightened all the way around the back of the dummy to ensure fixation. When ready, the user should poke the board firmly to make sure it is stable, for hits can be quite forceful and aggressive during active fencing sessions.


Getting Started with the Mobile iOS Application

To get familiar with the Excel Fencing iOS app, the user must either download it from Apple’s TestFlight platform, or follow the instructions below. If downloading from TestFlight, users can feel free to skip the instructions below. Instead, they should download the TestFlight app from the App Store if they haven’t already, search for “Excel Fencing”, and follow the in-app instructions for downloading Excel Fencing app from TestFlight’s onscreen link. Then they’re ready to begin pairing their app with their Excel Fencing interactive Target Board as they prepare to fence. Happy fencing! 

Otherwise, if downloading the iOS app directly from GitHub, please follow the instructions below to guarantee proper functionality. They are as follows:

1.	Make sure he or she has a Mac with Xcode installed. If not, users can easily install it on an existing Mac, or install it on a virtual machine on a Linux machine or PC.
2.	Download the Excel Fencing App master file from the GitHub, Chatbot Starter Project onto the Mac or virtual Mac. Unzip the compressed file.
3.	Open terminal in your Mac or virtual Mac, and in the default user directory, type the following command: sudo gem install cocoapods. If any errors arise, most likely your OS is not up to date. Check the CocoaPods website for further details regarding how to proceed from here.
4.	Once CocoaPods has successfully installed, change the directory to the location of the contents of your unzipped Excel Fencing App project files including the podfile.
5.	Type the following command: pod install. This should create/update a file in the Excel Fencing App project folder – Excel Fencing.xcworkspace.
6.	Open this file, Excel Fencing.xcworkspace, in Xcode on his or her Mac or virtual Mac (in the case of Linux machine or PC).
7.	Plug his or her iOS device into the computer. Wait for several seconds.
8.	In Xcode, the user should see the Excel Fencing program code. On the far upper left of the screen, the user should see two blue Xcode files, each with dropdown menus, labeled Excel Fencing and Pods, respectively. If he or she only sees a dropdown option on the Pods file folder, but not on the Excel Fencing file folder, he or she must close Xcode, delete the .xcworkspace file, and reinstall the podfile back in Terminal as done previously.
9.	Once both file folders have dropdown menus, the user must then click on the Excel Fencing logo icon at the top of the page just to the right of the darkened square button. This will show him or her a list of devices to run the app on, and the user should scroll to the top and select his or her mobile device, which should show up there once connected. This may require the user to unlock his or her phone in order to make it available to be trusted by the computer.
10.	Once his or her phone has been selected, the user can then upload the Excel Fencing application to his or her phone by pressing the triangle button to the left of the square one. Xcode will prompt the user for his or her computer password, and he or she should enter it as many times as necessary to proceed through the inquisitions. The user may need to change a few settings on his or her iOS device to allow it to run the app, if prompted to do so on the screen of his or her device. Here, the user must enter permissions and change settings as directed.
11.	If the app uploads properly, Xcode should print a popup window displaying a hammer and saying, “Build Succeeded,” to indicate successful compilation and uploading of the code. If instead a window pops up saying, “Build Failed,” the user should make sure his or her iOS device is updated to the newest version of iOS. Once this has been corrected, the application should build successfully.
12.	The user then can go to his or her iOS device and open the Excel Fencing mobile application! All he or she needs to do here is power his or her Excel Fencing interactive Target Board and prepare to fence. Simply follow the onscreen instructions to get started!


Some Pointers on How to Use:

This mobile application is paired in conjunction with Excel Fencing's interactive Target Board. This app syncs with the target board and acts as the user's interface to the board. A user uses this app to start and end a fencing round. A fencing round lasts for a duration of time set by the user in the app, and during this time, red lights flash on the target board one after another, at a rate also set by the user in the app. When the duration time runs out, the user's score is the number of successful strikes during that round. Successful strikes are when the user is able to tap the red target in time before the next one flashes, and they are marked with a green light. The app will notify the user when the round has finished and their score has been posted. When this happens, the user will see their score for the round appear on the main interface. This marks the completion of that round. Without the target board, users can start rounds, but they will always receive a score of zero unless an Excel Fencing interactive Target Board is set up.

This application stores basic user information, as denoted in the Privacy Policy, including first name, last name, email address, a user password, and performance information on Google Firebase's Firestore database. Users can delete such information at any point, temporarily or permanently. The application allows users to view and past performance history and compare current round scores to it, and users can delete this as they see fit. This application runs on both iPhone and iPad.

I wish you the best interactive training experience possible, right when you want it. Feel free to reach out to me at skyllink@gmail.com if you have any questions or concerns regarding how to train with Excel Fencing, or if you have any unexpected errors while trying to train, or if you just wish to hear the latest news on interactive fencing training. Best of luck, and happy fencing!
