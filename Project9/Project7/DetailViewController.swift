//
//  DetailViewController.swift
//  Project7
//
//  Created by An Var on 03.03.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?

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
        <style> .word { font-size: 200%; font-weight: bold; text-align: center; }
                .body { font-size: 120%; text-align: justify; }
                .signatureCount { font-size: 100%; text-align: right; }
        </style>
        </head>
        <body>
        <p class="word">\(detailItem.title)</p>
        <p class="body">\(detailItem.body)</p>
        <p class="signatureCount"> Signature count: \(detailItem.signatureCount)</p>
        </body>
        </html>
        """

        // загрузка страницы с разбором html
        webView.loadHTMLString(html, baseURL: nil)
    }
}
