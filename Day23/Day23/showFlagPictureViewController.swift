//
//  showFlagPictureViewController.swift
//  Day23
//
//  Created by An Var on 13.02.2021.
//

import UIKit

class showFlagPictureViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var nameImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            
            imageView.image = UIImage(named: imageToLoad)
            
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            
            title = nameImage
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
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
        let vc = UIActivityViewController(activityItems: [image, nameImage as Any], applicationActivities: [])
        // говорим iOS, где контроллер просмотра активности должен быть прикреплен - откуда он должен появиться.
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
