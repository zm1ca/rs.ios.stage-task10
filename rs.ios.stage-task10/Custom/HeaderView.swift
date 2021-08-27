//
//  HeaderView.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 27.08.21.
//

import UIKit

class HeaderView: UIView {
    
    var leftBarButton:  BarButton?
    var rightBarButton: BarButton?
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Nunito-ExtraBold", size: 36)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    //MARK: - Initialization
    convenience init(title: String, leftBarButton: BarButton?, rightBarButton: BarButton?) {
        self.init(frame: .zero)
        titleLabel.text     = title
        self.leftBarButton  = leftBarButton
        self.rightBarButton = rightBarButton
        layoutUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .RSBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - API
    func addSubviewAndConstraintByDefault(at superview: UIView) {
        superview.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            heightAnchor.constraint(equalToConstant: 105)
        ])
    }
    
    
    //MARK: - Layout
    private func layoutUI() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        if let leftBarButton = leftBarButton {
            addSubview(leftBarButton)
            NSLayoutConstraint.activate([
                leftBarButton.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -12),
                leftBarButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            ])
        }
        
        if let rightBarButton = rightBarButton {
            addSubview(rightBarButton)
            NSLayoutConstraint.activate([
                rightBarButton.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -12),
                rightBarButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
    }
}


