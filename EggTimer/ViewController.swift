import UIKit
import AVFoundation //For playing the alarm sound.

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var softEggImage: UIImageView!
    @IBOutlet weak var mediumEggImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var hardEggImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var audioPlayer: AVAudioPlayer? //Reference to an audioPlayer instance.
    var timer = Timer() //Reference to a timer instance.
    
    // The following variables (Properties) are variables that are used in multiple functions (Scope), so that each function can have access to these containers to do something with them. Rather than repeatedly declaring a new variable in each function, update these variable instead. It's good practise to only make variables outside functions if you need that information in another function.
    
    var eggTimesInSeconds = ["Soft":300, "Medium":480, "Hard":720] //Type inference automatically knows this dictionary is of type [String:Int].
    
    var totalTimeTilCancel = 10 //A reference to the time until the cancel button disappears.
    
    var secondsRemainingToCookEgg:Int = 1 //Created to pass the updated value of this variable from 'hardnessSelected' function to the 'updateTimer' function. (Initial Value is 1 because it fixes the bug the occurs with the enableCancelButton function)
    var timeRemaining = "" //A reference to the secondsRemainingToCookEgg variable, but converted as a String in the format of Minutes:Seconds.
    var hardness = "" //A reference to the currentTitle of the hardnessSelected button.
    
    var secondsPassed:Float = 0 //Used to reference a value being incremented by 1 (For the progressView).
    var totalTime:Float = 0 //Used to reference an egg time from 'eggTimesInSeconds,' but expressed as a float (For the progressView).
    
    override func viewDidLoad() {
        timerLabel.alpha = 0 //Remove the opacity of the timerLabel (We only want to show the timerLabel after hardnessSelected - For better UX).
        makeCornersRound(progressView) //Make the progressView have rounded corners.
        enableCancelButton(false) //Disable cancel button.
    }

    ///A function that defines the behaviour we desire once the cancel button has been pressed.
    @IBAction func cancelPressed(_ sender: UIButton) {
        resetTimer() //Reset the timer and revert other UI elements back to their original values when the cancel button is pressed.
        enableCancelButton(false)
    }
    
    ///The function that defines the behaviour we desire once any of the egg buttons were pressed.
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        resetTimer() //Reset any pre-existing timers and revert other UI elements when an egg hardness has been selected. (Solves 2x and 3x timer-speed bug)
        enableCancelButton(true) //Enable cancel button.
        
        hardness = sender.currentTitle ?? "" //References the button that was pressed via its currentTitle property. Let the default string by an empty string.
        
        secondsRemainingToCookEgg = eggTimesInSeconds[hardness] ?? 0 //Access egg time values based on a key selected from one of the hardness buttons.
        timeRemaining = convertSecondsIntoMinutesAndSeconds(secondsRemainingToCookEgg) //Convert value of the selected egg time into a 'minutes:seconds' string format.
        totalTime = Float(eggTimesInSeconds[hardness] ?? 0) //A reference to the egg times, which are intially integers, but expressed as a float (for the progressView).
    
        startEggTimer() //Start a new egg timer.
        showEggTimerToUser() //Change various UI elements to show the desired egg timer to the user.
    }
    
    ///A function that creates a timer. We are creating a timer that behaves as the updateTimer function. The 'updateTimer' function is called at every timeInterval. E.g. if timeInterval is equal to 1, therefore the 'updateTimer' is called once per second. If 'timeInterval' is equal to 2, then 'updateTimer' will be called twice per second, etc.
    func startEggTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    /**
     Defining the behaviour of our timer. In this app, we want the behaviour of a countdown timer.
     
     To have the behaviour of a countdown timer, we decrement a value by 1 every second until that value reaches 0. In other words, **IF** the value is greater than 0, decrement the value by 1, **OTHERWISE** stop the timer (i.e. when the value is NOT greater than 0). */
    @objc func updateTimer() {
        if secondsRemainingToCookEgg > 0 {
        
            timeRemaining = convertSecondsIntoMinutesAndSeconds(secondsRemainingToCookEgg - 1) //Start the timer count 1 second after hardnessSelected.
            timerLabel.text = timeRemaining //Show 'timeRemaining" instead of 'secondsRemainingToCookEgg' for a better UX.
            secondsRemainingToCookEgg -= 1 //Decrement secondsRemaining by 1 at every run loop of the timer.
            
            totalTimeTilCancel -= 1 //Decrement the totalTimeTilCancel value by 1, per second.
            enableCancelButton(true) //Enable cancel button.
            
            //Nested If: When secondsRemainingToCookEgg IS 0, run this code. (Fixes the 1 second delay bug)
            
            if secondsRemainingToCookEgg == 0 {
                titleLabel.text = "Your \(hardness) Eggs Done!" //Tell user that the egg timer is done.
                playAlarm() //Play alarm sound when timer reaches 0.
            }
            
            //Make the cancelButton disappear after 10 seconds.
            if totalTimeTilCancel < 0 {
                totalTimeTilCancel = 0 //To ensure the value does not continue decrementing after 0.
                enableCancelButton(false)
            }
            
            secondsPassed += 1 //Increment secondsPassed value by 1 every second (Essentially the same behaviour of a stopwatch).
            
            progressView.progress = percentageProgressCalculation() //Store the percentageProgress into the progress attribute of the progress bar.
            
        } else {
            timer.invalidate() //Stop the timer from running again.
            enableCancelButton(true)
        }
    }
    
    /**
     A function that converts (breaks down) seconds into minutes and seconds.
     
     An example of using this function. Suppose:
     ```
     let softEggTime = 300 //Total seconds to make a soft egg
     let softEggTimeConverted = convertSecondsIntoMinutesAndSeconds(softEggTime) //Pass softEggTime as an argument to eggTime
     ```
     Therefore,
     ```
     print(softEggTimeConverted) // 05:00 (05 minutes, 00 seconds)
     ```
     - parameter eggTime : Refers to the value of how long it takes to cook an egg, in seconds-only. E.g "300"
     - returns: A String that contains minutes and seconds to 2 decimal places in a 00:00 format. E.g "05:00" means 5 minutes, 0 seconds.
     */
    func convertSecondsIntoMinutesAndSeconds(_ eggTime: Int) -> String {
        let seconds = eggTime % 60 //The remainder of the totalSeconds passed into the function
        let minutes = (eggTime / 60) % 60 //Note: totalSeconds does not change every second,

        return String(format: "%02d:%02d", minutes, seconds) //Return minutes and seconds rounded to 2dp, as a string
    }
    
    ///A function that changes the UI such that the app will 'show' all the relevant information about the 'egg timer to the user.'
    func showEggTimerToUser(){
        titleLabel.text = "\(hardness) eggs coming up!" //Tell user that their selected egg timer has been selected.
        timerLabel.alpha = 1 //Show the timer to the user through the timerLabel after the timer was selected.
        timerLabel.text = timeRemaining //Tells user that the the time remaining from the egg timer.
        
        //Lower the opacity of each button, such that the selected button is the only button at full opacity. This gives the effect that the selected button is the focus point.
        
        switch hardness {
        case "Soft":
            softEggImage.alpha = 1
            mediumEggImage.alpha = 0.4
            hardEggImage.alpha = 0.4
        case "Medium":
            softEggImage.alpha = 0.4
            mediumEggImage.alpha = 1
            hardEggImage.alpha = 0.4
        case "Hard":
            softEggImage.alpha = 0.4
            mediumEggImage.alpha = 0.4
            hardEggImage.alpha = 1
        default:
            print("error with changing button opacity")
        }
    }
    
    ///A function to play sound from a local resource. This is very similar to the function created in the Xylophone app from the previous module. We call this function once an egg timer is done.
    func playAlarm(){
        
        //Using a URL to reference the location of the 'alarm_sound' file. If not nil, continue the code.
        guard let soundURL = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default) //Sound will not play if phone is on silent mode.
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL) //Initialise the audioPlayer to play the audio from the soundURL.
            audioPlayer?.play() //Play from the player.
        } catch {
            print("Error playing sound: \(error)") //If any errors, print the error to the console.
        }
    }
    
    ///A function to make the progressView have rounded corners.
    func makeCornersRound(_ progressBar: UIProgressView!) {
        
        // Set the rounded edge for the outer bar.
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true //Tells the view not to draw anything outside of the view's bounds.
        
        // Set the rounded edge for the inner bar.
        progressBar.layer.sublayers![1].cornerRadius = 10
        progressBar.subviews[1].clipsToBounds = true
    }
    
    ///A function to reset the timer via invalidating the timer and adjustinging UI elements back to its default values (before the timer was created).
    func resetTimer() {
        timer.invalidate() //Invalidate any pre-existing timers before starting a new timer.
        progressView.progress = 0 //Reset progress of the progressView. (Set the progress bar back to the beginning)
        secondsPassed = 0 //Reset secondsPassed by starting at 0 again (So that the percentageProgress calculation starts at 0 again).
        titleLabel.text = "How do you like your eggs?" //The string to display if a timer has not been selected yet.
        timerLabel.alpha = 0 //Do not show the timerLabel yet.
        totalTimeTilCancel = 10 //Reset variable back to 10 (For the cancel button count to start at 10 again)
        softEggImage.alpha = 1 //Reset Opacity of soft egg image
        mediumEggImage.alpha = 1 //Reset Opacity of medium egg image
        hardEggImage.alpha = 1//Reset Opacity of soft hard image
    }
    
    ///A function that defines how the cancel button should behave under different conditions.
    func enableCancelButton(_ isTrue:Bool) {
        if isTrue == true {
            cancelButton.alpha = 1 //Make cancel button appear when hardness of the egg is selected.
            cancelButton.isEnabled = true //Enable the cancel button.
            cancelButton.setTitle("Cancel (\(totalTimeTilCancel))", for: .normal) //Show the total time until the cancel button is disabled.
            
        } else {
            cancelButton.alpha = 0 //Make the cancel button disappear.
            cancelButton.isEnabled = false //Disable the cancel button.
        }
        
        //Show the cancel button when the egg timer is done.
        if isTrue == true && secondsRemainingToCookEgg == 0 {
            cancelButton.alpha = 1
            cancelButton.isEnabled = true
            cancelButton.setTitle("Reset", for: .normal)
        }
    }
    
    func percentageProgressCalculation() -> Float {
        let percentageProgress = secondsPassed / totalTime //The ratio of the 'secondspassed' to the 'totalTime,' expressed as a percentage.
        return percentageProgress
    }
}
