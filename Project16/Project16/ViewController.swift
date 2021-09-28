//
//  ViewController.swift
//  Project16
//
//  Created by An Var on 23.09.2021.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose , target: self, action: #selector(choiceOfMapType))
        
        //CLLocationCoordinate2D - представляет собой структуру, содержащую широту и долготу, в которых должна быть размещена аннотация.
        //Эти объекты Capital соответствуют протоколу MKAnnotation, что означает, что мы можем отправить его в представление карты для отображения с помощью метода addAnnotation ().
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        let moscow = Capital(title: "Moscow", coordinate: CLLocationCoordinate2D(latitude: 55.755773, longitude: 37.617761), info: "")
        let petersburg = Capital(title: "Saint_Petersburg", coordinate: CLLocationCoordinate2D(latitude: 59.938806, longitude: 30.314278), info: "")
        let abuDhabi = Capital(title: "Abu_Dhabi", coordinate: CLLocationCoordinate2D(latitude: 24.4667, longitude: 54.3667), info: "")
        
//        mapView.addAnnotation(london)
//        mapView.addAnnotation(oslo)
//        mapView.addAnnotation(paris)
//        mapView.addAnnotation(rome)
//        mapView.addAnnotation(washington)
        
        //or
        
        mapView.addAnnotations([london, oslo, paris, rome, washington, moscow, petersburg, abuDhabi])
    }
    
    //При вызове этого метода вам сообщат, какой вид карты его отправил (у нас есть только один, так что это достаточно просто), из какого вида аннотации была получена кнопка (это полезно), а также кнопка, которая была нажата.
    //Представление аннотации содержит свойство, называемое аннотацией, которое будет содержать наш объект Capital. Итак, мы можем вытащить это, присвоить ему тип Capital, а затем показать его название и информацию любым удобным способом
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        guard annotation is Capital else { return nil }

        // 2
        let identifier = "Capital"

        // 3
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            //4
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.pinTintColor = .blue
            annotationView?.canShowCallout = true

            // 5
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // 6
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
//        let placeInfo = capital.info

//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "browser") as? WebViewController {
            
            vc.url = URL(string: "https://wikipedia.org/wiki/" + placeName!)!
            vc.title = placeName!
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func choiceOfMapType(){
        let vc = UIAlertController(title: "Please choise map type", message: nil, preferredStyle: .actionSheet)
        vc.addAction(UIAlertAction(title: "Standard", style: .default, handler: { action in
            self.mapView.mapType = .standard
        }))
        vc.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { action in
            self.mapView.mapType = .hybrid
        }))
        vc.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default, handler: { action in
            self.mapView.mapType = .hybridFlyover
        }))
        vc.addAction(UIAlertAction(title: "Muted standard", style: .default, handler: { action in
            self.mapView.mapType = .mutedStandard
        }))
        vc.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { action in
            self.mapView.mapType = .satellite
        }))
        vc.addAction(UIAlertAction(title: "Satellite Flyover", style: .default, handler: { action in
            self.mapView.mapType = .satelliteFlyover
        }))
        present(vc, animated: true)
    }
}


