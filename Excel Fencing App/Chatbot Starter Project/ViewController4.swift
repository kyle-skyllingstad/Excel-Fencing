//
//  ViewController4.swift
//  EXCEL FENCING MOBILE APPLICATION
//  Created by Kyle Skyllingstad
//

// Import necessary kits/libraries
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

// Class for screen 4, ViewController4
class ViewController4: UIViewController, UITextFieldDelegate {
    
    
    // Create outlet variables for buttons, labels, and text fields
    
    // Text fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var loginButton: UIButton!
    
    // Labels
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var useridLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    
    
    
    // Main screen loading function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the text fields to allow the keyboard to be able to be hidden after typing has finished
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // Call the function to set up the UI elements
        setUpElements()
        
    }
    
    
    
    
    
    // Functions ////////////////////////////////
    
    
    
    // Function for formatting and setting up UI elements
    func setUpElements () {
        
        //Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)

    }
    
    
    
    // Hide keyboard when the user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard when the user presses the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return (true)
    }
    
    
    
    
    // Field validation funtion - it checks the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message as a string.
    func validateFields() -> String? {
        
        // Check that all fields are filled in - if not, prompts user to fill them all in.
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            // Tell user to fill them in
            return "Please fill in all fields."
        }
        
        // Get email address from text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Set of acceptable characters in the email address - letters, numbers, ".", and "@"
        let characterset = CharacterSet(charactersIn:
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.@")
        
        // If the email address contains something other than letters, numbers, ".", and/or "@", tell the user to only use an email address with those characters.
        if email.rangeOfCharacter(from: characterset.inverted) != nil {
           return "Email address must contain only letters and/or numbers."
        }
        
        // Check to make sure email address contains the "@" symbol - if not, it is invalid, and the user is prompted
        guard let emailidx = email.firstIndex(of: "@") else {
            return "Email address is invalid. Please try a different one."
        }
        
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If the password is not valid
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            // Inform user that their entered password isn't secure enough
            return "Entered password does not match the account. Please try again."
            
        }
        
        
        return nil
    }
    
    
    
    // If login button tapped
    @IBAction func loginTapped(_ sender: Any) {
        
        
        // Validate the fields
        let error = validateFields()
        
        // If there is a reported error in the text fields
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
            
        // Otherwise the text fields are acceptable
        else {
            
            // Create cleaned versions of the text field
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Collect characters prior to the "@" symbol for user ID
            guard let emailidx = email.firstIndex(of: "@") else {
                return
                
            }
            
            // Get User ID from email (characters before the "@" symbol)
            var userid = String(email.prefix(upTo: emailidx))
            
            
            // Signing in the user
            // Check and see if there is an authorization error for the user logging into Firebase
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, error) in
                
                // If there is an error logging into Firebase, such as no internet
                if error != nil {
                    
                    // Couldn't sign in - show the error message and make it visible
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                    
                // Was able to log in successfully
                else {
                    
                    // Call Firestore
                    let db = Firestore.firestore()

                    // Call the user document by their unique User ID
                    db.collection("users").document(userid).getDocument { (document, error) in
                        
                        // Check for an error - if there is not one
                        if error == nil {
                            
                            // Check that this document exists
                            if document != nil && document!.exists {
                                
                                // Old code for testing and modification purposes
                                /*
                                // Extract the data from the document
                                let documentData = document!.data()
                                
                                let dataDescription = document!.data().map(String.init(describing:)) ?? "nil"
                                print(dataDescription)
                                */
                                
                                // Get the first name from the document
                                let firstNameString = document!.get("firstname") as! String
                                
                                
                                
                                // Set text on the User ID label and the name label (both invisible for storage purposes)
                                self.useridLabel.text = userid
                                self.firstnameLabel.text = firstNameString
                                
                                
                                // Transition to the main home screen
                                self.transitionToMain()
                                
                            }
                                
                            // Else otherwise the document was deleted; the account must have been deleted, and the user cannot sign in.
                            else {
                                
                                // Create the error message about the account being nonexistent and display it on the label
                                self.errorLabel.text = "There is no user record corresponding to this identifier. The user may have been deleted."
                                self.errorLabel.alpha = 1
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
   
    }
    
    
    
    
    
    
    // Function for showing error on the label
    func showError(_ message:String) {
        
        // Actually show the error
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    
    // Function for transitioning to VC5, or the Main screen
    func transitionToMain() {
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
        
        // Post notification of created email-based user ID text and first name text to be available to this screen, VC3, as well as the other screens (ViewControllers)
        NotificationCenter.default.post(name: Notification.Name("useridin"), object: useridString)
        NotificationCenter.default.post(name: Notification.Name("firstnamein"), object: firstnameString)
    }
    

    
    // Function for if back button from this screen (VC4) back to the previous one (VC2) is tapped
    @IBAction func didTapButton4to2() {
        
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
