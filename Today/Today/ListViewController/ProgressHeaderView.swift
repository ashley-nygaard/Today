//
//  ProgressHeaderView.swift
//  Today
//
//  Created by Ashley Nygaard on 4/26/23.
//

import UIKit

// will not delete views just keeps them in resuse
class ProgressHeaderView: UICollectionReusableView {
    //defines type of view that can be presented
    static var elementKind: String { UICollectionView.elementKindSectionHeader}
    
    // observer
    var progress: CGFloat = 0 {
        didSet {
           // invalidates current layout and triggers update
            setNeedsLayout()
            heightContraint?.constant = progress * bounds.height
            // forces view to update layout immediately
            UIView.animate(withDuration:0.2) { [weak self ] in
                self?.layoutIfNeeded()
            }
     
        }
    }
    private let uppperView = UIView(frame: .zero)
    private let lowerView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private var heightContraint: NSLayoutConstraint?
    
    private var valueFormat: String {
        NSLocalizedString("%d percent", comment: "progress percentage value format")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
        isAccessibilityElement = true
        accessibilityLabel = NSLocalizedString("Progress", comment: "Progress view accessibility label")
        accessibilityTraits.update(with: .updatesFrequently)
    }
    
    // init coder fails compiler without it. we don't need it as we aren't loading from a storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessibilityValue = String(format: valueFormat, Int(progress * 100))
        heightContraint?.constant = progress * bounds.height
        containerView.layer.masksToBounds = true
        // reshapes the circle with each update
        containerView.layer.cornerRadius = 0.5 * containerView.bounds.width
    }
    
    private func prepareSubviews() {
        containerView.addSubview(uppperView)
        containerView.addSubview(lowerView)
        addSubview(containerView)
        
        uppperView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //assign true adds contrainst to the ancestor in the view heiracrhy that activates it
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        
        //center container view h/v in layout frame
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        
        uppperView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        uppperView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lowerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        uppperView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        uppperView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lowerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lowerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        // adjustable height constraint to reflect users's progress with completion
        heightContraint = lowerView.heightAnchor.constraint(equalToConstant: 0)
        heightContraint?.isActive = true
        
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        uppperView.backgroundColor = .todayProgressUpperBackground
        lowerView.backgroundColor = .todayProgressLowerBackground
    }
}
