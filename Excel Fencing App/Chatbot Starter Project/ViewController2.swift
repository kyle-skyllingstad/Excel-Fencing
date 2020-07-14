//
//  ViewController2.swift
//  EXCEL FENCING MOBILE APPLICATION
//  Created by Kyle Skyllingstad
//

// Import necessary kits/libraries
import UIKit

// Class for screen 2, ViewController2
class ViewController2: UIViewController {

    // Set outlets for buttons and labels
    
    // Buttons
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    // Main screen loading function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        
        // Call the function to set up the UI elements
        setUpElements()

    }
    
    
    
    
    
    
    // Functions ////////////////////////////////
    
    
    // Styling elements function
    func setUpElements() {
 
        // Style the login button
        Utilities.styleHollowButton(loginButton)
    }
    
    
    
    // Function for if Terms of Use button from this screen (VC2) to Terms of Use Screen (VC2TU) tapped
    @IBAction func didTapButton2toTU() {
        
        // Create link to screen TU, VC2TU
        guard let VC = storyboard?.instantiateViewController(identifier: "VC2TU") as? ViewControllerTermsOfUse else {
            return
        }
        
        // Present (go to) VC TU
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true)
    }
    
    
    
    // Function for if back button from this screen (VC2) to Privacy Policy Screen (VC2PP) tapped
    @IBAction func didTapButton2toPP() {
        
        // Create link to screen PP, VC2PP
        guard let VC = storyboard?.instantiateViewController(identifier: "VC2PP") as? ViewControllerPrivacyPolicy else {
            return
        }
        
        // Present (go to) VC2PP
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true)
    }
    
    
    
    
    // Function for if back button from this screen (VC2) back to the previous one (VC1) is tapped
    @IBAction func didTapButton2to1() {
        
        // Create link to VC1
        guard let VC = storyboard?.instantiateViewController(identifier: "VC1") as? ViewController else {
            return
        }
        
        // Present (go to) VC1
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .coverVertical
        present(VC, animated: true)
    }
    

    
    
}
