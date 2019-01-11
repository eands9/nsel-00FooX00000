//
//  ViewController.swift
//  NS-Elem-1
//
//  Created by Eric Hernandez on 12/2/18.
//  Copyright © 2018 Eric Hernandez. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerTxt: UITextField!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var questionNumberLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    var randomPick: Int = 0
    var correctAnswers: Int = 0
    var numberAttempts: Int = 0
    var timer = Timer()
    var counter = 0.0
    var questionTxt : String = ""
    var answerCorrect = 0.00
    var answerUser = 0.00
    var isShow: Bool = false
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five"]
    let retryArray = ["Try again","Oooops"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        askQuestion()
        
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        self.answerTxt.becomeFirstResponder()
    }

    @IBAction func checkAnswerByUser(_ sender: Any) {
        checkAnswer()
    }
    
    func askQuestion(){
        let randomNumA = Double.random(in: 1...9)
        let randomNumB = Int.random(in: 2...15)
        let randomNumC = Int.random(in: 100...999)
        let switchIndex = Int.random(in: 6...10)
        var numA = 0.00
        var numB = 0
        
        switch switchIndex{
        case 6:
            let numMultiplier = Int.random(in: 1...5)
            numA = ((1/6) * Double(numMultiplier)) * 100
            numB = ((randomNumB * 6) * 1000) + randomNumC
        case 7:
            let numMultiplier = Int.random(in: 1...6)
            numA = ((1/7) * Double(numMultiplier)) * 100
            numB = ((randomNumB * 7) * 1000) + randomNumC
        case 8:
            let numMultiplier = Int.random(in: 1...7)
            numA = ((1/8) * Double(numMultiplier)) * 100
            numB = ((randomNumB * 8) * 1000) + randomNumC
        case 9:
            let numMultiplier = Int.random(in: 1...8)
            numA = ((1/9) * Double(numMultiplier)) * 100
            numB = ((randomNumB * 9) * 1000) + randomNumC
        case 11:
            let numMultiplier = Int.random(in: 1...10)
            numA = ((1/11) * Double(numMultiplier)) * 100
            numB = ((randomNumB * 11) * 1000) + randomNumC
        default:
            numB = 999
        }
        
        typealias Rational = (num : Int, den : Int)
        func simplifyFrac(x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
            var x = x0
            var a = floor(x)
            var (h1, k1, h, k) = (1, 0, Int(a), 1)
            
            while x - a > eps * Double(k) * Double(k) {
                x = 1.0/(x - a)
                a = floor(x)
                (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
            }
            return (h, k)
        }
        
        let d = numA
        let (wholePart, fractionalPart) = modf(d)
        let numFWhole = (Int(wholePart))
        
        let answerCorrectSimplify = simplifyFrac(x0: fractionalPart)
        let numF = answerCorrectSimplify.num
        let denF = answerCorrectSimplify.den
    
        let randomIndex = Int.random(in: 0...1)
        switch randomIndex{
        case 0: //00Foo of 00000000
            questionLabel.text = "* \(numFWhole) \(numF)/\(denF)% of \(numB)"
            answerCorrect = round(((numA * Double(numB))/100)*100)/100
        case 1:
            let numA2 = round(((numA * 1000) + randomNumA)*1)/1
            questionLabel.text = "* \(numA2) X \(randomNumC)"
            answerCorrect = numA2 * Double(randomNumC)
        default:
            questionLabel.text = "999"
        }
    }
    
    @IBAction func showBtn(_ sender: Any) {
        answerTxt.text = String(answerCorrect)
        isShow = true
    }
    
    func checkAnswer(){
        answerUser = (answerTxt.text! as NSString).doubleValue
        
        if answerUser >= (answerCorrect * 0.95) && answerUser <= (answerCorrect * 1.05) && isShow == false {
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
            randomPositiveFeedback()
            askQuestion()
            answerTxt.text = ""
        }
        else if isShow == true {
            readMe(myText: "Next Question")
            askQuestion()
            isShow = false
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
        }
        else{
            randomTryAgain()
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
        }
    }
    
    @objc func updateTimer(){
        counter += 0.1
        timerLbl.text = String(format:"%.1f",counter)
    }
    
    func readMe( myText: String) {
        let utterance = AVSpeechUtterance(string: myText )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func randomPositiveFeedback(){
        randomPick = Int(arc4random_uniform(9))
        readMe(myText: congratulateArray[randomPick])
    }
    
    func updateProgress(){
        progressLbl.text = "\(correctAnswers) / \(numberAttempts)"
    }
    
    func randomTryAgain(){
        randomPick = Int(arc4random_uniform(2))
        readMe(myText: retryArray[randomPick])
    }
}

