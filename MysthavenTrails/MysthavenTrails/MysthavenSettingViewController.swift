//
//  SettingVC.swift
//  MysthavenTrails
//
//  Created by jin fu on 2024/12/25.
//


import UIKit

class MysthavenSettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func feedback(_ sender: Any) {
        // Create a UIAlertController with an action sheet style
        let alert = UIAlertController(title: "Rate Our App", message: "Please select your rating", preferredStyle: .actionSheet)

        // Add emoji rating options
        let emojiOptions = ["😡", "😕", "😐", "😊", "😍"]

        for (index, emoji) in emojiOptions.enumerated() {
            let emojiAction = UIAlertAction(title: emoji, style: .default) { (_) in
                self.showFeedbackAlert(ratingIndex: index)
            }
            alert.addAction(emojiAction)
        }

        // Add a cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // For iPad presentation
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        // Present the alert
        present(alert, animated: true, completion: nil)
    }

    // Function to display the feedback alert with rating
    func showFeedbackAlert(ratingIndex: Int) {
        let emojiOptions = ["😡", "😕", "😐", "😊", "😍"]
        let selectedEmoji = emojiOptions[ratingIndex]

        let feedbackMessage = "Thank you for your \(selectedEmoji) rating!"

        // Create and present the feedback alert
        let feedbackAlert = UIAlertController(title: "Feedback", message: feedbackMessage, preferredStyle: .alert)
        feedbackAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(feedbackAlert, animated: true, completion: nil)
    }

    
    
}
