//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Jibryll Brinkley on 5/28/24.
//

import UIKit

enum Mode {
    case flashCard, quiz
}

enum State {
    case question, answer
}


var mode: Mode = .flashCard
var state: State = .question

var answerIsCorrect = false
var correctAnswerCount = 0


class ViewController: UIViewController, UITextFieldDelegate {
    
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        
        updateUI()
    }
    
    @IBAction func next(_ sender: Any) {
        
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
        }
        state = .question
        
        updateUI()
    }
    
    var currentElementIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateFlashCardUI() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
    }
    
    func updateQuizUI() {
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct! ✅"
            } else {
                answerLabel.text = "❌"
            }
        }
    }
    
    
    func updateUI() {
        switch mode {
        case .flashCard:
            updateFlashCardUI()
        case .quiz:
            updateQuizUI()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let textFieldContents = textField.text!
        
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            answerIsCorrect = true
            correctAnswerCount += 1
            print("Correct")
        } else {
            answerIsCorrect = false
            print("wrong")
        }
        
        state = .answer
        
        updateUI()
        
        return true
        
    }
}

