//
//  ViewController.swift
//  Project4
//
//  Created by An Var on 14.02.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var website: String?
    var websites: [String] = []

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //говорим заголовку, чтобы он не был большим
        navigationItem.largeTitleDisplayMode = .never
        
        // константа с типом url, хранящая путь
        let url = URL(string: "https://" + website!)!
        // создает новый URLRequest из url и отдает в загрузку
        webView.load(URLRequest(url: url))
        // позволяет свайпать вперед или назад как в сафари
        webView.allowsBackForwardNavigationGestures = true
        
        // добавление кнопки в заголовок navigationController с названием Open
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
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
    
    @objc func openTapped() {
        // добавляет заголовок в алерт без сообщения
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        // добавляем список ссылок, который будет в алерте
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        // добавление кнопки Cancel
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    // добавляет к ссылке, указанной в алерте https:// после чего преобразовывает в URLRequest и загружает
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    // добавляет название вэб-страницы в заголовок navigationController
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.url?.host
    }
    
    //В этом проекте все, о чем мы заботимся - установлен ли параметр keyPath в estimatedProgress - то есть, если изменилось значение estimatedProgress веб-вида. И если это так, то мы ставим прогрессирующее свойство нашего прогресса в новый estimatedProgress значение.
    //синий ползунок двигается в зависимости от загрузки страницы
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
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
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
