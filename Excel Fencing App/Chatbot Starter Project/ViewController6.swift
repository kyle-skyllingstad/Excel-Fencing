//
//  ViewController6.swift
//  EXCEL FENCING MOBILE APPLICATION
//  Created by Kyle Skyllingstad
//

// Import necessary kits/libraries
import UIKit
import Firebase
import FirebaseDatabase

// Class for screen 6, ViewController6
 class ViewController6: UIViewController, UITextFieldDelegate {
    
    
    // Set outlets for buttons, labels, and text fields
    
    // Text fields
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var flashintervalTextField: UITextField!
    
    // Labels
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var useridLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var scorePercentageLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var showPopUpButton: UIButton!
    
    
    
    // Main screen loading function
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // Set up the text fields to allow the keyboard to be able to be hidden after typing has finished
            self.durationTextField.delegate = self
            self.flashintervalTextField.delegate = self
        
            // Call the function to set up the UI elements
            setUpElements()
        
        
            // Call reception notification center function to receive incoming information (User ID, user first name, current score, and current number of targets)
            NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationUserID(_:)), name: Notification.Name("useridin"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationFirstName(_:)), name: Notification.Name("firstnamein"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationScore(_:)), name: Notification.Name("scorein"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationNumber(_:)), name: Notification.Name("numberin"), object: nil)
        
    }
    
    
    
    
    
    
    // Functions ////////////////////////////////
    
    
    
    // Hide keyboard when the user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard when the user presses the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        durationTextField.resignFirstResponder()
        flashintervalTextField.resignFirstResponder()
        return (true)
    }
    
    
    
    // Function for formatting UI elements
    func setUpElements () {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style some of the elements
        Utilities.styleHollowButtonPopUp(showPopUpButton)
        Utilities.styleTextField(durationTextField)
        Utilities.styleTextField(flashintervalTextField)

    }
    
    
    // Function for showing error on the label
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message as a string.
    func validateFields() -> String? {
        
        // Check that all fields are filled in - if they are not
        if  durationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            flashintervalTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            durationTextField.text = ""
            flashintervalTextField.text = ""
            
            // Tell the user to fill them all in
            return "Please fill in all fields."
        }
        
        // Get round duration and target flash interval length from the text fields
        let duration = durationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let flashinterval = flashintervalTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Create set of valid number characters for the duration and flash interval text fields - not just 0, and nothing but integers
        let characterset = CharacterSet(charactersIn:
        "0123456789")
        
        // If the duration text field contains something other than numbers
        if duration.rangeOfCharacter(from: characterset.inverted) != nil {
            
            // Clear text fields
            durationTextField.text = ""
            flashintervalTextField.text = ""
            
            // Tell user to enter a nonzero integer
           return "Length must be a positive integer."
        }
        
        // If the flash interval text field contains something other than numbers
        if flashinterval.rangeOfCharacter(from: characterset.inverted) != nil {
            
            // Clear text fields
            durationTextField.text = ""
            flashintervalTextField.text = ""
            
            // Tell user to enter a nonzero integer
           return "Interval must be a positive integer."
        }
        
        // Convert flash interval string to double and compare to zero. Report an error to the user if it equals zero, and prompot them to enter a nonzero flash interval value.
        let flashintervalnum = Double(flashinterval)
        if flashintervalnum == 0 {
            
            // Clear text fields
            durationTextField.text = ""
            flashintervalTextField.text = ""
            
            // Tell user to enter a nonzero integer
           return "Interval must be nonzero."
        }
        
        
        return nil
    }

    
    
    
    // Function for if GO! Button is tapped
    @IBAction func didTapGoButton() {
        
        // Validate the fields
        let error = validateFields()
        
        // If there is an error
        if error != nil {
            
            // There's something wrong with the fields, show the error message for the particular error
            showError(error!)
        }
            
        // Else no error
        else {
            
            //Hide the error label
            errorLabel.alpha = 0
            
            // Create cleaned versions of the text field
            let durationString = durationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let flashintervalString = flashintervalTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Convert duration and target flash interval to double and force unwrap them since they are valid/no errors at this point
            let duration = Double(durationString)!
            let flashinterval = Double(flashintervalString)!
            
            // Convert duration and target flash interval to integers
            let durationInteger = Int(duration)
            let flashintervalInteger = Int(flashinterval)
            
            
            
            // Initialize constants for the URL GET request that will call the ESP8266-12e chip onboard the Excel Fencing Target Board
            let HttpString = "http://"
            let ArduinoString = "esp8266.local/"
            let getinputString = "get?input1="
            
            // Put duration string into a string of the right length for the Fencing Board to interpret
            let durationStringFit: String = String(format: "%04d", durationInteger)
            
            // Put the flash interval string into one of the right length for the Fencing Board to interpret
            let flashIntervalStringFit: String = String(format: "%02d", flashintervalInteger)
            
            // An example of what the URL GET request sent to the Fencing Board should look like
            // http://123456/get?input1=20101
            
            
            // Put everything into a single string to be sent to the Fencing Board Arduino code through a WiFi URL
            let urlString = "\(HttpString)\(ArduinoString)\(getinputString)\(durationStringFit)\(flashIntervalStringFit)"
            print(urlString)
            
            // Begin URL session to send the request
            let session = URLSession.shared
            
            // Convert it all to an actual URL
            // let url = URL(string: urlString)!
            guard let url = URL(string: urlString)
                else {
                    return
            }
            
            // Send request to the URL without actually opening it in a web browser
            let task = session.dataTask(with: url, completionHandler: { data, response, error in
            })
            task.resume()
            
            // Open Firestore
            let db = Firestore.firestore()
            
            
            // Read in userid optional from label text
            let useridStringOptional = self.useridLabel.text


            // Unwrap optional string
            guard let useridStringRaw: String = useridStringOptional as? String else {
                return
            }

            // Get just the user ID with no text
            let userid = useridStringRaw.replacingOccurrences(of: "User ID: ", with: "")

            
            // Get the rounded-down number of target flashes from the duration divided by the flash interval length
            let number = floor(duration/flashinterval)
            
            // Convert the number of flashes to an integer
            let numberInt = Int(number)
            
            // Convert this integer back to a string to be shown on the label for it
            let numberString = String(numberInt)
            
            
            // Call the user document by their User ID
            db.collection("users").document(userid).getDocument { (document, error) in
                
                
                // Check for an error
                // If no error
                if error == nil {
                    
                    // Check that this document exists - if it does
                    if document != nil && document!.exists {
                        
                        // Call user-specific document by their User ID
                        let document = db.collection("users").document(userid)

                        // Update the number of target flashes in the database for the current round only. The Fencing Board's ESP8266 updates the current round's score results on the Firestore database itself.
                        // Update number of target flashes in Firestore
                        document.updateData([
                            "Number": numberString
                            
                            // If there is an error updating the Firestore database, perhaps due to a poor WiFi connection
                        ]) { err in
                            if let err = err {
                                
                                // Print error message in the console
                                print("Error updating document: \(err)")
                                
                                // If no error updating Firestore document
                            } else {
                                
                                // Print the success message in the console
                                print("Document successfully updated")
                            }
                        }
                        
                    }
                    
                }
                
            }
            
            // Clear duration and interval text fields
            durationTextField.text = ""
            flashintervalTextField.text = ""
            
            
        
            // Delay section - what happens after the round times out (user's duration is over) and the Fencing Board updates the score
            
            // Add 3 seconds to the delay (user's duration time) to account for the worst-case scenario in the Fencing Board uploading the current session's score very slowly to the Firestore user-specific databse
            let appdelaytime = duration + 3.0
            
            // Execute the delay
            DispatchQueue.main.asyncAfter(deadline: .now() + appdelaytime) {
                
                            
                // Read in User ID optional from label text
                let useridStringOptional = self.useridLabel.text


                // Unwrap User ID optional string
                guard let useridStringRaw: String = useridStringOptional as? String else {
                    return
                }

                // Get just the User ID
                let userid = useridStringRaw.replacingOccurrences(of: "User ID: ", with: "")

                
                
                
                // Get the user's Firestore data account document
                db.collection("users").document(userid).getDocument { (document, error) in
                    
                    
                    // Check for an error in opening it
                    // If no error
                    if error == nil {
                        
                        // Check that this document exists
                        // If it does
                        if document != nil && document!.exists {
                            
                            // Extract the data from the document
                            // Current round's data
                            let scoreString = document!.get("Score") as! String
                            let scorePercentageString = document!.get("Score Percentage") as! String
                            let numberString = document!.get("Number") as! String
                            
                            // Old session total data
                            let oldTotalScoreString = document!.get("Total Score") as! String
                            let oldTotalNumberString = document!.get("Total Number") as! String
                            
                            // Convert necessary data to double for computation
                            // This round's score and number of target flashes
                            let score = Double(scoreString)
                            let number = Double(numberString)
                            
                            // Session total score and number of target flashes
                            let oldTotalScore = Double(oldTotalScoreString)
                            let oldTotalNumber = Double(oldTotalNumberString)
                            
                            // Change totals to include current round's results
                            let totalScore = oldTotalScore! + score!
                            let totalNumber = oldTotalNumber! + number!
                            let overallPercentage = 100*totalScore/totalNumber
                            
                            // Convert new session (including current round) totals to String (for uploading to Firestore)
                            let totalScoreString = String(totalScore)
                            let totalNumberString = String(totalNumber)
                            let overallPercentageString = String(overallPercentage)
                            
                            // Upload new totals to Firestore
                            let document = db.collection("users").document(userid)

                            // Update the totals in Firestore
                            document.updateData([
                                "Total Score": totalScoreString, "Total Number": totalNumberString, "Overall Percentage": overallPercentageString
                            ]) { err in
                                // If error in uploading the new updated session totals to Firestore
                                if let err = err {
                                    print("Error updating document: \(err)")
                                    
                                    // Otherwise no error in updating the user's Firestore document
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                            
                            
                            
                            
                            // Set output labels to show current data
                            self.scoreLabel.text = scoreString
                            self.numberLabel.text = numberString
                            self.scorePercentageLabel.text = scorePercentageString
                            
                        }
                        
                    }
                    
                }
                
            } // End of stuff in the delay loop
            
               
            
        }
 
    }
    
    
    
    // Function for if User ID is received
    @objc func didGetNotificationUserID(_ notification: Notification) {
        
        // Take in raw notification
        let useridinOptional = notification.object as! String?
        
        // Unwrap optional raw notification
        guard let useridin: String = useridinOptional as? String else {
            return
        }
        
        // Set the User ID label to the User ID to store it for use on this screen and for display
        useridLabel.text = useridin
    }
    
    
    // Function for if first name is received
    @objc func didGetNotificationFirstName(_ notification: Notification) {
        
        // Take in raw notification
        let firstnameinOptional = notification.object as! String?
        
        // Unwrap optional raw notification
        guard let firstnamein: String = firstnameinOptional as? String else {
            return
        }
        
        // Show the first name on the label for the user to see and to store it
        firstnameLabel.text = firstnamein
    }
    
    
    // Function for if score is received
    @objc func didGetNotificationScore(_ notification: Notification) {
        
        // Take in raw notification
        let scoreinOptional = notification.object as! String?
        
        // Unwrap optional raw notification
        guard let scorein: String = scoreinOptional as? String else {
            return
        }
        
        // Store the score in the main label for the user to see and for storage
        scoreLabel.text = scorein
    }
    
    
    // Function for if number of targets is received
    @objc func didGetNotificationNumber(_ notification: Notification) {
        
        // Take in raw notification
        let numberinOptional = notification.object as! String?
        
        // Unwrap optional raw notification
        guard let numberin: String = numberinOptional as? String else {
            return
        }
        
        // Set the number of targets label equal to the number for display and storage use
        numberLabel.text = numberin
    }
    
    
    
    // Function for if refresh button is tapped
    @IBAction func didTapRefreshButton() {
        
        // Reset the score and number of target flashes to zero
        scoreLabel.text = "0"
        numberLabel.text = "0"
        
    }
    
    
    // If user icon is tapped, bringing up a user identification popup
    @IBAction func showPopUp(sender: AnyObject) {
        
        // Set the User ID label and first name label
        let useridString = useridLabel.text
        let firstnameString = firstnameLabel.text
        
        // Create popover/popup identifier
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserPopUpID") as! PopUpViewController
        
        // Call popup identifier to display the popup and format it so it fills part of the screen and dims out the rest
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        // Post the User ID and first name objects to the notification center so they can be seen by this screen and others
        NotificationCenter.default.post(name: Notification.Name("useridin"), object: useridString)
        NotificationCenter.default.post(name: Notification.Name("firstnamein"), object: firstnameString)
        
    }
    
    
    
    // Function for if button from this screen (VC6) to the next one (VC7) is tapped
    @IBAction func didTapButton6to7() {
        
        // Store User ID and first name in labels
        let useridString = useridLabel.text
        let firstnameString = firstnameLabel.text
        
        // Create link to VC7
        guard let VC = storyboard?.instantiateViewController(identifier: "VC7") as? ViewController7 else {
            return
        }
        
        // Present (go to) VC7
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .coverVertical
        present(VC, animated: true)
        
        // Post User ID and first name for usage in screens
        NotificationCenter.default.post(name: Notification.Name("useridin"), object: useridString)
        NotificationCenter.default.post(name: Notification.Name("firstnamein"), object: firstnameString)
        
    }
    
    
    
    
    
    // Function for if back button from this screen (VC6) back to the previous one (VC5) is tapped
    @IBAction func didTapButton6to5() {
        
        // Store User ID and first name in labels
        let userid = useridLabel.text
        let firstname = firstnameLabel.text
        
        // Create link to VC5
        guard let VC = storyboard?.instantiateViewController(identifier: "VC5") as? ViewController5 else {
            return
        }
        
        // Present (go to) VC5
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .coverVertical
        present(VC, animated: true)
        
        // Post User ID and first name objects to notification center for usage in screens
        NotificationCenter.default.post(name: Notification.Name("useridin"), object: userid)
        NotificationCenter.default.post(name: Notification.Name("firstnamein"), object: firstname)
        
    }

    
    
    
    


}


