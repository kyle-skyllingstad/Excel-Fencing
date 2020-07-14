//
//  ViewController3.swift
//  EXCEL FENCING MOBILE APPLICATION
//  Created by Kyle Skyllingstad
//

// Import necessary kits/libraries
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

// Class for screen 3, ViewController3
class ViewController3: UIViewController, UITextFieldDelegate {

    
    // Set Outlets for buttons, labels, and text fields
    
    // Text Fields
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var signUpButton: UIButton!
    
    // Labels
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var useridLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the text fields to allow the keyboard to be able to be hidden after typing has finished
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // Call function to set up the UI elements
        setUpElements()
        
    }
    
    
    
    
    
    // Functions ////////////////////////////////
    
    
    // Function for stylizing elements
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the text fields
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
    }
    
    
    // Hide keyboard when the user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard when the user presses the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return (true)
    }
    
    
    
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message as a string.
    func validateFields() -> String? {
        
        // Check that all fields are filled in - if empty, returns error message to fill them all in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            // Error message
            return "Please fill in all fields."
        }
        

        // Make sure entered email address is just letters, numbers, ".", and "@"
        // Get email from text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Variable set to just letters, numbers, ".", and "@"
        let characterset = CharacterSet(charactersIn:
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.@")
        
        
        // If something other than letters, numbers, ".", and "@" is entered, return error informing user to only use letters and/or numbers.
        if email.rangeOfCharacter(from: characterset.inverted) != nil {
           return "Email address must contain only letters and/or numbers."
        }
        
        // Make sure email address has the "@" symbol, otherwise tell the user it is invalid
        guard let emailidx = email.firstIndex(of: "@") else {
            return "Email address is invalid. Please try a different one."
        }
        
        
        // Check if the password is secure
        // Get the password from the text field
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If the password turns out to not be valid
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters long and contains at least one special character and one number."
            
        }
        
        
        return nil
    }
    
    
    
    // If the signup button is tapped
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        // See if there is an error
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
            
        // Otherwise no error
        else {
            
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            // Find the index of the "@" symbol
            guard let emailidx = email.firstIndex(of: "@") else {
                return
                
            }
            
            // Get User ID from email (characters before the "@" symbol)
            var userid = String(email.prefix(upTo: emailidx))
            
            // Set text on the User ID label and the name label (both invisible for storage purposes)
            useridLabel.text = userid
            firstnameLabel.text = firstName
            
            
            
            // Create the user in Firestore
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user in Firestore
                    self.showError("Error creating user. Please try a different email.")
                }
                else {
                    
                    // The user was created successfully, now store the first name and the last name
                    let db = Firestore.firestore()
                    
                    // Create identity document identified by User ID
                    db.collection("users").document(userid).setData(["firstname":firstName, "lastname":lastName, "Score":"0", "Number":"0", "Score Percentage":"0", "Total Score":"0", "Total Number":"0", "Overall Percentage":"0", "Counter":"0"])
                    
                    
                    
                    
                    // Old code for testing purposes
                    /*
                    // Create backup Firestore identity document with random key
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "User ID":userid, "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("User data couldn't be saved due to an error")
                        }
                    }
                    */
                    
                    
                    
                    // Create the user in the real-time Firebase Database (for backing up, otherwise unused)
                    // Create user reference
                    let ref = Database.database().reference()
                    
                    // Create backup user profile
                    ref.child("users").child(userid).setValue(["firstname":firstName, "lastname":lastName, "Score":"0", "Number":"0", "Score Percentage":"0", "Total Score":"0", "Total Number":"0", "Overall Percentage":"0", "Counter":"0"])
                    
                    
                    // Transition to the main home screen
                    self.transitionToMain()
                }
                
            }
            
            
            
            
        }
        
    }
    
    
    
    
    // Function for showing error on the label
    func showError(_ message:String) {
        
        // Make error message and make it visible
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    
    // Function for transitioning to VC5, or Main screen
    func transitionToMain() {
        
        // Get User ID and first name from their respective labels
        let useridString = useridLabel.text
        let firstnameString = firstnameLabel.text
        
        // Create link to VC5
        guard let VC = storyboard?.instantiateViewController(identifier: "VC5") as? ViewController5 else {
            return
        }
        
        // Present (go to) VC5
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .flipHorizontal
        present(VC, animated: true)
        
        // Post notification of created email-based user ID text, as well as their first name text, to be available to this screen, VC3, as well as the other screens (ViewControllers)
        NotificationCenter.default.post(name: Notification.Name("useridin"), object: useridString)
        NotificationCenter.default.post(name: Notification.Name("firstnamein"), object: firstnameString)
    }
    
    

    // Function for if back button from this screen (VC3) back to the previous one (VC2) is tapped
    @IBAction func didTapButton3to2() {
        
        // Create link to VC2
        guard let VC = storyboard?.instantiateViewController(identifier: "VC2") as? ViewController2 else {
            return
        }
        
        // Present (go to) VC2
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .crossDissolve
        present(VC, animated: true)
    }
    

}
