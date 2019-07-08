//
//  BusyPanel.swift
//  DoorDashLab
//
//  Created by aarthur on 7/2/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit

@IBDesignable class BusyPanel: UIView, NibLoadable {
    @IBOutlet weak var busyLabel: PulsatingLabel!
    @IBOutlet weak var pinWheel: UIActivityIndicatorView!
    private var _hidden = false
    
    @IBInspectable var busyValue: String = "Loading..." {
        didSet {
            busyLabel.text = busyValue
        }
    }
    @IBInspectable var hidesWhenStopped: Bool = true {
        didSet {
            _hidden = hidesWhenStopped
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }

    func startAnimating() {
        pinWheel.startAnimating()
        busyLabel.beginAnimations()
    }
    
    func stopAnimating() {
        pinWheel.stopAnimating()
        busyLabel.endAnimations()
        isHidden = _hidden
    }
}

protocol NibLoadable {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        return String(describing: Self.self) // defaults to the name of the class implementing this protocol.
    }
    
    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }
    
    func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Error loading \(self) from nib")
        }
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        // border
        let layer = view.layer
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        layer.cornerRadius = 12.25
        layer.masksToBounds = true
    }
}

