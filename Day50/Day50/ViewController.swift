//
//  ViewController.swift
//  Day50
//
//  Created by An Var on 15.08.2021.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photoList = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //задаем заголовок для данного экрана
        title = "Photo"
        //говорим заголовку, чтобы он БЫЛ большим
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPhoto))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "customControlColor")
        
        let defaults = UserDefaults.standard
        if let savedPhoto = defaults.object(forKey: "photo") as? Data {
            if let decodedPhoto = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPhoto) as? [Photo] {
                photoList = decodedPhoto
            }
        }
    }
    
    @objc func newPhoto() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: addNewPhotoFromCamera))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: addNewPhotoFromGallery))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addNewPhotoFromGallery (action: UIAlertAction) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func addNewPhotoFromCamera (action: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let picker = UIImagePickerController()
            //Свойство sourceType направляет контроллер представления на камеру, а не на сохраненную пользователем библиотеку изображений.
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //извлекаем изображение
        guard let image = info[.editedImage] as? UIImage else { return }

        //создаем UUID-объект и используем его свойство uuidString для извлечения уникального идентификатора в виде строкового типа данных
        let imageName = UUID().uuidString
        //принимает URL результат getDocumentsDirectory() и вызывает новый метод на нем: appendingPathComponent(). Это используется при работе с файловыми путями, и добавляет одну строку (в нашем случае imageName) в путь, включая любой разделитель путей, используемый на платформе
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        //форматируем изображение в необходимый формат
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let photo = Photo(name: "Unknown", image: imageName)
        photoList.append(photo)
        tableView.reloadData()
        
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        //параметр FileManager.default.urls запрашивает директорию документов
        //второй параметр добавляет, что мы хотим, чтобы путь был относительно домашнего каталога пользователя
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath)
        let photo = photoList[indexPath.item]

        cell.textLabel?.text = photo.name

        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let photo = photoList[indexPath.item]
            vc.selectedImage = photo
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //изменение размера ячейки
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            self.editData(at: indexPath)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [edit])
        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
                self.photoList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
    
    func editData(at indexPath: IndexPath) {
       let photo = photoList[indexPath.item]

       let ac = UIAlertController(title: "Rename photo", message: nil, preferredStyle: .alert)
       ac.addTextField()

       ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
           guard let newName = ac?.textFields?[0].text else { return }
           photo.name = newName

           self?.tableView.reloadData()
       })

       ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
       present(ac, animated: true, completion: nil)
    }
    
    func save() {
        //Строка 1 преобразует наш массив в объект данных, а строки 2 и 3 сохраняют этот объект данных в UserDefault
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: photoList, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
}


