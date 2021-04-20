import UIKit

//говорим заголовку, чтобы он БЫЛ большим
navigationController?.navigationBar.prefersLargeTitles = true

//добавление кнопки справа
navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(credits))
//добавление кнопки слева
navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startGame))


//добавляем кол-во строк
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count // сколько картинок, столько и строк
}

//создание cell
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    //indexPath.row - содержит номер строки, которая загружается
    cell.textLabel?.text = pictures[indexPath.row]
    return cell
}


// Uiactivityviewcontroller - является методом iOS для обмена контентом с другими приложениями и сервисами.
let vc = UIActivityViewController(activityItems: [image, selectedImage?.description as Any], applicationActivities: [])
// говорим iOS, где контроллер просмотра активности должен быть прикреплен - откуда он должен появиться.
vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
present(vc, animated: true)


//добавление алерта
let ac = UIAlertController(title: "Source of data", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
present(ac, animated: true)
