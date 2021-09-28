//
//  DetaiViewController.swift
//  Day50
//
//  Created by An Var on 20.08.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //говорим заголовку, чтобы он не был большим
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            title = imageToLoad.name
            let path = getDocumentsDirectory().appendingPathComponent(imageToLoad.image)
            imageView?.image = UIImage(contentsOfFile: path.path)
        }
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        // Параметр CompressionQuality позволяет указать значение от 1,0 (максимальное качество) до 0,0 (минимальное качество)
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        // Uiactivityviewcontroller - является методом iOS для обмена контентом с другими приложениями и сервисами.
        let vc = UIActivityViewController(activityItems: [image, selectedImage?.name as Any], applicationActivities: [])
        // говорим iOS, где контроллер просмотра активности должен быть прикреплен - откуда он должен появиться.
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
