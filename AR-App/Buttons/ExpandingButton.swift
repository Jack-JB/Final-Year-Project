//
//  CircleButton.swift
//  AR-App
//
//  Created by Jack Burrows on 15/02/2023.
//

import Foundation
import UIKit

@IBDesignable
class ExpandingButton: UIButton {
    private var subButtons = [UIButton]()
    private var isExpanded = false
    private let stackView = UIStackView()

    init(frame: CGRect, titles: [String]) {
        super.init(frame: frame)
        setupViews(titles: titles)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews(titles: [])
    }

    private func setupViews(titles: [String]) {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        self.backgroundColor = .blue
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // Create sub-buttons
        for title in titles {
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.backgroundColor = .gray
            button.addTarget(self, action: #selector(subButtonTapped(sender:)), for: .touchUpInside)
            button.isHidden = true
            self.addSubview(button)
            subButtons.append(button)
        }

        // Add sub-buttons to stack view
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        for button in subButtons {
            stackView.addArrangedSubview(button)
        }
        self.addSubview(stackView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Position stack view
        stackView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat(subButtons.count * 40))
        stackView.center = CGPoint(x: self.frame.width / 2, y: -CGFloat(subButtons.count * 20))
    }

    @objc func buttonTapped() {
        isExpanded = !isExpanded

        // Show/hide sub-buttons
        for i in 0..<subButtons.count {
            subButtons[i].isHidden = !isExpanded
        }

        // Animate button rotation
        let angle = isExpanded ? CGFloat.pi / 4 : 0
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(rotationAngle: angle)
        })
    }

    @objc func subButtonTapped(sender: UIButton) {
        // Handle sub-button tap
    }
}
