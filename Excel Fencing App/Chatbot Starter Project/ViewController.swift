//
//  ViewController.swift
//  EXCEL FENCING MOBILE APPLICATION
//  Created by Kyle Skyllingstad
//

// Import necessary kits/libraries
import UIKit
import ApiAI
import AVFoundation

// Class of the first screenview, screen 1, main Viewcontroller
class ViewController: UIViewController {

    // Set outlet for buttons and labels
    // Button
    @IBOutlet weak var GetStartedButton: UIButton!
    
    
    // Main screen loading function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        
        // Manage navigation bar - make it invisible in the mobile viewing of the app
        self.navigationController?.isNavigationBarHidden = true
        
        // Call the function to set up the UI elements
        setUpElements()
        
    }
    
    
    
    // Functions ////////////////////////////////
    
    
    // Function for styling certain UI elements
    func setUpElements() {
    
        // Style the hollow button
        Utilities.styleHollowButton(GetStartedButton)
    }
    
    
    
    // Function for if button from this screen, screen 1 (VC1) to screen 2 (VC2) tapped
    @IBAction func didTapButton1to2() {
        
        // Create link to screen 2 (VC2)
        guard let VC = storyboard?.instantiateViewController(identifier: "VC2") as? ViewController2 else {
            return
        }
        
        // Present (go to) VC2
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true)
    }
    
    

    
}

