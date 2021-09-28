//
//  ViewController.swift
//  Day41
//
//  Created by An Var on 29.03.2021.
//

import UIKit

class ViewController: UIViewController {

    var scoreLabel: UILabel!
    var lifeLabel: UILabel!
    var promptLabel: UILabel!
    var answerLabel: UILabel!
    var alphabetButtons = [UIButton]()
    
    var activatedButtons = [UIButton]() // нажатые кнопки
    var solutions = [String]() // решения
    var buttonsView = UIView()
    var levelAssignments = [String: String]() // задания из загруженного уровня
    var usedButtons = [String]()
    
    let lifeCount = 7 //число жизней
    var solutionString = "" //строка в которой хранится ответ
    var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    var level = 1
    var answer = ""
    
    //устанавливаем переменной наблюдателя (observer), чтобы при изменении значения выполнялся обозначенный код
    var life = 7 {
        didSet {
            lifeLabel.text = String(repeating: "♥️", count: life)
            if lifeLabel.text == "" {
                let ac = UIAlertController(title: "You lose! 😒", message: "Are you ready to try again?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: clearTapped))
                present(ac, animated: true)
            }
        }
    }
    
    //устанавливаем переменной наблюдателя (observer), чтобы при изменении значения выполнялся обозначенный код
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func loadView() {
        
        //располагается на весь экран
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        lifeLabel = UILabel()
        lifeLabel.translatesAutoresizingMaskIntoConstraints = false
        lifeLabel.textAlignment = .left
        lifeLabel.text = String(repeating: "♥️", count: lifeCount)
        view.addSubview(lifeLabel)
        
        promptLabel = UILabel()
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.font = UIFont.systemFont(ofSize: 24)
        promptLabel.text = "PROMPT"
        promptLabel.textAlignment = .center
        promptLabel.numberOfLines = 0
        view.addSubview(promptLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.text = "ANSWERS"
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .center
        view.addSubview(answerLabel)
        
        promptLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        view.addSubview(buttonsView)
        
        //активируем все констреинты сразу, они ставятся в массив, поэтому требуются запятые
        NSLayoutConstraint.activate([
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 15),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            lifeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 15),
            lifeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            promptLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            promptLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 30),
            promptLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -30),
            
            answerLabel.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 20),
            answerLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 30),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -30),
            
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonsView.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // загрузка уровня: разбор файла и запись значений в словарь
        loadLevel()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        let width = buttonsView.frame.size.width / 7
        let height = buttonsView.frame.size.height / 4

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<7 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("", for: .normal)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: CGFloat(col) * width, y: CGFloat(row) * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to our alphabetButtons array
                alphabetButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }

        alphabet.shuffle()
        alphabet.append("")
        alphabet.append("")

        if alphabet.count == alphabetButtons.count {
            for i in 0 ..< alphabetButtons.count {
                alphabetButtons[i].setTitle(alphabet[i].uppercased(), for: .normal)
            }
        }
    }
    
    //этот метод удаляет текст из текущего поля ответа, отключает все активированные кнопки, затем удаляет все элементы из массива activatedButtons.
    func clearTapped(action: UIAlertAction) {
        life = 7
        answer = ""
        answerLabel.text?.removeAll()
        usedButtons.removeAll()
        answerLabel.text = String(repeating: " _ ", count: solutionString.count)

        for btn in activatedButtons {
            btn.isHidden = false
        }

        activatedButtons.removeAll()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        // читаем заголовок с нажатой кнопки, или выходим, если его нет по какой-то причине
        guard let buttonTitle = sender.titleLabel?.text else { return }
        answer = ""
        
        if solutionString.contains(buttonTitle) {
            usedButtons.append(buttonTitle)
            answerLabel.text?.removeAll()
            
            for letter in solutionString {
                let strLetter = String(letter)

                if usedButtons.contains(strLetter) {
                    answer += strLetter
                } else {
                    answer += " _ "
                }
            }
            answerLabel.text?.removeAll()
            answerLabel.text = answer
        } else {
            life -= 1
        }
        
        // добавляем кнопку к списку активных
        activatedButtons.append(sender)
        //прячем кнопку, которая была нажата
        sender.isHidden = true
        
        if answer == solutionString{
            let ac = UIAlertController(title: "Well done! 👍", message: "Are you ready for the next task?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: loadNextTask))
            present(ac, animated: true)
        }
    }
    
    func loadNextTask(action: UIAlertAction){
        life = 7
        score += 1
        
        for btn in activatedButtons {
            btn.isHidden = false
        }
        activatedButtons.removeAll()
        usedButtons.removeAll()
        
        if levelAssignments.isEmpty {
            let ac = UIAlertController(title: "Well done! 👍", message: "Are you ready for the next level?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
            present(ac, animated: true)
        } else {
            loadAssignment()
        }
    }
    
    func loadLevel(){
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                //записываются строки в массив (HAUNTED: Ghosts in residence является одной строкой)
                var lines = levelContents.components(separatedBy: "\n")
                //перетасовываем
                lines.shuffle()

                //элемент помещается в line переменную, а его положение - в переменную index.
                for line in lines {
                    let parts = line.components(separatedBy: ": ")
                    levelAssignments[parts[0]] = parts[1]
                }
            }
        }
        print(levelAssignments)
        loadAssignment()
    }
    
    func loadAssignment(){
        var clueString = "" //строка в которой хранится подсказка
        
        if let task = levelAssignments.randomElement() {
            clueString = task.value
            solutionString = task.key
            levelAssignments.removeValue(forKey: solutionString)
        }
                    
        promptLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answerLabel.text = String(repeating: " _ ", count: solutionString.count)
        
        print(solutionString)
    }
    
    func levelUp(action: UIAlertAction) {
        //увеличивает уровень
        level += 1
        //удаляет все решения
        solutions.removeAll(keepingCapacity: true)

        //загружает новый уровень
        loadLevel()

        //проверяет, что все кнопки доступны
        for btn in alphabetButtons {
            btn.isHidden = false
        }
    }

}

