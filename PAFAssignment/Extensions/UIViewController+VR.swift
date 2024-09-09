//
//  UIViewController+VR.swift
//  PAFAssignment
//
//  Created by Rajan on 15/04/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Function to show a message on controller.
    func showMessage(message: String, duration: TimeInterval = 3.0, isError: Bool = false) {
        // Execute UI updates on the main thread
        DispatchQueue.main.async {
            // Create a message view
            let msgView = UIView()
            // Customize message view based on error status
            msgView.layer.cornerRadius = 10
            msgView.backgroundColor = isError ? UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.8) : UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.8)
            
            // Add message view to the view hierarchy
            self.view.addSubview(msgView)
            
            // Add constraints to position the message view at the top
            msgView.translatesAutoresizingMaskIntoConstraints = false
            let safeArea = self.view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                msgView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
                msgView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
                msgView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            ])
            
            // Create and customize the label
            let label = UILabel(frame: CGRect.zero)
            label.text = message
            label.textColor = isError ? .white : .black
            label.textAlignment = .center
            label.numberOfLines = 0
            label.sizeToFit()
            msgView.addSubview(label)
            
            // Add constraints to position the label inside the message view
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: msgView.topAnchor, constant: 10),
                label.bottomAnchor.constraint(equalTo: msgView.bottomAnchor, constant: -10),
                label.leadingAnchor.constraint(equalTo: msgView.leadingAnchor, constant: 10),
                label.trailingAnchor.constraint(equalTo: msgView.trailingAnchor, constant: -10)
            ])
            
            // Animate the appearance and disappearance of the message view
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                msgView.alpha = 1
            }) { _ in
                UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseInOut, animations: {
                    msgView.alpha = 0
                }, completion: { _ in
                    msgView.removeFromSuperview()
                })
            }
        }
    }
}
