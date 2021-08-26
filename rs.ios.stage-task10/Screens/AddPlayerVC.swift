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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add player"
        view.backgroundColor = .RSBackground
        configureBarButtons()
        layoutUI()
        playerNameTextField.becomeFirstResponder()
    }
    
    private func configureBarButtons() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popCurrentViewController))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = backButton
        
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addPlayer))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func popCurrentViewController(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func addPlayer() {
        delegate.addPlayer(named: playerNameTextField.text!)
        popCurrentViewController(true)
    }
    
    @objc private func updateAddButtonState() {
        self.navigationItem.rightBarButtonItem?.isEnabled = (playerNameTextField.text?.count ?? 0 > 0)
    }
    
    private func layoutUI() {
        view.addSubview(playerNameTextField)
        NSLayoutConstraint.activate([
            playerNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playerNameTextField.heightAnchor.constraint(equalToConstant: 60),
            playerNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25)
        ])
    }
    
    

}
