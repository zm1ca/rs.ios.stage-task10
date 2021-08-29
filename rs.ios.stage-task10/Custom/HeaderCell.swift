//
//  HeaderCell.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 29.08.21.
//

import UIKit

class HeaderCell: UITableViewCell {

    private var titleLabel: UILabel = {
        let lbl  = UILabel()
        lbl.font = UIFont(name: "Nunito-SemiBold", size: 16)
        lbl.textColor = .RSLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    static let reuseID = "HeaderCell"
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
        backgroundColor = .RSTable
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configuration
    func set(title: String) {
        titleLabel.text = title
    }

}
