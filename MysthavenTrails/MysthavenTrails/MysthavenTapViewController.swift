//
//  TapVC.swift
//  MysthavenTrails
//
//  Created by jin fu on 2024/12/25.
//


import UIKit

class MysthavenTapViewController: UIViewController {

    // UI Components
    private let gridStackView = UIStackView()
    private let calledNumberLabel = UILabel()
    private let startGameButton = UIButton(type: .system)
    private var bingoGrid: [[UIButton]] = []
    private var calledNumbers: Set<Int> = []
    private var gameTimer: Timer?
    private var bingoNumbers = Array(1...25).shuffled()
    
    // Game Variables
    private var currentNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        createBingoGrid()
    }

    private func setupUI() {
        // Grid Stack View
        gridStackView.axis = .vertical
        gridStackView.distribution = .fillEqually
        gridStackView.spacing = 10
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridStackView)

        // Called Number Label
        calledNumberLabel.text = "Press 'Start Game' to begin!"
        calledNumberLabel.font = UIFont.boldSystemFont(ofSize: 20)
        calledNumberLabel.textAlignment = .center
        calledNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calledNumberLabel)

        // Start Game Button
        startGameButton.setTitle("Start Game", for: .normal)
        startGameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startGameButton.backgroundColor = .systemBlue
        startGameButton.setTitleColor(.white, for: .normal)
        startGameButton.layer.cornerRadius = 10
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        view.addSubview(startGameButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            gridStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gridStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            gridStackView.heightAnchor.constraint(equalTo: gridStackView.widthAnchor),

            calledNumberLabel.bottomAnchor.constraint(equalTo: gridStackView.topAnchor, constant: -20),
            calledNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            startGameButton.topAnchor.constraint(equalTo: gridStackView.bottomAnchor, constant: 20),
            startGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func createBingoGrid() {
        bingoGrid = []
        for row in 0..<5 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 10
            gridStackView.addArrangedSubview(rowStackView)

            var rowButtons: [UIButton] = []
            for col in 0..<5 {
                let button = UIButton(type: .system)
                button.setTitle("\(bingoNumbers[row * 5 + col])", for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                button.backgroundColor = .lightGray
                button.setTitleColor(.black, for: .normal)
                button.layer.cornerRadius = 10
                button.tag = bingoNumbers[row * 5 + col]
                button.addTarget(self, action: #selector(bingoButtonTapped(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
                rowButtons.append(button)
            }
            bingoGrid.append(rowButtons)
        }
    }

    @objc private func startGame() {
        startGameButton.isEnabled = false
        startGameButton.backgroundColor = .gray
        calledNumbers.removeAll()
        bingoNumbers.shuffle()
        currentNumber = nil
        calledNumberLabel.text = "Game started! Numbers are being called."

        // Start calling numbers
        gameTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.callNumber()
        }
    }

    private func callNumber() {
        // Pick a random number that hasn't been called
        let remainingNumbers = bingoNumbers.filter { !calledNumbers.contains($0) }
        guard let newNumber = remainingNumbers.randomElement() else {
            endGame()
            return
        }

        currentNumber = newNumber
        calledNumbers.insert(newNumber)
        calledNumberLabel.text = "Called Number: \(newNumber)"
    }

    @objc private func bingoButtonTapped(_ sender: UIButton) {
        // Ensure the player taps only the called number
        guard let number = currentNumber, sender.tag == number else { return }

        sender.backgroundColor = .systemGreen
        sender.setTitleColor(.white, for: .normal)
        checkForBingo()
    }

    private func checkForBingo() {
        // Check rows, columns, and diagonals for a win
        for row in bingoGrid {
            if row.allSatisfy({ $0.backgroundColor == .systemGreen }) {
                showBingoAlert()
                return
            }
        }

        for col in 0..<5 {
            if bingoGrid.allSatisfy({ $0[col].backgroundColor == .systemGreen }) {
                showBingoAlert()
                return
            }
        }

        if (0..<5).allSatisfy({ bingoGrid[$0][$0].backgroundColor == .systemGreen }) ||
            (0..<5).allSatisfy({ bingoGrid[$0][4 - $0].backgroundColor == .systemGreen }) {
            showBingoAlert()
        }
    }

    private func showBingoAlert() {
        gameTimer?.invalidate()
        let alert = UIAlertController(title: "Bingo!", message: "You completed a row, column, or diagonal!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(alert, animated: true, completion: nil)
    }

    private func endGame() {
        gameTimer?.invalidate()
        calledNumberLabel.text = "All numbers called! Game Over."
        startGameButton.isEnabled = true
        startGameButton.backgroundColor = .systemBlue
    }

    private func resetGame() {
        calledNumbers.removeAll()
        currentNumber = nil
        calledNumberLabel.text = "Press 'Start Game' to begin!"
        startGameButton.isEnabled = true
        startGameButton.backgroundColor = .systemBlue
        gridStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        createBingoGrid()
    }
}
