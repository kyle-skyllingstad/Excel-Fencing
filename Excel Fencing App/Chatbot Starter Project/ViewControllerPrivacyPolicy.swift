//
//  ViewControllerPrivacyPolicy.swift
//  EXCEL FENCING MOBILE APPLICATION
//
//  Created by Kyle Skyllingstad on 7/4/20.
//

// Import necessary kits/libraries
import UIKit
import WebKit

// Class for Privacy Policy Screen
class ViewControllerPrivacyPolicy: UIViewController {

    // Set up outlet for WebView
    @IBOutlet weak var webView: WKWebView!
    
    
    // Main screen loading function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up caller for local Privacy Policy .html file
        if let indexURL = Bundle.main.url(forResource: "PrivacyPolicyCode", withExtension: "html") {
                    
            // Call for local Privacy Policy .html file
            self.webView.loadFileURL(indexURL, allowingReadAccessTo: indexURL)
        }
        
        
    }
    
    
    

    // Function for if back button from this screen (VC2PP) back to screen 2 (VC2) tapped
    @IBAction func didTapButtonPPto2() {
        
        // Create link to screen 2, VC2
        guard let VC = storyboard?.instantiateViewController(identifier: "VC2") as? ViewController2 else {
            return
        }
        
        // Present (go to) VC2
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: false)
    }
    
    
    
}
