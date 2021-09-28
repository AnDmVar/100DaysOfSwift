//
//  DetailViewController.swift
//  Day59
//
//  Created by An Var on 19.09.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var detailItem: Countries?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //безопасно разворачиваем detailItem
        guard let detailItem = detailItem else { return }

        // создание String в формате html
        // detailItem.body добавляет информацию на страницу
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> .flag { font-size: 150%; text-align: center; }
                .name { font-size: 100%; font-weight: bold; text-align: center; }
                .translation { font-size: 100%; }
                .region { font-size: 100%; }
                .subregion { font-size: 100%; }
                .capital { font-size: 100%; }
                .languages { font-size: 100%; }
                .currencies { font-size: 100%; }
                .area { font-size: 100%; }
                .latlng { font-size: 100%; }
        </style>
        </head>
        <body>
        <p class="flag">\(detailItem.flag)
        <class="name">\(detailItem.name.common)</p>
        <p class="translation">Name translation: \(detailItem.translations["rus"]?.values.first ?? "")</p>
        <p class="region">Region: \(detailItem.region)</p>
        <p class="subregion">Subregion: \(detailItem.subregion)</p>
        <p class="capital">Capital city(ies): \(detailItem.capital.first ?? "")</p>
        <p class="languages">Languages: \(stringDictionary(detailItem.languages))</p>
        <p class="currencies">Currencies name: \(detailItem.currencies[detailItem.currencies.first?.key ?? ""]?["name"] ?? "")</p>
        <p class="currencies">Currencies symbol: \(detailItem.currencies[detailItem.currencies.first?.key ?? ""]?["symbol"] ?? "")</p>
        <p class="area"> Land area in km² \(detailItem.area)</p>
        <p class="latlng">Latitude and longitude: \(detailItem.latlng)</p>
        </body>
        </html>
        """

        // загрузка страницы с разбором html
        webView.loadHTMLString(html, baseURL: nil)
    }
}

func stringDictionary(_ dict: [String:String]) -> String {
    var str = dict.first?.value ?? ""
    for (_, value) in dict {
        if value != dict.first?.value {
            str += ", \(value)"
        }
    }
    return str
}
