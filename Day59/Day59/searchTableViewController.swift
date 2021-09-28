//
//  searchTableViewController.swift
//  Day59
//
//  Created by An Var on 19.09.2021.
//

import UIKit

class searchTableViewController: UITableViewController {

    var searchOfCountries = [Countries]()
    private var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchOfCountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
            }
            return cell
        }()
        
        let country = searchOfCountries[indexPath.row]
        cell.imageView?.image = country.flag.image()
        cell.textLabel?.text = country.name.common
        cell.detailTextLabel?.text = "Capital: \(country.capital.first ?? "")"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // создание нового ViewController'а
        let vc = DetailViewController()
        //detailItemvc.detailItem = searchOfCountries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}
