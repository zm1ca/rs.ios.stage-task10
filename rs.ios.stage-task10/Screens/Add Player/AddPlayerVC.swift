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
    
    let headerView = HeaderView(title: "Add Player",
                                leftBarButton: BarButton(title: "Back"),
                                rightBarButton: BarButton(title: "Add"))
    
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
            headerView.rightBarButton?.isEnabled = true
            headerView.rightBarButton?.alpha = 1
        } else {
            headerView.rightBarButton?.isEnabled = false
            headerView.rightBarButton?.alpha = 0.3
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
        headerView.rightBarButton?.addTarget(self, action: #selector(addPlayer), for: .touchUpInside)
        headerView.rightBarButton?.isEnabled = false
        headerView.rightBarButton?.alpha     = 0.3
        headerView.leftBarButton?.addTarget(self, action: #selector(popCurrentViewController), for: .touchUpInside)
    }
    
    @objc private func popCurrentViewController(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func addPlayer() {
        delegate.addPlayer(named: playerNameTextField.text!)
        popCurrentViewController(true)
    }

    
    //MARK: - Layout
    private func layoutUI() {
        headerView.placeByDefault(at: view)
        view.addSubviews(playerNameTextField)
        NSLayoutConstraint.activate([
            playerNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playerNameTextField.heightAnchor.constraint(equalToConstant: 60),
            playerNameTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 25)
        ])
    }
    
}
