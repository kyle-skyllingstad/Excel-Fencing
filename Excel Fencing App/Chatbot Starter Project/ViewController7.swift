//
//  ViewController6.swift
//  EXCEL FENCING MOBILE APPLICATION
//  Created by Kyle Skyllingstad
//

// Import necessary kits/libraries
import UIKit
import Firebase
import FirebaseDatabase
import Charts

// Class for screen 7, ViewController7 (unused currently)
class ViewController7: UIViewController {
    
    
    // Set outlet labels and graphs
    
    // Pie chart graphs
    @IBOutlet weak var roundPieChartView: PieChartView!
    @IBOutlet weak var sessionPieChartView: PieChartView!
    
    // Labels
    @IBOutlet weak var useridLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var scorePercentageLabel: UILabel!
    @IBOutlet weak var overallPercentageLabel: UILabel!
    

    // Main screen loading function
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // Call reception notification center function to receive incoming information (User ID and first name)
            NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationUserID(_:)), name: Notification.Name("useridin"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationFirstName(_:)), name: Notification.Name("firstnamein"), object: nil)

    }
    
    
    
    
    
    
    // Functions ////////////////////////////////
    
    
    
    // Function for if User ID is received
    @objc func didGetNotificationUserID(_ notification: Notification) {
        
        // Take in raw notification
        let useridinOptional = notification.object as! String?
        
        // Unwrap optional raw notification
        guard let useridin: String = useridinOptional as? String else {
            return
        }
        
        // Set the User ID label equal to the User ID for use
        useridLabel.text = useridin
        
        // Get optional from text and unwrap it for use
        let userid = useridinOptional!
        
        // Call the Firestore database
        let db = Firestore.firestore()

        // Call the user's document in Firestore
        db.collection("users").document(userid).getDocument { (document, error) in
            
            // Check for an error
            // If there is no error
            if error == nil {
                
                // Check that this document exists
                // If it does exist
                if document != nil && document!.exists {
                    
                    // Extract the user data from the document
                    let scoreString = document!.get("Score") as! String
                    let numberString = document!.get("Number") as! String
                    let scorePercentageFullString = document!.get("Score Percentage") as! String
                    let totalScoreString = document!.get("Total Score") as! String
                    let totalNumberString = document!.get("Total Number") as! String
                    let overallPercentageFullString = document!.get("Overall Percentage") as! String
                    
                    // Convert data to double for computations
                    // This round only
                    let score = Double(scoreString)!
                    let number = Double(numberString)!
                    let misses = number - score
                    
                    // All rounds in session
                    let totalScore = Double(totalScoreString)!
                    let totalNumber = Double(totalNumberString)!
                    let totalMisses = totalNumber - totalScore
                    
                    // Percentages (round and session) - convert to integer then to String to remove decimals
                    // This round
                    let scorePercentage = Double(scorePercentageFullString)!
                    let scorePercentageInteger = Int(scorePercentage)
                    let scorePercentageString = String(scorePercentageInteger)
                    
                    // Overall session
                    let overallPercentage = Double(overallPercentageFullString)!
                    let overallPercentageInteger = Int(overallPercentage)
                    let overallPercentageString = String(overallPercentageInteger)
                    

                    
                    // Set up data for this round's pie chart
                    let results1 = ["Strikes", "Misses"]
                    let totals1 = [score, misses]
                    
                    // Set up data for the overall session's pie chart
                    let resultst = ["Strikes", "Misses"]
                    let totalst = [totalScore, totalMisses]
                    
                    
                    // Call the chart function to create the pie charts for current round's data and the entire session's data
                    self.customizePieChart(pieChartView: self.roundPieChartView, chartTitle: "This Round", dataPoints: results1, values: totals1.map{ Double($0) })
                    self.customizePieChart(pieChartView: self.sessionPieChartView, chartTitle: "Session Overall", dataPoints: resultst, values: totalst.map{ Double($0) })
                    
                    
                    
                    // Set score percentage labels (round and session)
                    self.scorePercentageLabel.text = "\(scorePercentageString)%"
                    self.overallPercentageLabel.text = "\(overallPercentageString)%"
                    
                    // Set invisible Score and Number labels for data transmission to other screens
                    self.scoreLabel.text = scoreString
                    self.numberLabel.text = numberString
                    
                }
                
            }
            
        }
        
    }
    
    
    
    // Function that creates and customizes a pie chart for the selected data
    func customizePieChart(pieChartView: PieChartView, chartTitle: String, dataPoints: [String], values: [Double]) {
      
        // Set ChartDataEntry data to keep track of data
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        // Set ChartDataSet for the pie chart to display in text
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: chartTitle)
        
        // Call coloring subfunction to change the colors of the pie chart's text and visual graphics
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        // Set ChartData for the pie chart to later display in the visual graphics graph
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        // Formatting options
        let format = NumberFormatter()
        format.numberStyle = .none
        
        // Carry out formatting options
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        // Assign the pie chart's data to the pie chart's graphics view (visual display)
        pieChartView.data = pieChartData
    }
    
    // Graphics coloration subfunction of customizePieChart main function
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      
        // Initialize color array and color counter
        var colors: [UIColor] = []
        
        // Main loop that counts through number of colors needed
        for colorCounter in 0..<numbersOfColor {
        
            // Old code for testing and modification purposes
            // Random color generator
            // let red = Double(arc4random_uniform(256))
            
            // Set individual color components based on whether they correspond to the strikes (purple) or the misses (light gray)
            let red = 25.0 + 160*(Double(colorCounter))
            let green = 0.0 + 185*(Double(colorCounter))
            let blue = 200.0 - 15*(Double(colorCounter))
            
            // Create combined color combination for display
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        
            // Change color array and add new color entries so it captures strikes and misses
            colors.append(color)
      
        }
      
        return colors
    }
    
    
    
    
    // Function for if first name is received
    @objc func didGetNotificationFirstName(_ notification: Notification) {
        
        // Take in raw notification
        let firstnameinOptional = notification.object as! String?
        
        // Unwrap optional raw notification
        guard let firstnamein: String = firstnameinOptional as? String else {
            return
        }
        
        // Set the first name text label to store the first name for use
        firstnameLabel.text = firstnamein
    }
    
    
    
    // Function for if close button from this screen (VC7) back to the previous one (VC6) is tapped
    @IBAction func didTapButton7to6() {
        
        // Retain User ID, first name, score, and number of flashes
        let useridString = useridLabel.text
        let firstnameString = firstnameLabel.text
        let scoreString = scoreLabel.text
        let numberString = numberLabel.text
        
        // Create link to VC6
        guard let VC = storyboard?.instantiateViewController(identifier: "VC6") as? ViewController6 else {
            return
        }
        
        // Present (go to) VC6
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .coverVertical
        present(VC, animated: true)
        
        // post User ID, first name, score, and number of targets objects to notification center for usage on this screen and others
        NotificationCenter.default.post(name: Notification.Name("useridin"), object: useridString)
        NotificationCenter.default.post(name: Notification.Name("firstnamein"), object: firstnameString)
        NotificationCenter.default.post(name: Notification.Name("scorein"), object: scoreString)
        NotificationCenter.default.post(name: Notification.Name("numberin"), object: numberString)
        
    }
    
    


}
