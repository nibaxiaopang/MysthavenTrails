//
//  ColorMatchVC.swift
//  MysthavenTrails
//
//  Created by jin fu on 2024/12/25.
//


import UIKit

class MysthavenColorMatchViewController: UIViewController {

    // IBOutlets for UI Components
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel! // Label displaying the color name
    @IBOutlet weak var gameAreaView: UIView!

    // Game Variables
    private var gameTimer: Timer?
    private var timeLeft = 60
    private var score = 0
    private let colorNames = ["RED", "BLUE", "GREEN", "YELLOW", "ORANGE", "PURPLE"]
    private let colors: [UIColor] = [.red, .blue, .green, .yellow, .orange, .purple]
    private var correctColor: UIColor?
    private var isLayoutReady = false // Flag to track if the layout is ready

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Color Match Game"
        setupGame()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Ensure buttons are generated after the layout is ready
        if !isLayoutReady {
            isLayoutReady = true
            generateColorButtons()
        }
    }

    private func setupGame() {
        // Reset game variables
        score = 0
        timeLeft = 60
        scoreLabel.text = "Score: \(score)"
        timerLabel.text = "Time: \(timeLeft)"
        colorLabel.text = ""
        colorLabel.textAlignment = .center
        colorLabel.font = UIFont.boldSystemFont(ofSize: 50)

        // Clear buttons from previous games
        gameAreaView.subviews.forEach { $0.removeFromSuperview() }

        // Start game timers
        startGameTimers()
        generateColorQuestion()
    }

    private func startGameTimers() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    private func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 1
            timerLabel.text = "Time: \(timeLeft)"
        } else {
            endGame()
        }
    }

    private func generateColorQuestion() {
        // Randomly pick a color name and a text color
        let randomNameIndex = Int.random(in: 0..<colorNames.count)
        let randomColorIndex = Int.random(in: 0..<colors.count)

        colorLabel.text = colorNames[randomNameIndex]
        colorLabel.textColor = colors[randomColorIndex]

        // Set the correct answer to match the text color
        correctColor = colors[randomColorIndex]

        // Create buttons for colors
        if isLayoutReady {
            generateColorButtons()
        }
    }

    private func generateColorButtons() {
        // Clear existing buttons
        gameAreaView.subviews.forEach { $0.removeFromSuperview() }

        // Shuffle the colors
        let shuffledColors = colors.shuffled()

        // Add buttons for each color
        let buttonHeight: CGFloat = 40
        let spacing: CGFloat = 10
        let totalHeight = CGFloat(shuffledColors.count) * buttonHeight + CGFloat(shuffledColors.count - 1) * spacing
        let startY = (gameAreaView.bounds.height - totalHeight) / 2+10

        for (index, color) in shuffledColors.enumerated() {
            let button = UIButton(type: .system)
            button.frame = CGRect(
                x: 20,
                y: startY + CGFloat(index) * (buttonHeight + spacing)+20,
                width: gameAreaView.bounds.width - 40,
                height: buttonHeight
            )
            button.backgroundColor = color
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            gameAreaView.addSubview(button)
        }
    }

    @objc private func colorButtonTapped(_ sender: UIButton) {
        guard let tappedColor = sender.backgroundColor else { return }

        if tappedColor == correctColor {
            // Correct answer
            score += 10
            scoreLabel.text = "Score: \(score)"
            generateColorQuestion() // Generate a new question
        } else {
            // Wrong answer, end the game
            endGame()
        }
    }

    private func endGame() {
        gameTimer?.invalidate()
        let alert = UIAlertController(title: "Game Over", message: "Your score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.setupGame()
        }))
        present(alert, animated: true, completion: nil)
    }
}
