//
//  Capital.swift
//  Project16
//
//  Created by An Var on 23.09.2021.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    //Первые две являются строками, а третий - новым типом данных под названием CLLocationCoordinate2D, который представляет собой структуру, содержащую широту и долготу, в которых должна быть размещена аннотация.
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    //базовый инициализатор, который просто копирует предоставленные данные.
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
