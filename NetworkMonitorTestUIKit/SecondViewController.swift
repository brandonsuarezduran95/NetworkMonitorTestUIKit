//
//  SecondViewController.swift
//  NetworkMonitorTestUIKit
//
//  Created by Brandon Suarez on 11/17/23.
//

import UIKit
import Network

fileprivate enum Constants {
    static let wifiConnectedImage: String = "wifi"
    static let wifiNotConnectedImage: String = "wifi.slash"
    static let connectedMessage: String = "You are Connected"
    static let notConnectedMessage: String = "You are not Connected"
}

class SecondViewController: UIViewController {
    
    // UI Elements
    let containerStack = UIStackView()
    
    let image: UIImageView = UIImageView()
    let mainLabel = UILabel()
    let secondaryLabel = UILabel()
    
    public private(set) var connectionType: ConnectionType = .unknown

    override func viewDidLoad() {
        super.viewDidLoad()
        monitorNetwork()
        setupViews()

        // Do any additional setup after loading the view.
    }
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private func getConnectionType( _ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        }
        else {
            connectionType = .unknown
        }
    }
    
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        
        monitor.pathUpdateHandler = { [unowned self] path in
            
            self.getConnectionType(path)
            
            if path.status == .satisfied {
                DispatchQueue.main.async { [unowned self] in
                    self.mainLabel.text = Constants.connectedMessage
                    self.secondaryLabel.text = "\(connectionType) Connection"
                    self.image.image = .init(systemName: Constants.wifiConnectedImage)
                    view.backgroundColor = .systemGreen
                }
                print("Connected")
            } else {
                DispatchQueue.main.async { [unowned self] in
                    mainLabel.text = Constants.notConnectedMessage
                    secondaryLabel.text = "No \(connectionType) Connection"
                    image.image = .init(systemName: Constants.wifiNotConnectedImage)
                    view.backgroundColor = .systemRed
                }
                print("Not Connected")
            }
        }
        
        monitor.start(queue: queue)
    }

}

extension SecondViewController {
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
