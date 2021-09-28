//
//  ViewController.swift
//  Project8
//
//  Created by An Var on 05.03.2021.
//

import UIKit

//UIButton.animate(withDuration: 1, delay: 0, options: [], animations: {
//    sender.alpha = 0
//}) { finished in
//    sender.isHidden = true
//}

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()

    var activatedButtons = [UIButton]()
    var solutions = [String]()

    //устанавливаем переменной наблюдателя (observer), чтобы при изменении значения выполнялся обозначенный код
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        // читаем заголовок с нажатой кнопки, или выходим, если его нет по какой-то причине
        guard let buttonTitle = sender.titleLabel?.text else { return }
        // добавляем название кнопки к текущему ответу игрока
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        // добавляем кнопку к списку активных
        activatedButtons.append(sender)
        //прячем кнопку, которая была нажата
        UIButton.animate(withDuration: 1, delay: 0, options: [], animations: {
            sender.alpha = 0
        })
    }

    @objc func submitTapped(_ sender: UIButton) {
        //получаем ответ, если по какой-то причине его нет - выходим
        guard let answerText = currentAnswer.text else { return }

        //получаем позицию ответа
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            //чистим массив активированных кнопок
            activatedButtons.removeAll()

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")

            currentAnswer.text = ""
            score += 1

            //если все отгадано, то вызываем алерт
            if solutions == splitAnswers! {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
            
        } else {
            let ac = UIAlertController(title: "Wrong!", message: "You entered the wrong word", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
            score -= 1
        }
    }
    
    func levelUp(action: UIAlertAction) {
        //увеличивает уровень
        level += 1
        //удаляет все решения
        solutions.removeAll(keepingCapacity: true)

        //загружает новый уровень
        loadLevel()

        //проверяет, что все кнопки доступны
        for btn in letterButtons {
            UIButton.animate(withDuration: 1, delay: 0, options: [], animations: {
                btn.alpha = 1
                //btn.isHidden = false
            })
        }
    }

    //этот метод удаляет текст из текущего поля ответа, отключает все активированные кнопки, затем удаляет все элементы из массива activatedButtons.
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""

        for btn in activatedButtons {
            UIButton.animate(withDuration: 1, delay: 0, options: [], animations: {
                btn.alpha = 1
                //btn.isHidden = false
            })
        }

        activatedButtons.removeAll()
    }
    
    override func loadView() {
        //располагается на весь экран
        view = UIView()
        view.backgroundColor = .white

        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        //выравнивание текста внутри лейбла
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        //размер шрифта
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        //сколько строк которые текст может вместить, 0 - столько строк, сколько потребуется.
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)

        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        //создание TextField'а
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        //расположение текста внутри TextField'а
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        //запрет на пользовательское взаимодействие
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)
        //указываем, что вызывать на текущем контроллере просмотра при действии touchUpInside с кнопкой
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        //активируем все констреинты сразу, они ставятся в массив, поэтому требуются запятые
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            submit.heightAnchor.constraint(equalToConstant: 44),

            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        // set some values for the width and height of each button
        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to our letterButtons array
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                //letterButton.layer.borderWidth = 1
            }
        }
    
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                //записываются строки в массив (HA|UNT|ED: Ghosts in residence является одной строкой)
                var lines = levelContents.components(separatedBy: "\n")
                //перетасовываем
                lines.shuffle()

                //элемент помещается в line переменную, а его положение - в переменную index.
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    //помещаем первую часть разделительной строки в answer, а вторую часть в clue
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"

                    //заменяем | на ""
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    //длина строки
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    //разделяем еще раз слово и добавляем каждую часть в массив letterBits
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

        letterBits.shuffle()

        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        print("solutionString \(String(describing: solutionString))")
    }

}

