//
//  MinibarScrollView.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 30.08.21.
//

import UIKit

class MinibarScrollView: UIScrollView {
    
    let itemsStack = UIStackView()

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: API
    func resetNavScrollView(with playerNames: [String]) {
        for view in itemsStack.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for name in playerNames {
            let label = SingleLetterLabel(with: name)
            self.itemsStack.addArrangedSubview(label)
            label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }
        updateAppearance(for: playerNames, focusedOn: 0)
    }
    
    func updateAppearance(for playerNames: [String], focusedOn position: Int) {
        for index in 0..<playerNames.count {
            let label = self.itemsStack.arrangedSubviews[index] as! SingleLetterLabel
            label.textColor = (index == position) ? .RSSelectedWhite : .RSTable
        }
        focus(at: position)
    }
    
    func focus(at position: Int) {
        let scrollViewCenter = (bounds.width - 15) / 2
        setContentOffset(CGPoint(x: position * 25 - Int(scrollViewCenter) + 7, y: 0), animated: true)
    }
    
    
    //MARK: Configurations
    private func configure() {
        addSubview(itemsStack)
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        configureItemsStack()
    }
    
    private func configureItemsStack() {
        itemsStack.translatesAutoresizingMaskIntoConstraints = false
        itemsStack.axis         = .horizontal
        itemsStack.spacing      = 5
        itemsStack.alignment    = .center
        itemsStack.distribution = .equalCentering
        itemsStack.pinToEdges(of: self)
    }
}
