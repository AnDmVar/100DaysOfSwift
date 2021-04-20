//
//  TableViewController.swift
//  Project4
//
//  Created by An Var on 21.02.2021.
//

import UIKit

class TableViewController: UITableViewController {

    var websites = ["apple.com", "hackingwithswift.com", "instagram.com", "youTube.com", "facebook.com", "twitter.com", "amazon.com", "pinterest.com", "google.com", "wikipedia.org"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //задаем заголовок для данного экрана
        title = "Web-sites"
        //говорим заголовку, чтобы он БЫЛ большим
        navigationController?.navigationBar.prefersLargeTitles = true

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count // сколько картинок, столько и строк
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Site", for: indexPath)
        //indexPath.row - содержит номер строки, которая загружается
        cell.textLabel?.text = websites[indexPath.row].lowercased()
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "browser") as? ViewController {
            // 2: success! Set its selectedImage property
            vc.website = websites[indexPath.row].lowercased()
            vc.websites = websites
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
