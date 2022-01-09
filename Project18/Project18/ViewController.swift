//
//  ViewController.swift
//  Project18
//
//  Created by An Var on 01.10.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(1 == 1, "Maths failure! 1 ")
//        assert(1 == 2, "Maths failure! 2 ")
        
        for i in 1 ... 100 {
            print("Got number \(i)")
        }
    }


}

