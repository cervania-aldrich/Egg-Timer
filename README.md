![App Brewery Banner](Documentation/AppBreweryBanner.png)

#  Egg Timer

## Description
This is an egg timer app to help you boil your eggs depending on how you prefer your eggs. 

I created this app as part of the [App Brewery's "Complete iOS App Development Bootcamp'' course on Udemy](https://www.udemy.com/course/ios-13-app-development-bootcamp/).

Building on the lessons from the previous module [Xylophone](https://www.google.co.uk/), I have started to gain more confidence in how to look up something I have not done before. Additionally, I have learned many programming concepts along the way, such as conditional statements and functions with outputs, as well as the Swift Timer API.

I am particularly proud of building this app because it was the first app where I was able to add my own features and start to explore my creativity, including implementing stop functionality and converting the timer to display minutes-and-seconds instead of seconds-only (More details in the “What makes this project stand out?” section). Innovating on top of the app was challenging, because this was the first project where I got stuck and I had to figure things out on my own without the help of a tutorial. But by finishing the features I wanted to implement, it built my confidence and problem solving skills.

As this app was made for learning purposes, I have added many comments and documentation markup in order to be as descriptive as possible. It has been an effective learning strategy for me. I found this has helped me understand the Swift language and the Apple Developer documentation better. Also, it helped me not fall into the trap of just copying code from a tutorial, rather I’m reassuring myself that I actually understand the code being written and why it was written. Furthermore, I recognise that documenting code is an important skill to have as a Software Developer, and I believe it is worth practising.

## Instructions
Clone this repository in Xcode to run the project. Run it in the simulator.

Click on an egg to start a timer. The duration of the timer will depend on which egg you clicked. The timer will make a sound when it is finished (meaning your egg is done cooking), afterwards you can reset or cancel the timer.

## Learning Objectives
What did I learn? How did this app improve my iOS development skills?

There are several concepts that I was able to learn whilst developing this app. This includes:

* Swift Dictionaries.
* Figure out how to use the Timer Object using the Swift Timer API.
* Understand the need and use cases of Swift Optionals.
* How to use conditional statements (IF/Else, and Switch) to control the flow of code execution.
* Learn to use the UIProgressView to create an animated progress bar.
* Functions with outputs.
* Data Types.
* Refactoring.
* How to debug an app.
    
## What makes this project stand out?
To improve my understanding, I added extra features to the app. This includes:

* Express the countdown timer in Minutes and Seconds, and display this information in the UI.
* Fix an issue where there was a delay in the initial start of the countdown timer.
* Fix an issue where sound was played 1 second after the timer is done.
* Add stop functionality to the timer - i.e. A cancel button that appears, firstly, at 10 seconds after selecting a timer (then expires after 10 seconds), and secondly, at the end of a timer.
* Increase the size of the progress bar and make it have rounded corners.
* Add a “focus effect” on the selected egg, i.e. the selected egg button is the most opaque button.
* Have a landscape mode.
* Incorporate optionals and the nil coalescing operator instead of force unwrapping variables.
* Reorganise code with functions.
* Add comments to help explain my code.
* Use the DocC framework to add Swift documentation to guide end-users reviewing the code.

>This is a companion project to The App Brewery's Complete App Development Bootcamp, check out the full course at [www.appbrewery.co](https://www.appbrewery.co/)

![End Banner](Documentation/readme-end-banner.png)

