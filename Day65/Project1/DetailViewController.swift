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
        
        assert(selectedImage != "")
        
        if let imageToLoad = selectedImage {
            //задаем заголовок для данного экрана
            title = "Picture \(String(describing: numberPicture!)) of \(String(describing: totalPicture!))"
            
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

}
