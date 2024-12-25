//
//  BingoVC.swift
//  MysthavenTrails
//
//  Created by jin fu on 2024/12/25.
//


import UIKit

class MysthavenBingoViewController: UIViewController {

    // UI Components
    private let gridStackView = UIStackView()
    private let callNumberButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let calledNumberLabel = UILabel()
    private var bingoGrid: [[UIButton]] = []
    private var calledNumbers: Set<Int> = []

    // Bingo Numbers (1-25)
    private let numbers = Array(1...25).shuffled()
    private var currentNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bingo Game"
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
        calledNumberLabel.text = "Press 'Call Number' to start!"
        calledNumberLabel.font = UIFont.boldSystemFont(ofSize: 20)
        calledNumberLabel.textAlignment = .center
        calledNumberLabel.textColor = .white
        calledNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calledNumberLabel)

        // Call Number Button
        callNumberButton.setTitle("Call Number", for: .normal)
        callNumberButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        callNumberButton.backgroundColor = .systemBlue
        callNumberButton.setTitleColor(.white, for: .normal)
        callNumberButton.layer.cornerRadius = 10
        callNumberButton.translatesAutoresizingMaskIntoConstraints = false
        callNumberButton.addTarget(self, action: #selector(callNumberTapped), for: .touchUpInside)
        view.addSubview(callNumberButton)

        // Reset Button
        resetButton.setTitle("Reset Game", for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        resetButton.backgroundColor = .systemRed
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 10
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
        view.addSubview(resetButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            gridStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gridStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            gridStackView.heightAnchor.constraint(equalTo: gridStackView.widthAnchor),

            calledNumberLabel.bottomAnchor.constraint(equalTo: gridStackView.topAnchor, constant: -100),
            calledNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            callNumberButton.topAnchor.constraint(equalTo: gridStackView.bottomAnchor, constant: 20),
            callNumberButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            callNumberButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            callNumberButton.heightAnchor.constraint(equalToConstant: 50),

            resetButton.topAnchor.constraint(equalTo: callNumberButton.bottomAnchor, constant: 10),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resetButton.heightAnchor.constraint(equalToConstant: 50)
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
                button.setTitle("\(numbers[row * 5 + col])", for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                button.backgroundColor = .red
                button.setTitleColor(.black, for: .normal)
                button.layer.cornerRadius = 10
                button.tag = numbers[row * 5 + col]
                button.addTarget(self, action: #selector(bingoButtonTapped(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
                rowButtons.append(button)
            }
            bingoGrid.append(rowButtons)
        }
    }

    @objc private func callNumberTapped() {
        // Call a new number
        let remainingNumbers = numbers.filter { !calledNumbers.contains($0) }
        guard let newNumber = remainingNumbers.randomElement() else {
            calledNumberLabel.text = "All numbers called! Game Over!"
            calledNumberLabel.textColor = .white
            return
        }

        currentNumber = newNumber
        calledNumbers.insert(newNumber)
        calledNumberLabel.text = "Called Number: \(newNumber)"

        // Highlight called number on the grid
        for row in bingoGrid {
            for button in row where button.tag == newNumber {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            }
        }
    }

    @objc private func bingoButtonTapped(_ sender: UIButton) {
        // Ensure the player taps only the current number
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
        let alert = UIAlertController(title: "Bingo!", message: "Congratulation You completed a row, column, or diagonal!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(alert, animated: true, completion: nil)
    }

    @objc private func resetGame() {
        calledNumbers.removeAll()
        currentNumber = nil
        calledNumberLabel.text = "Press 'Call Number' to start!"
        gridStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        createBingoGrid()
    }
}
