//
//  ViewController.swift
//  NetworkMonitorTestUIKit
//
//  Created by Brandon Suarez on 11/17/23.
//

import UIKit

fileprivate enum Constants {
    static let wifiConnectedImage: String = "wifi"
    static let wifiNotConnectedImage: String = "wifi.slash"
    static let connectedMessage: String = "You are Connected"
    static let notConnectedMessage: String = "You are not Connected"
}

class ViewController: UIViewController {
    // UI Elements
    let containerStack = UIStackView()
    
    let image: UIImageView = UIImageView()
    let mainLabel = UILabel()
    let secondaryLabel = UILabel()
    
    var monitor = NetworkMonitor.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        let connectionType = NetworkMonitor.shared.connectionType
        
        if monitor.isConnected {
            DispatchQueue.main.async { [unowned self] in
                self.mainLabel.text = Constants.connectedMessage
                self.secondaryLabel.text = "\(connectionType) Connection"
                self.image.image = .init(systemName: Constants.wifiConnectedImage)
                print("You are Connected")
            }

        } else {
            DispatchQueue.main.async { [unowned self] in
                mainLabel.text = Constants.notConnectedMessage
                secondaryLabel.text = "No \(connectionType) Connection"
                image.image = .init(systemName: Constants.wifiNotConnectedImage)
                print("You are not connected")
            }
        }
    }
}


extension ViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(containerStack)
        
        setupContainerStack()
        setupImage()
        setupMainLabel()
        setupSecondaryLabel()
    }
    
    func setupImage() {
        image.image = .init(systemName: Constants.wifiConnectedImage)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupMainLabel() {
        mainLabel.numberOfLines = 1
        mainLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        mainLabel.textColor = .black
        mainLabel.textAlignment = .center
        mainLabel.text = ""
        
    }
    
    func setupSecondaryLabel() {
        secondaryLabel.font = UIFont.preferredFont(forTextStyle: .body)
        secondaryLabel.textColor = .gray
        secondaryLabel.numberOfLines = 1
        secondaryLabel.textAlignment = .center
        secondaryLabel.text = ""
        
    }
    
    func setupContainerStack() {
        containerStack.axis = .vertical
        containerStack.alignment = .center
        containerStack.spacing = 10
        
        containerStack.addArrangedSubview(image)
        containerStack.addArrangedSubview(mainLabel)
        containerStack.addArrangedSubview(secondaryLabel)
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerStack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            containerStack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
        ])
    }
}
