//
//  SortItOutVC.swift
//  MysthavenTrails
//
//  Created by jin fu on 2024/12/25.
//

import UIKit

class MysthavenSortItOutViewController: UIViewController {
    
    // IBOutlets for UI Components
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameAreaView: UIView!
    @IBOutlet weak var startButton: UIButton! // Start button

    // Game Variables
    private var bins: [UIButton] = []
    private let categories = ["Alphabet", "Number", "Shape"]
    private var gameTimer: Timer?
    private var timeLeft = 60
    private var score = 0
    private var currentItem: UIButton?
    private var gameActive = false // Flag to track if the game is active

    // Items to spawn
    private let gameItems: [MysthavenGameItem] = [
        MysthavenGameItem(type: "Alphabet", value: "A", category: 0),
        MysthavenGameItem(type: "Alphabet", value: "B", category: 0),
        MysthavenGameItem(type: "Number", value: "1", category: 1),
        MysthavenGameItem(type: "Number", value: "2", category: 1),
        MysthavenGameItem(type: "Shape", value: "Circle", category: 2),
        MysthavenGameItem(type: "Shape", value: "Square", category: 2)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sort It Out"
        setupBins()
    }

    private func setupBins() {
        let binStackView = UIStackView()
        binStackView.axis = .horizontal
        binStackView.distribution = .fillEqually
        binStackView.spacing = 10
        binStackView.translatesAutoresizingMaskIntoConstraints = false

        for (index, category) in categories.enumerated() {
            let binButton = UIButton(type: .system)
            binButton.setTitle(category, for: .normal)
            binButton.backgroundColor = .systemBlue
            binButton.setTitleColor(.white, for: .normal)
            binButton.layer.cornerRadius = 10
            binButton.tag = index // Tag matches the category
            binButton.addTarget(self, action: #selector(binTapped(_:)), for: .touchUpInside)
            bins.append(binButton)
            binStackView.addArrangedSubview(binButton)
        }

        view.addSubview(binStackView)
        NSLayoutConstraint.activate([
            binStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            binStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            binStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            binStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @IBAction func startGame(_ sender: UIButton) {
        // Start the game
        gameActive = true
        score = 0
        timeLeft = 60
        scoreLabel.text = "Score: \(score)"
        timerLabel.text = "Time: \(timeLeft)"
        startButton.isHidden = true // Hide the start button
        spawnItem()

        // Schedule the timer
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    @objc private func binTapped(_ sender: UIButton) {
        guard gameActive else { return } // Ignore taps if the game isn't active
        guard let item = currentItem else { return }

        if sender.tag == item.tag {
            // Correct bin tapped
            score += 1
            scoreLabel.text = "Score: \(score)"
            item.removeFromSuperview()
            spawnItem()
        } else {
            // Wrong bin tapped, end game
            endGame()
        }
    }

    private func spawnItem() {
        currentItem?.removeFromSuperview() // Remove the previous item

        currentItem = UIButton(type: .custom)
        guard let item = currentItem else { return }

        // Select a random game item
        guard let randomItem = gameItems.randomElement() else { return }

        // Generate random position
        let randomX = CGFloat.random(in: 0...(gameAreaView.bounds.width - 80))
        let randomY = CGFloat.random(in: 0...(gameAreaView.bounds.height - 50))
        item.frame = CGRect(x: randomX, y: randomY, width: 80, height: 50)

        // Set item properties
        item.setTitle(randomItem.value, for: .normal)
        item.setTitleColor(.black, for: .normal)
        item.backgroundColor = randomBrightColor() // Set random background color
        item.tag = randomItem.category

        // Shape-specific adjustments
        if randomItem.type == "Shape" {
            if randomItem.value == "Circle" {
                item.layer.cornerRadius = 25
            } else if randomItem.value == "Square" {
                item.layer.cornerRadius = 0
            }
        }

        // Add the item to the game area
        gameAreaView.addSubview(item)
    }

    private func randomBrightColor() -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0.5...1),
            green: CGFloat.random(in: 0.5...1),
            blue: CGFloat.random(in: 0.5...1),
            alpha: 1.0
        )
    }

    private func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 1
            timerLabel.text = "Time: \(timeLeft)"
        } else {
            endGame()
        }
    }

    private func endGame() {
        // End the game
        gameActive = false
        gameTimer?.invalidate()
        currentItem?.removeFromSuperview()
        currentItem = nil

        // Show game over alert
        let alert = UIAlertController(title: "Game Over", message: "Your Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.startButton.isHidden = false // Show the start button again
        }))
        present(alert, animated: true, completion: nil)
    }
}
