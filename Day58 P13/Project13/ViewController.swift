//
//  ViewController.swift
//  Project13
//
//  Created by An Var on 25.08.2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //Второй - это фильтр Core Image, в котором будет храниться любой активированный пользователем фильтр. Этому фильтру будут предоставлены различные параметры ввода, прежде чем мы попросим его вывести результат для отображения в представлении изображения.
    var context: CIContext!
    var currentFilter: CIFilter!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    @IBOutlet weak var radius: UISlider!
    @IBOutlet weak var center: UISlider!
    @IBOutlet weak var scale: UISlider!
    var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        //создает пример фильтра, который применяет к изображениям эффект тона сепии
        currentFilter = CIFilter(name: "CISepiaTone")
        
        
    }
    
    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        //guard let image = imageView.image else { return }
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Add photo", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
            return
        }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        applyProcessing()
    }
    
    func setFilter(action: UIAlertAction) {
        
        title = action.title
        // make sure we have a valid image before continuing!
        guard currentImage != nil else { return }

        // safely read the alert action's title
        guard let actionTitle = action.title else { return }

        currentFilter = CIFilter(name: actionTitle)

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
     
    func applyProcessing() {
        
        //Первая строка безопасно считывает выходное изображение из нашего текущего фильтра
        guard let image = currentFilter.outputImage else { return }
        let inputKeys = currentFilter.inputKeys

        //использует значение нашего ползунка интенсивности для установки значения kCIInputIntensityKey нашего текущего фильтра Core Image. Для тонирования сепией значение 0 означает «нет эффекта», а 1 означает «полностью сепия».
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radius.value * 500, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / CGFloat(center.value * 5 + 0.1), y: currentImage.size.height / CGFloat(center.value * 5 + 0.1)), forKey: kCIInputCenterKey) }

        //создает новый тип данных с именем CGImage из выходного изображения текущего фильтра. Нам нужно указать, какую часть изображения мы хотим визуализировать, но использование image.extent означает «все это». Пока не будет вызван этот метод, фактическая обработка не выполняется, поэтому реальную работу выполняет именно он. Это возвращает необязательный CGImage, поэтому нам нужно if let.
        if let cgimg = context.createCGImage(image, from: image.extent) {
            //создается новый UIImage из CGImage
            let processedImage = UIImage(cgImage: cgimg)
            //этот UIImage назначается нашему представлению изображения
            self.imageView.image = processedImage
            UIImageView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.imageView.alpha = 1
            })
        }
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        UIImageView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.imageView.alpha = 0
        })
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        currentImage = image
        
        //создаем CIImage из UIImage
        let beginImage = CIImage(image: currentImage)
        //отправляем результат в текущий Core Image Filter, используя kCIInputImageKey
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
    
}

