//
//  BottomSheetView.swift
//  BottomSheetView
//
//  Created by Isaías Santana on 23/09/19.
//  Copyright © 2019 Isaías Santana. All rights reserved.
//

import UIKit

final class BottomSheetView: NSObject {
    private var isOpen = false
    private var isUseKeyWindow = false
    private var heightBottomSheet: HeightBottomSheetOptions
    private var contentViewConstraintHeight: NSLayoutConstraint?
    private var contentViewConstraintWidth: NSLayoutConstraint?

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        return view
    }()

    private lazy var containerContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()

    private var contentView: UIView
    
    init(contentView: UIView, heightBottomSheet: HeightBottomSheetOptions = .withPercentage(0.5)) {
        self.contentView = contentView
        self.heightBottomSheet = heightBottomSheet
    }
    
    private func getWindow(useKeyWindow: Bool) -> UIWindow? {
        return useKeyWindow ? UIApplication.shared.keyWindow : UIApplication.shared.windows.last
    }
    
    private func addSubviewsTo(window: UIWindow) {
        window.addSubview(backgroundView)
        window.addSubview(containerContentView)
    }
    
    private func getPercentageHeightTo(window: UIWindow) -> CGFloat {
        var percentage: CGFloat = 0.0
        
        switch heightBottomSheet {
        case let .fixedHeight(height):
            percentage = height / window.frame.height
        case let .withPercentage(selectedPercentage):
            percentage = selectedPercentage
        }
        
        return percentage > 0 && percentage <= 1 ? percentage : 0.5
    }
    
    private func getHeightBottomSheet(withPercentage percentage: CGFloat, to window: UIWindow) -> CGFloat {
        return window.frame.height * percentage
    }
    
    private func getPositionYContentViewTo(heightBottomSheet height: CGFloat, window: UIWindow) -> CGFloat {
        return window.frame.height - height
    }

    private func center(contentView: UIView, with size: CGSize) {
        contentView.centerInSuperview()
        if let constraintHeight = contentViewConstraintHeight, let constraintWidth = contentViewConstraintWidth {
            constraintHeight.constant = size.height
            constraintWidth.constant = size.width
            contentView.updateConstraintsIfNeeded()
        } else {
            contentViewConstraintWidth = contentView.widthAnchor.constraint(equalToConstant: size.width)
            contentViewConstraintHeight = contentView.heightAnchor.constraint(equalToConstant: size.height)
            
            contentViewConstraintWidth?.isActive = true
            contentViewConstraintHeight?.isActive = true
            
            contentView.updateConstraintsIfNeeded()
        }
    }
    
    @objc func show(useKeyWindow: Bool = false) {
        guard !isOpen else {
            return
        }

        isUseKeyWindow = useKeyWindow
        guard let window = getWindow(useKeyWindow: useKeyWindow) else {
            return
        }

        addSubviewsTo(window: window)
        containerContentView.addSubview(contentView)
        
        let height = getHeightBottomSheet(withPercentage: getPercentageHeightTo(window: window), to: window)
        containerContentView.frame = CGRect(x: 0,
                                            y: window.frame.height,
                                            width: window.frame.width,
                                            height: height)
        
        backgroundView.frame = window.frame
        backgroundView.alpha = 0
        center(contentView: contentView, with: CGSize(width: window.frame.width, height: window.frame.height))
        containerContentView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.backgroundView.alpha = 1
                        self.containerContentView.frame = CGRect(x: 0,
                                                        y: self.getPositionYContentViewTo(heightBottomSheet: height, window: window),
                                                        width: self.containerContentView.frame.width,
                                                        height: self.containerContentView.frame.height)
            } , completion: nil)
        
        isOpen = true
    }
    
    @objc func close() {
        guard isOpen else {
            return
        }
        
        guard let window = getWindow(useKeyWindow: isUseKeyWindow) else {
            return
        }
        
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.backgroundView.alpha = 0
                        self.containerContentView.frame = CGRect(x: 0,
                                                                 y: window.frame.height,
                                                                 width: self.containerContentView.frame.width,
                                                                 height: self.containerContentView.frame.height)
        }, completion: { _ in
            self.backgroundView.removeFromSuperview()
            self.contentView.removeFromSuperview()
            self.containerContentView.removeFromSuperview()
        })
        
        isOpen = false
    }
}
