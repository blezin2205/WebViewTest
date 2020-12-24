//
//  ViewController.swift
//  WebViewTest
//
//  Created by Blezin on 23.12.2020.
//  Copyright © 2020 Blezin'sDev. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    
    let pathA = "https://demo0040494.mockable.io/api/v1/trending"
    let pathB = "https://demo0040494.mockable.io/api/v1/object/"
    let continueButtonText = "Далее"
    let networkService = NetworkService()
    var arrayA = [AResponse]()
    var id = String()
    var arrayIndex = 0
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    lazy var continueButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle(continueButtonText, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 4
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.227329582, green: 0.2323184013, blue: 0.2370472848, alpha: 1)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.color = .darkGray
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupConstraints()
        setContinueButton(enabled: false)
        activityIndicator.startAnimating()
        networkService.getListA(pathA: pathA) { (result) in
            switch result {
                
            case .success(let arrayA):
                self.arrayA = arrayA
                self.id = "\(arrayA[self.arrayIndex].id)"
                self.navigationItem.title = arrayA[self.arrayIndex].title
                self.loadDataBContents(pathB: self.pathB + self.id)
                
            case .failure(let error):
                print("Error recieved requesting data listA: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func handleContinue() {
        activityIndicator.startAnimating()
        setContinueButton(enabled: false)
        
        if arrayIndex != arrayA.count - 1 {
            arrayIndex += 1
            id = "\(arrayA[arrayIndex].id)"
            navigationItem.title = arrayA[arrayIndex].title
            loadDataBContents(pathB: pathB + id)
        } else {
            arrayIndex = 0
            id = "\(arrayA[arrayIndex].id)"
            navigationItem.title = arrayA[arrayIndex].title
            loadDataBContents(pathB: pathB + id)
        }
    }
    
    
    
    private func setContinueButton(enabled: Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
            continueButton.setTitle(continueButtonText, for: .normal)
        } else {
            continueButton.alpha = 0.8
            continueButton.isEnabled = false
            continueButton.setTitle("", for: .normal)
        }
    }
    
    private func loadDataBContents(pathB: String) {
        networkService.getListB(pathB: pathB) { [weak self] (result) in
            switch result {
                
            case .success(let dataB):
                self?.label.text = dataB.contents ?? "No Contents"
                self?.setContinueButton(enabled: true)
                self?.activityIndicator.stopAnimating()
                if let urlString = dataB.url, let url = URL(string: urlString)  {
                    self?.setupWebView()
                    let myRequest = URLRequest(url: url)
                    self?.webView.load(myRequest)
                } else {
                    self?.webView.removeFromSuperview()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Setup constraints

extension ViewController {
    
    private func setupWebView() {
        self.view.addSubview(webView)
        self.view.bringSubviewToFront(continueButton)
        
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func setupConstraints() {
        view.addSubview(label)
        view.addSubview(continueButton)
        continueButton.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
        NSLayoutConstraint.activate([
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            continueButton.widthAnchor.constraint(equalToConstant: 180)
        ])
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor),
            
        ])
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        setContinueButton(enabled: true)
    }
}



