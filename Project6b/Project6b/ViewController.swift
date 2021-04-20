//
//  ViewController.swift
//  Project6b
//
//  Created by An Var on 27.02.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let metrics = ["labelHeight": 88]
        
        let label1 = UILabel()
        //отключение Auto Layout по умолчанию
        label1.translatesAutoresizingMaskIntoConstraints = false
        //цвет фона
        label1.backgroundColor = UIColor.red
        //текст лейбла
        label1.text = "THESE"
        //размер равен содержимому
        label1.sizeToFit()

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()

        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()

        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()

        //добавление текста на экран
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
//        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
        //view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[label1]|", options: [], metrics: nil, views: viewsDictionary))
        //view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[label2]|", options: [], metrics: nil, views: viewsDictionary))
        //view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[label3]|", options: [], metrics: nil, views: viewsDictionary))
        //view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[label4]|", options: [], metrics: nil, views: viewsDictionary))
        //view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[label5]|", options: [], metrics: nil, views: viewsDictionary))
//        for label in viewsDictionary.keys {
            //view.addConstraints() добавляет ограничение
            //NSLayoutConstraint.constraints(withVisualFormat:) - это метод Auto Layout, который преобразует VFL в набор ограничений.
            //Н: означают, что мы определяем горизонтальную раскладку
            //Символ | означает "край родительского представления"
            //[label1], который является визуальным способом сказать "положить label1 здесь". Скобки [  ] - это края представления.
            //т.е каждый из наших текстов должен растянуться от края к краю
//            view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
        //V: означают, что мы определяем вертикальную раскладку
        //Символ - означает "пространство". По умолчанию это 10 очков, но его можно настроить.
        
        //view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1]-[label2]-[label3]-[label4]-[label5]", options: [], metrics: nil, views: viewsDictionary))
        
        // [label1(==88)] какая высота должна быть
        // -(>=10)-| какой отступ от нижней границы должен быть
        //view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(==88)]-[label2(==88)]-[label3(==88)]-[label4(==88)]-[label5(==88)]-(>=10)-|", options: [], metrics: nil, views: viewsDictionary))
        
        //labelHeight@999 - значение берется из метрики и имеет приоритет 999
        //[label3(label1)] высота label3 равна label1
//        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|", options: [], metrics: metrics, views: viewsDictionary))
        
        var previous: UILabel?
        
        for label in [label1, label2, label3, label4, label5] {
            // устанавливаем, что ширина равна ширине view
            //label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
            // устанавливаем, что высота равна 88
            //label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
            
            //В первый раз петля будет равна нулю, но затем мы установим его на текущий элемент в цикле, чтобы следующий ярлык мог ссылаться на него. Если предыдущее не нулевое, мы установим ограничение topAnchor.
            if let previous = previous {
                // верхний constraint label равен нижнему previous + 10
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                // это для первого лейбла: установить верхний constraint в начала safeArea
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }

                // set the previous label to be the current one, for the next loop iteration
                previous = label
        }
        
    }


}

