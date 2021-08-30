//
//  RSButton.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 29.08.21.
//

import UIKit

class RSButton: UIButton {
    
    var imageName: String?
    
    convenience init(imageName: String) {
        self.init(frame: .zero)
        self.imageName = imageName
        setImage(UIImage(named: imageName), for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        adjustsImageWhenHighlighted = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
