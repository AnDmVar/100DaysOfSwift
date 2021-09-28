//
//  WebViewController.swift
//  Project16
//
//  Created by An Var on 28.09.2021.
//

import WebKit
import UIKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var progressView: UIProgressView!
    var webView: WKWebView!
    var url: URL = URL(string: "https://wikipedia.org")!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //говорим заголовку, чтобы он не был большим
        navigationItem.largeTitleDisplayMode = .never
        
        // создает новый URLRequest из url и отдает в загрузку
        webView.load(URLRequest(url: url))
        // позволяет свайпать вперед или назад как в сафари
        webView.allowsBackForwardNavigationGestures = true
        
        //создает новый экземпляр класса UIProgressView со свойством default
        progressView = UIProgressView(progressViewStyle: .default)
        //установка размера
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        //добавление пустой кнопки
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //добавление кнопки обновления
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        //добавление кнопки Back
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        //добавление кнопки Forward
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))

        //добавление тулбара
        toolbarItems = [back, spacer, progressButton, spacer, forward, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        //четыре параметра: кто наблюдатель, что хотим наблюдать, какое значение мы хотим (нам нужно значение, которое только что установлено, поэтому мы хотим новое) и значение контекста (получаемое сообщение, когда значение будет изменено)
        //#keyPath - работает как ключевое слово #selector: позволяет компилятору проверить, что код правильный - класс Wkwebview на самом деле имеет свойство estimatedProgress
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //константа, равная url навигации
        let url = navigationAction.request.url
        
        //если есть домен сайта для этого URL, вытаскивает его в константу
        if let host = url?.host {
            if host.contains("wikipedia.org") {
                decisionHandler(.allow)
                return
            }
        }

        decisionHandler(.cancel)
        showAlert()
        
    }
    
    @objc func showAlert() {
        let ac = UIAlertController(title: "WARNING", message: "This site blocked.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(ac, animated: true)
    }
}
