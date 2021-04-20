//
//  ViewController.swift
//  Project2
//
//  Created by An Var on 07.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var numberOfQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        // добавляет кнопку справой стороны
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show score", style: .done, target: self, action: #selector(showScore))
            //UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        askQuestion(action: nil)
    }
    
    func askQuestion(action: UIAlertAction!) {
        countries.shuffle() // перемешает массив со странами
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = "\(countries[correctAnswer].uppercased())"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String

        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        } else {
            title = "Wrong! \n That’s the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        numberOfQuestions += 1
        
        if numberOfQuestions == 10 {
            let ac = UIAlertController(title: "GAME OVER", message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .destructive))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
        
    }
    
    @objc func showScore() {
        let ac = UIAlertController(title: "SCORE", message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(ac, animated: true)
    }
}

