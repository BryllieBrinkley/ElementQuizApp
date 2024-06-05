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
    case question, answer, score
}

var state: State = .question

var answerIsCorrect = false
var correctAnswerCount = 0

var quizScore = 0


class ViewController: UIViewController, UITextFieldDelegate {
    
    let fixedElementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    
    var elementList: [String] = []
    
    

    
    var mode: Mode = .flashCard {
        didSet {
            switch mode {
            case .flashCard:
                setupFlashcards()
            case .quiz:
                setupQuiz()
            }
            updateUI()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextElement: UIButton!
    
    
    
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        
        updateUI()
    }
    
    @IBAction func next(_ sender: Any) {
        
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
        state = .question
        updateUI()
    }
    
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
    
    var currentElementIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mode = .flashCard
    }
    
    func updateFlashCardUI(elementName: String) {

        textField.isHidden = true
        textField.resignFirstResponder()
        showAnswerButton.isHidden = false
        
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }

        nextElement.isEnabled = true
        nextElement.setTitle("Next Element", for: .normal)
        
        modeSelector.selectedSegmentIndex = 0
    }
    
    
    func updateQuizUI(elementName: String) {
        
        textField.isHidden = false
        
        switch state {
        case .question:
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        
        //answer label
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "✅"
            } else {
                answerLabel.text = "❌\nCorrect answer: " + elementName
            }
        case .score:
            answerLabel.text = ""
        }
        
        if state == .score {
            displayScoreAlert()
        }
        
        modeSelector.selectedSegmentIndex = 1
        
        showAnswerButton.isHidden = true

        if currentElementIndex == elementList.count - 1 {
            nextElement.setTitle("Show Score", for: .normal)
        } else {
            nextElement.setTitle("Next Question", for: .normal)
        }
        
        switch state {
            
        case .question:
            nextElement.isEnabled = false
        case .answer:
            nextElement.isEnabled = true
        case .score:
            nextElement.isEnabled = false
        }
        
    }
    
    func updateUI() {
        
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)

        case .quiz:
            updateQuizUI(elementName: elementName)
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
    
    func displayScoreAlert() {
        
        let alert = UIAlertController(title: "Quiz Score", message: "Your score is \(correctAnswerCount) out of \(elementList.count).", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
    }
    
    
    func setupFlashcards() {
        elementList = fixedElementList
        state = .question
        currentElementIndex = 0
    }

    func setupQuiz() {
        elementList = fixedElementList.shuffled()
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
    }
    
    
}

