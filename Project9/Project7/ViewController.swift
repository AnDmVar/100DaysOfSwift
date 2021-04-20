//
//  ViewController.swift
//  Project7
//
//  Created by An Var on 02.03.2021.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var searchOfPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //добавление кнопки справа
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(credits))
        //добавление кнопки слева
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        
        let urlString: String
        //urlString указывает на сервер Whitehouse.gov, либо на кэшированную копию тех же данных, получая доступ к доступным петициям
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        //используем if let чтобы безопасно проверить существование url
        DispatchQueue.global(qos: .userInitiated).async {
            //[weak self] in
            if let url = URL(string: urlString) {
                //создаем новый объект data, который возвращает содержимое с url, может выпасть в ошибку если например подключение к интернету было прервано, поэтому используем try?
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
            
            self.showError()
        }
        
    }
    
    @objc func credits(){
        let ac = UIAlertController(title: "Source of data", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func search(){
        let ac = UIAlertController(title: "Enter word", message: nil, preferredStyle: .alert)
        //добавляет редактируемое поле ввода текста на контроллер
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] action in
            //безопасно разворачивает массив текстовых полей
            guard let answer = ac?.textFields?[0].text else { return }
            //выводит текст из текстового поля и передает его методу submit().
            self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String){
        searchOfPetitions.removeAll()
        for petition in petitions {
            if petition.title.contains(answer) || petition.body.contains(answer) {
                searchOfPetitions.append(petition)
            }
        }
        
        let vc = searchTableViewController()
        vc.searchOfPetitions = searchOfPetitions
        vc.title = answer
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func parse(json: Data) {
        //создаем экземпляр JSONDecoder, который предназначен для преобразования между объектами JSON и Codable.
        let decoder = JSONDecoder()

        // затем вызываем decoder чтобы преобразовать JSON данные в объект Petitions
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            //если JSON успешно преобразован, то присваиваем массив results свойству petitions
            petitions = jsonPetitions.results
            //перезагружаем таблицу
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // создание нового ViewController'а
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

