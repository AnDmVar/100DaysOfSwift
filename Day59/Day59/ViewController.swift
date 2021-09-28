//
//  ViewController.swift
//  Day59
//
//  Created by An Var on 19.09.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Countries]()
    var searchOfCountries = [Countries]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        
        let urlString: String
        //urlString указывает на сервер Whitehouse.gov, либо на кэшированную копию тех же данных, получая доступ к доступным петициям
        urlString = "https://raw.githubusercontent.com/mledoze/countries/master/countries.json"
        //используем if let чтобы безопасно проверить существование url
        if let url = URL(string: urlString) {
            //создаем новый объект data, который возвращает содержимое с url, может выпасть в ошибку если например подключение к интернету было прервано, поэтому используем try?
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        //создаем экземпляр JSONDecoder, который предназначен для преобразования между объектами JSON и Codable.
        let decoder = JSONDecoder()

        //затем вызываем decoder чтобы преобразовать JSON данные в объект Petitions
        if let jsonCounries = try? decoder.decode([Countries].self, from: json) {
            //если JSON успешно преобразован, то присваиваем массив results свойству countries
            countries = jsonCounries
            //перезагружаем таблицу
            tableView.reloadData()
        }
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
        searchOfCountries.removeAll()
        for country in countries {
            if country.name.common.contains(answer){
                searchOfCountries.append(country)
            }
        }
        
        let vc = searchTableViewController()
        vc.searchOfCountries = searchOfCountries
        vc.title = answer
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let country = countries[indexPath.row]
        
        cell.imageView?.image = country.flag.image()
        cell.textLabel?.text = country.name.common
        cell.detailTextLabel?.text = "Capital: \(country.capital.first ?? "")"
        //print(country.currencies)
        //print(country.currencies.first?.key)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // создание нового ViewController'а
        let vc = DetailViewController()
        vc.detailItem = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension String
{
    func image(fontSize:CGFloat = 40, bgColor:UIColor = UIColor.clear, imageSize:CGSize? = nil) -> UIImage?
    {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        let imageSize = imageSize ?? self.size(withAttributes: attributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        bgColor.set()
        let rect = CGRect(origin: .zero, size: imageSize)
        UIRectFill(rect)
        self.draw(in: rect, withAttributes: [.font: font])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
