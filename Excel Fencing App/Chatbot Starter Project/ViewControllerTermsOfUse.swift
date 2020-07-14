//
//  ViewControllerTermsOfUse.swift
//  EXCEL FENCING MOBILE APPLICATION
//
//  Created by Kyle Skyllingstad on 7/4/20.
//

// Import necessary kits/libraries
import UIKit
import WebKit

// Class for Terms of Use Screen
class ViewControllerTermsOfUse: UIViewController {
    
    
    // WebView outlet set
    @IBOutlet weak var webView: WKWebView!
    
    
    // Main screen loading function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up caller for local Terms of Use .html file
        if let indexURL = Bundle.main.url(forResource: "TermsOfUseCode", withExtension: "html") {
                    
            // Call the local Terms of Use .html file
            self.webView.loadFileURL(indexURL, allowingReadAccessTo: indexURL)
        }
        
        
    }
    

    // Function for if back button from this screen (VC2TU) back to screen 2 (VC2) tapped
    @IBAction func didTapButtonTUto2() {
        
        // Create link to screen 2, VC2
        guard let VC = storyboard?.instantiateViewController(identifier: "VC2") as? ViewController2 else {
            return
        }
        
        // Present (go to) VC2
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: false)
    }
    
    
    

}
