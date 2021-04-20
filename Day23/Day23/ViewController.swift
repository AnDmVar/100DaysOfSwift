//
//  ViewController.swift
//  Day23
//
//  Created by An Var on 13.02.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var flags = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "World flags"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasSuffix("3x.png") {
                flags.append(item)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count // сколько картинок, столько и строк
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flags", for: indexPath)
        //indexPath.row - содержит номер строки, которая загружается
        cell.textLabel?.text = String(flags[indexPath.row].uppercased().prefix(upTo: flags[indexPath.row].firstIndex(of: "@")!))
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? showFlagPictureViewController {
            vc.selectedImage = flags[indexPath.row]
            vc.nameImage = String(flags[indexPath.row].uppercased().prefix(upTo: flags[indexPath.row].firstIndex(of: "@")!))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

