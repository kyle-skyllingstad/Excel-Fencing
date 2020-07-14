//
//  PopUpViewController.swift
//  EXCEL FENCING MOBILE APPLICATION
//
//  Created by Kyle Skyllingstad on 6/22/20.
//

// Import necessary kits/libraries
import UIKit
import Firebase
import FirebaseDatabase


// Class for the user identification Popup/popover 
class PopUpViewController: UIViewController {
    
    
    // Set outlets for labels and buttons
    
    // Labels
    @IBOutlet weak var useridLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var clearSessionDataButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    

    // Main screen loading function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Call the function to set up the UI elements
        setUpElements()

        // Set up background properties
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Call reception notification center function to receive incoming information (text that contains the User ID and the first name)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationUserID(_:)), name: Notification.Name("useridin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationFirstName(_:)), name: Notification.Name("firstnamein"), object: nil)
        
        self.showAnimation()
        
    }
    
    
    
    
    
    // Functions ////////////////////////////////
    
    
    
    // Function for styllizing UI elements
    func setUpElements() {
    
        // Style some of the buttons
        Utilities.styleFadeButton(deleteAccountButton)
        Utilities.styleFadeButton(signOutButton)
    }
    

    // Function for closing this popup view
    @IBAction func closePopUp(sender: AnyObject) {
        
        // Old code for testing purposes
        // self.view.removeFromSuperview()
        
        // Call function to animate the removal of the view
        self.removeAnimation()
    }
    
    
    
    // Function for if sign out button from this screen (VCPU) back to the entry one (VC2) is tapped
    @IBAction func didTapButtonPUto2() {
        
        // Create link to VC2
        guard let VC = storyboard?.instantiateViewController(identifier: "VC2") as? ViewController2 else {
            return
        }
        
        // Present (go to) VC2
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .flipHorizontal
        present(VC, animated: true)
    }
    
    
    
    
    // Function for if clear data/performance history button is pressed
    @IBAction func didTapClearSessionDataButton() {
        
        // Create alert with yes/no options warning the user about deleting all of their personal performance history data for this session
        let alert = UIAlertController(title: "Are you sure you wish to clear all performance history?", message: "This will permanently delete all scores and cannot be undone.", preferredStyle: .alert)

        
        // If user confirms the request to clear all performance history by tapping "Yes"
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
        
            // Read in userid optional from label text
            let useridStringOptional = self.useridLabel.text

            // Unwrap optional string
            guard let useridStringRaw: String = useridStringOptional as? String else {
                return
            }

            // Get just the user ID from the text
            let userid = useridStringRaw.replacingOccurrences(of: "User ID: ", with: "")
        
            // Call Firestore database
            let db = Firestore.firestore()
        
            // Fetch user-specific document
            db.collection("users").document(userid).getDocument { (document, error) in
            
            
                // Check for an error
                // If there is no error
                if error == nil {
                
                    // Check that this document exists
                    // If it exists
                    if document != nil && document!.exists {
                    
                        // Call upload document to clear
                        let document = db.collection("users").document(userid)

                        // Clear all session-based (current round and ongoing session) user performance data
                        document.updateData(["Score":"0", "Number":"0", "Score Percentage":"0", "Total Score":"0", "Total Number":"0", "Overall Percentage":"0", "Counter":"0"]) { err in
                            
                            // If there is an error clearing all performance data for the ongoing session
                            if let err = err {
                                print("Error clearing session data: \(err)")
                                
                                // Otherwise no error and it was deleted successfully
                            } else {
                                print("Session Data Successfully cleared")
                                
                                // Create announcement popup informing user that their performance history has been successfully deleted
                                let announcement = UIAlertController(title: "Success!", message: "All performance history has successfully been cleared.", preferredStyle: .alert)
                                
                                // If user confirms the request to clear all performance history by tapping "Yes"
                                announcement.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                
                                // Present this announcement animation
                                self.present(announcement, animated: true)
                            
                            }
                            
                        }
                    
                    }
                
                }
            
            }
          
            
            
            
        }))
        
        // If on second thought the user presses "No" and does not wish to clear all performance data for the session
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        // Present user confirmation alert animation
        self.present(alert, animated: true)
            
            
 
    }
    
    
    
    // Function for if delete account button is pressed
    @IBAction func DeleteAccount(sender: AnyObject) {
        
        // Create alert with yes/no options warning the user that all acount information will be permanently deleted and that it cannot be undone.
        let alert = UIAlertController(title: "Are you sure you wish to delete this account?", message: "This will permanently delete all user information and cannot be undone.", preferredStyle: .alert)

        
        // If user confirms the request to delete the account by tapping "Yes"
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            // Read in userid optional from label text
            let useridStringOptional = self.useridLabel.text

            // Unwrap optional string
            guard let useridStringRaw: String = useridStringOptional as? String else {
                return
            }

            // Get just the user ID from the text
            let userid = useridStringRaw.replacingOccurrences(of: "User ID: ", with: "")

            // Call Firestore databse
            let db = Firestore.firestore()
            
            // Delete Firestore account
            // Fetch the user's personal Firestore document and delete it
            db.collection("users").document(userid).delete() { err in
                
                // If there is an error in fetching and deleting the user's document
                if let err = err {
                    print("Error deleting user account: \(err)")
                    
                    // Otherwise no error; user document (with all of his/her data) was successfully deleted
                } else{
                    print("User account successfully deleted")
                    
                    // Delete Realtime Database account (backup)
                    // Call Firestore realtime database reference
                    let ref = Database.database().reference()
                    
                    // Delete the user-specific backup data
                    ref.child("users").child(userid).removeValue() 
                     
                    // Create announcement that the user account has successfully been permanently deleted
                    let announcement = UIAlertController(title: "Success!", message: "The user account has successfully been permanently deleted.", preferredStyle: .alert)
                    
                    // If user confirms by pressing "OK" and accepting the message that their account has been deleted
                    announcement.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        // Create link to VC2
                        guard let VC = self.storyboard?.instantiateViewController(identifier: "VC2") as? ViewController2 else {
                            return
                        }
                        
                        // Present (go to) VC2
                        VC.modalTransitionStyle = .flipHorizontal
                        self.present(VC, animated: true)
                    
                    }))
                      
                    // Present the success anouncement animations
                    self.present(announcement, animated: true)
                    
                }
            }
            
            
        }))
        
        // User "No" option where the user can on second thought decide to not delete their entire account
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        // Present warning alert animation
        self.present(alert, animated: true)
        
    }
    
    
    
    
    // Function for if User ID is received
    @objc func didGetNotificationUserID(_ notification: Notification) {
        
        // Take in raw notification
        let useridinOptional = notification.object as! String?
        
        // Unwrap optional raw notification
        guard let useridin: String = useridinOptional as? String else {
            return
        }
        
        // Set User ID label to store the User ID object for use on this screen
        useridLabel.text = "User ID: \(useridin)"
    }
    
    
    // Function for If first name is received
    @objc func didGetNotificationFirstName(_ notification: Notification) {
        
        // Take in raw notification
        let firstnameinOptional = notification.object as! String?
        
        // Unwrap optional raw notification
        guard let firstnamein: String = firstnameinOptional as? String else {
            return
        }
        
        // Set first name label to the first name object for storage on this screen
        firstnameLabel.text = firstnamein
    }
    
    
    // Function that shows the popup animation when it appears
    func showAnimation() {
        
        // Set the popup at its normal size
        self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        // It starts out invisible
        self.view.alpha = 0.0
        
        // Quick fade in that makes the popup appear visible
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    
    // Function for removing the popup in a fade out
    func removeAnimation() {
        
        // Quick fade out that makes the popup appear invisible
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 0.0
        }, completion: { finished in
            return
        })
    }
    
    
    

}
