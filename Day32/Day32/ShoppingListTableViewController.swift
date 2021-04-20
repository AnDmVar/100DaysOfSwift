//
//  ShoppingListTableViewController.swift
//  Day32
//
//  Created by An Var on 01.03.2021.
//

import UIKit

class ShoppingListTableViewController: UITableViewController {

    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTextField))
        navigationItem.rightBarButtonItems = [share, add]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(deleteAll))
    }
    
    @objc func addTextField(){
        let ac = UIAlertController(title: "Enter product", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] action in
            guard let ansintroducedProductwer = ac?.textFields?[0].text else { return }
            self?.submit(ansintroducedProductwer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    func submit(_ ansintroducedProductwer: String) {
        let product = ansintroducedProductwer.lowercased()
        
        if !product.isEmpty {
            if isOriginal(word: product) {
                shoppingList.insert(ansintroducedProductwer.lowercased(), at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                return
            } else {
                let ac = UIAlertController(title: "Product used already", message: "Be more original!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        
    }
    
    func isOriginal(word: String) -> Bool {
        return !shoppingList.contains(word)
    }

    @objc func shareTapped(){
        let list = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func deleteAll(){
        shoppingList.removeAll()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
}
