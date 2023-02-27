import UIKit

class ExpandableButton: UIButton {

    var isExpanded: Bool = false
    
    var firstButton = UIButton()
    var secondButton = UIButton()
    var thirdButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        configureButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        configureButtons()
    }

    private func configureButtons() {
        // Set up the first button
        firstButton.setTitle("Red", for: .normal)
        firstButton.backgroundColor = .red
        firstButton.isHidden = true
        addSubview(firstButton)

        // Set up the second button
        secondButton.setTitle("Blue", for: .normal)
        secondButton.backgroundColor = .blue
        secondButton.isHidden = true
        addSubview(secondButton)

        // Set up the third button
        thirdButton.setTitle("Green", for: .normal)
        thirdButton.backgroundColor = .green
        thirdButton.isHidden = true
        addSubview(thirdButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the frames of the buttons
        let buttonSize = CGSize(width: 100, height: 50)
        let buttonX = frame.width - buttonSize.width - (-100) // adjust the value of 20 as needed
        firstButton.frame = CGRect(origin: CGPoint(x: buttonX, y: frame.height - buttonSize.height * 3), size: buttonSize)
        secondButton.frame = CGRect(origin: CGPoint(x: buttonX, y: frame.height - buttonSize.height * 2), size: buttonSize)
        thirdButton.frame = CGRect(origin: CGPoint(x: buttonX, y: frame.height - buttonSize.height), size: buttonSize)
    }

    @objc private func didTapButton() {
        // Toggle the isExpanded property
        isExpanded.toggle()
        
        // Show or hide the buttons based on isExpanded
        UIView.animate(withDuration: 0.3) {
            self.firstButton.isHidden = !self.isExpanded
            self.secondButton.isHidden = !self.isExpanded
            self.thirdButton.isHidden = !self.isExpanded
        }
    }
}

