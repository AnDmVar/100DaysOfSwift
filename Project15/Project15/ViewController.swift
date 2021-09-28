//
//  ViewController.swift
//  Project15
//
//  Created by An Var on 13.09.2021.
//

import UIKit

var imageView: UIImageView!
var currentAnimation = 0

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Создание изображеиня
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        //скрываем кнопку отправителя, чтобы наши анимации не конфликтовали; он становится невидимым при закрытии завершения анимации
        sender.isHidden = true

        //Мы вызываем animate (withDuration :) с продолжительностью 1 секунда, без задержки и без интересных опций. Для закрытия анимации нам не нужно использовать [weak self], потому что здесь нет риска сильных ссылочных циклов - замыкания, переданные в метод animate (withDuration :), будут использованы один раз, а затем будут выброшены.
        //делает анимацию более плавной
        //UIView.animate(withDuration: 1, delay: 0, options: [],
        //делает анимацию более "прыгающей"
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
           animations: {
            //Мы переключаемся, используя значение self.currentAnimation.
            switch currentAnimation {
            case 0:
                //используется инициализатор для CGAffineTransform, который принимает значения шкалы X и Y в качестве двух параметров. Значение 1 означает «размер по умолчанию», поэтому 2, 2 увеличивают ширину и высоту вида вдвое.
                imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
            case 1:
                //очищает наше представление о любом предопределенном преобразовании, сбрасывая любые изменения, которые были применены, путем изменения его свойства преобразования.
                imageView.transform = .identity
                
            case 2:
                //ринимает значения X и Y в качестве своих параметров. Эти значения являются дельтами или отличиями от текущего значения, что означает, что приведенный код вычитает 256 из текущей позиции X и Y.
                imageView.transform = CGAffineTransform(translationX: -256, y: -256)

            case 3:
                imageView.transform = .identity
                
            case 4:
                //можем использовать CGAffineTransform для поворота представлений, используя его инициализатор RotationAngle. Он принимает один параметр - величину в радианах, которую вы хотите повернуть.
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                
            case 5:
                imageView.transform = .identity
                
            case 6:
                //делает так, чтобы изображение почти исчезло, а затем снова исчезло, а также изменилось его цвет фона, мы собираемся изменить его прозрачность, установив его значение альфа, где 0 - невидимый, а 1 - полностью видимый, а также установим его свойство backgroundColor - сначала зеленым, затем очищаемым.
                imageView.alpha = 0.1
                imageView.backgroundColor = UIColor.green

            case 7:
                imageView.alpha = 1
                imageView.backgroundColor = UIColor.clear
                
            default:
                break
            }
        }) { finished in
            sender.isHidden = false
            //завершение закрытия показывает кнопку отправителя, чтобы ее можно было нажать еще раз.
        }

        currentAnimation += 1

        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    
}


