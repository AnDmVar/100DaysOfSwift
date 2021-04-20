//
//  DetailViewController.swift
//  Project1
//
//  Created by An Var on 05.02.2021.
//

import UIKit

class DetailViewController: UIViewController {

    //@IBOutlet - говорит о том, что существует связка с IB
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var numberPicture: Int?
    var totalPicture: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //говорим заголовку, чтобы он не был большим
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            //задаем заголовок для данного экрана
            title = "Picture \(String(describing: numberPicture!)) of \(String(describing: totalPicture!))"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
            
            imageView.image = UIImage(named: imageToLoad)
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
        let vc = UIActivityViewController(activityItems: [image, selectedImage?.description as Any], applicationActivities: [])
        // говорим iOS, где контроллер просмотра активности должен быть прикреплен - откуда он должен появиться.
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
}
