//
//  searchTableViewController.swift
//  Project7
//
//  Created by An Var on 04.03.2021.
//

import UIKit

class searchTableViewController: UITableViewController {

    var searchOfPetitions = [Petition]()
    private var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchOfPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
            }
            return cell
        }()
        
        let petition = searchOfPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // создание нового ViewController'а
        let vc = DetailViewController()
        vc.detailItem = searchOfPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}
