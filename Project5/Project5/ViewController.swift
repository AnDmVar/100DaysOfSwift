//
//  ViewController.swift
//  Project5
//
//  Created by An Var on 24.02.2021.
//

import UIKit

class ViewController: UITableViewController {

    //все слова
    var allWords = [String]()
    //использованные слова
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startGame))
        
        //находим путь к файлу, содержащему start и записываем в переменную
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // try? - если этот код выдаст ошибку, то необходимо вернуть nil
            // записывает все из файла в константу
            if let startWords = try? String(contentsOf: startWordsURL) {
                //перебирает строку и если находит \n, разделяет по словам
                allWords = startWords.components(separatedBy: "\n")
            }
        }

        //если ничего не записалось
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    @objc func startGame() {
        //пишем в заголовок  рандомное слово из массива
        title = allWords.randomElement()
        //чистим массив использованных слов
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        //добавляет редактируемое поле ввода текста на контроллер
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            //безопасно разворачивает массив текстовых полей
            guard let answer = ac?.textFields?[0].text else { return }
            //выводит текст из текстового поля и передает его методу submit().
            self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer.lowercased(), at: 0)

                    //вставляем слово, прошедшее все проверки на первое место
                    let indexPath = IndexPath(row: 0, section: 0)
                    //добавляем его в представление таблицы (с анимацией)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    //Не узнаваемое слово
                    showErrorMessage(error: "Word not recognised")
                }
            } else {
                //слово уже использовано
                showErrorMessage(error: "Word used already")
            }
        } else {
            showErrorMessage(error: "Word not possible")
        }
    }
    
    func isPossible(word: String) -> Bool {
        //приводим все к нижнему регистру и смотрим, если первая буква есть в начальном слове, то удаляем данную букву и идем дальше, если хоть одна буква не будет найдена, то выходим из циклов
        guard var tempWord = title?.lowercased() else {
            return false
        }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    func isOriginal(word: String) -> Bool {
        //проверяем? содержит ли массив использованных слов, введенное
        return !usedWords.contains(word)
    }
    func isReal(word: String) -> Bool {
        
        if word.count > 2 && word != title{
            print(word.count)
            // UITextChecker - предназначен для обнаружения орфографических ошибок, что делает его идеальным для того, чтобы знать, является ли данное слово реальным или нет.
            let checker = UITextChecker()
            //NSRange используется для хранения строкового диапазона, который содержит начальную позицию и длину.
            //Когда работаем с UIKit, SpriteKit, или любым другим фреймворком Apple, используйте utf16.count для подсчета символов.
            let range = NSRange(location: 0, length: word.utf16.count)
            //Требуется пять параметров, но нас интересуют только первые два и последний: первый параметр - наша строка, слово, второй - наш диапазон сканирования (вся строка), а последний - язык, на котором мы должны проверять, где en выбирает английский. Параметры З и 4 здесь не полезны, но для полноты: параметр З выбирает точку в диапазоне, где текстовый контролер должен начать сканирование, и параметр 4 позволяет нам установить, должен ли UITextChecker запускаться в начале диапазона, если не найдено неправильных слов, начиная с параметра 3. Аккуратно, но не помогает здесь.
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            
            return misspelledRange.location == NSNotFound
        } else {
            showErrorMessage(error: "Rules")
            print("error")
            return false
        }
    }
    
    func showErrorMessage(error: String) {
        let errorTitle: String
        let errorMessage: String
        
        switch error {
        case "Word not recognised":
            errorTitle = "Word not recognised"
            errorMessage = "You can't just make them up, you know!"
        case "Word used already":
            errorTitle = "Word used already"
            errorMessage = "Be more original!"
        case "Word not possible":
            guard let title = title?.lowercased() else {
                return
            }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
        default:
            errorTitle = "It is prohibited"
            errorMessage = "Disallow answers that are shorter than three letters or are just start word"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

}

