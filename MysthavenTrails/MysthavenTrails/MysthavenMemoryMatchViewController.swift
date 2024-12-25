//
//  MemoryMatchVC.swift
//  MysthavenTrails
//
//  Created by jin fu on 2024/12/25.
//


import UIKit

class MysthavenMemoryMatchViewController: UIViewController {

    // IBOutlets for UI Components
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var gameAreaView: UIView!

    // Game Variables
    private var score = 0
    private var timeLeft = 60
    private var gameTimer: Timer?
    private var targetTimer: Timer?
    private var targets: [UIButton] = []
    private var targetSpeeds: [CGPoint] = []
    private var correctAnswer = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Math Target Challenge"
        setupGame()
    }

    private func setupGame() {
        // Reset game variables
        score = 0
        timeLeft = 60
        scoreLabel.text = "Score: \(score)"
        timerLabel.text = "Time: \(timeLeft)"
        questionLabel.text = ""
        
        // Clear existing targets
        gameAreaView.subviews.forEach { $0.removeFromSuperview() }
        targets.removeAll()
        targetSpeeds.removeAll()
        
        // Start timers
        startGameTimers()
        generateQuestionAndAnswers()
    }

    private func startGameTimers() {
        // Timer for countdown
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        
        // Timer for moving targets
        targetTimer?.invalidate()
        targetTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            self?.moveTargets()
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

    private func generateQuestionAndAnswers() {
        // Generate a random math question
        let num1 = Int.random(in: 1...10)
        let num2 = Int.random(in: 1...10)
        correctAnswer = num1 + num2
        questionLabel.text = "What is \(num1) + \(num2)?"

        // Clear existing targets
        gameAreaView.subviews.forEach { $0.removeFromSuperview() }
        targets.removeAll()
        targetSpeeds.removeAll()

        // Spawn targets with random answers
        let correctIndex = Int.random(in: 0..<5)
        for i in 0..<5 {
            let answer = (i == correctIndex) ? correctAnswer : Int.random(in: 1...20)
            spawnTarget(with: answer)
        }
    }

    private func spawnTarget(with answer: Int) {
        // Generate random position
        let targetSize: CGFloat = 50.0
        let randomX = CGFloat.random(in: 0...(gameAreaView.bounds.width - targetSize))
        let randomY = CGFloat.random(in: 0...(gameAreaView.bounds.height - targetSize))
        
        // Create a target button
        let targetButton = UIButton(type: .system)
        targetButton.frame = CGRect(x: randomX, y: randomY, width: targetSize, height: targetSize)
        targetButton.backgroundColor = .systemRed
        targetButton.layer.cornerRadius = targetSize / 2 // Make it circular
        targetButton.setTitle("\(answer)", for: .normal)
        targetButton.setTitleColor(.white, for: .normal)
        targetButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        targetButton.addTarget(self, action: #selector(targetTapped(_:)), for: .touchUpInside)
        
        // Add target to game area and track its speed
        gameAreaView.addSubview(targetButton)
        targets.append(targetButton)
        targetSpeeds.append(CGPoint(x: CGFloat.random(in: -2...2), y: CGFloat.random(in: -2...2)))
    }

    private func moveTargets() {
        for (index, target) in targets.enumerated() {
            var newFrame = target.frame
            let speed = targetSpeeds[index]
            
            // Update position based on speed
            newFrame.origin.x += speed.x
            newFrame.origin.y += speed.y
            
            // Check for collisions with game area bounds
            if newFrame.origin.x <= 0 || newFrame.origin.x + newFrame.width >= gameAreaView.bounds.width {
                targetSpeeds[index].x *= -1 // Reverse horizontal direction
            }
            if newFrame.origin.y <= 0 || newFrame.origin.y + newFrame.height >= gameAreaView.bounds.height {
                targetSpeeds[index].y *= -1 // Reverse vertical direction
            }
            
            // Update target frame
            target.frame = newFrame
        }
    }

    @objc private func targetTapped(_ sender: UIButton) {
        guard let tappedAnswer = Int(sender.title(for: .normal) ?? "") else { return }

        if tappedAnswer == correctAnswer {
            // Correct answer tapped
            score += 10
            scoreLabel.text = "Score: \(score)"
            generateQuestionAndAnswers() // Generate new question and targets
        } else {
            // Incorrect answer tapped
            score -= 5
            scoreLabel.text = "Score: \(score)"
        }
    }

    private func endGame() {
        // Invalidate timers
        gameTimer?.invalidate()
        targetTimer?.invalidate()
        
        // Show game over alert
        let alert = UIAlertController(title: "Game Over", message: "Your score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.setupGame()
        }))
        present(alert, animated: true, completion: nil)
    }
}
