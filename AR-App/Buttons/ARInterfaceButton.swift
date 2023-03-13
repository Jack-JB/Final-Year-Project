//
//  ARInterfaceButton.swift
//  AR-App
//
//  Created by Jack Burrows on 09/03/2023.
//
import UIKit

class ARInterfaceButton: UIButton {
    var icon: String?
    var titleText: String?
    
    convenience init(icon: String?, title: String?) {
        self.init()
        self.icon = icon
        self.titleText = title
        configureButton()
    }
    
    private func configureButton() {
        if let icon = icon {
            setImage(UIImage(systemName: icon), for: .normal)
            imageView?.contentMode = .scaleAspectFit
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10) // Adjust icon position
        }
        if let titleText = titleText {
            setTitle(titleText, for: .normal)
            setTitleColor(.white, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // Adjust text position
        }
        backgroundColor = .blue
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
}
