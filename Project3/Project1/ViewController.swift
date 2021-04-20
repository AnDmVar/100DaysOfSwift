//
//  ViewController.swift
//  Project1
//
//  Created by An Var on 04.02.2021.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //задаем заголовок для данного экрана
        title = "Storm Viewer"
        //говорим заголовку, чтобы он БЫЛ большим
        navigationController?.navigationBar.prefersLargeTitles = true
        //добавляем кнопку справа
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let fm = FileManager.default //позволяет работать с файловой системой (например для поиска файлов)
        let path = Bundle.main.resourcePath! // путь до объектов
        let items = try! fm.contentsOfDirectory(atPath: path) //массив строк, содержащий имена файлов.

        for item in items { //перебор эл-тов
            if item.hasPrefix("nssl") { //если элемент имеет префикс "nssl", то...
                pictures.append(item)
            }
            
        }
        pictures.sort()
    }
    
    //override - метод уже определен ранее, но мы хотим создать новое поведение
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count // сколько картинок, столько и строк
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        //indexPath.row - содержит номер строки, которая загружается
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.numberPicture = indexPath.row + 1
            vc.totalPicture = pictures.count
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["Hi friend! This is awesome app! Please recommend the app to other people."], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
