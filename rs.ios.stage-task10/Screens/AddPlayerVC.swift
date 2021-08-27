//
//  AddPlayerVC.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

protocol PlayerAddable {
    func addPlayer(named name: String)
}

class AddPlayerVC: UIViewController {
    
    var delegate: PlayerAddable!
    
    let headerView = HeaderView(title: "Add Player")
    let backButton = BarButton(title: "Back")
    let addButton  = BarButton(title: "Add")
    
    let playerNameTextField: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.RSDarkLabel,
            NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 20)!
        ]
        tf.attributedPlaceholder   = NSAttributedString(string: "Player Name", attributes: attributes)
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(24, 0, 0)
        tf.font                    = UIFont(name: "Nunito-ExtraBold", size: 20)
        tf.textColor               = .white
        tf.backgroundColor         = .RSTable
        tf.autocorrectionType      = .no
        tf.addTarget(self, action: #selector(updateAddButtonState), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    @objc private func updateAddButtonState() {
        if (playerNameTextField.text?.count ?? 0 > 0) {
            addButton.isEnabled = true
            addButton.alpha = 1
        } else {
            addButton.isEnabled = false
            addButton.alpha = 0.3
        }
    }
    

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add player"
        view.backgroundColor = .RSBackground
        configureBarButtons()
        layoutUI()
        playerNameTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Configurations for Bar Buttons
    private func configureBarButtons() {
        addButton.addTarget(self, action: #selector(addPlayer), for: .touchUpInside)
        addButton.isEnabled = false
        addButton.alpha     = 0.3
        backButton.addTarget(self, action: #selector(popCurrentViewController), for: .touchUpInside)
    }
    
    @objc private func popCurrentViewController(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func addPlayer() {
        delegate.addPlayer(named: playerNameTextField.text!)
        popCurrentViewController(true)
    }

    
    //MARK: - Configurations
    private func layoutUI() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(addButton)
        view.addSubview(playerNameTextField)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 90),
            
            backButton.bottomAnchor.constraint(equalTo: headerView.titleLabel.topAnchor, constant: -12),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            
            addButton.bottomAnchor.constraint(equalTo: headerView.titleLabel.topAnchor, constant: -12),
            addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            playerNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playerNameTextField.heightAnchor.constraint(equalToConstant: 60),
            playerNameTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 25)
        ])
    }
    
}
