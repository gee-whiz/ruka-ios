//
//  VOXToast.swift
//  Gee
//
//  Created by George Kapoya on 2017/07/28.
//  Copyright © 2017 George Kapoya. All rights reserved.
//

import UIKit

public enum VOXToastType {
    case success
    case error
    case warning
    case info
}

public enum VOXToastPosition {
    case top
    case bottom
}

public enum VOXToastAnimation {
    case slide
    case fade
}

public enum VOXToastOption {
    case animation(VOXToastAnimation)
    case animationDuration(TimeInterval)
    case autoHide(Bool)
    case autoHideDelay(Double) // Second
    case height(Double)
    case hideOnTap(Bool)
    case position(VOXToastPosition)
    case textColor(UIColor)
    case textPadding(Double)
    case textAlignment(NSTextAlignment)
    case textNumberOfLines(Int)
}

extension UIViewController {
    
    public func showMessage(_ text: String, type: VOXToastType, options: [VOXToastOption]? = nil) {
        VOXToast.showMessageAddedTo(text, type: type, options: options, inView: view, inViewController: self)
    }
    
    public func hideMessage(animated: Bool = true) {
        view.hideMessage(animated: animated)
    }
    
}

extension UIView {
    
    public func showMessage(_ text: String, type: VOXToastType, options: [VOXToastOption]? = nil) {
        VOXToast.showMessageAddedTo(text, type: type, options: options, inView: self, inViewController: nil)
    }
    
    public func hideMessage(animated: Bool = true) {
        installedMessage?.hide(animated: animated)
    }
    
}

public class VOXToast: NSObject {
    
    public static var font : UIFont = UIFont.systemFont(ofSize: 14)
    public static var successBackgroundColor : UIColor = UIColor(red: 103/255, green: 179/255, blue: 143/255,   alpha: 0.95)
    public static var warningBackgroundColor : UIColor = UIColor(red: 230.0/255, green: 189.0/255, blue: 1.0/255,   alpha: 0.95)
    public static var errorBackgroundColor   : UIColor =  UIColor.red
    public static var infoBackgroundColor    : UIColor = UIColor(red: 44.0/255,  green: 187.0/255, blue: 255.0/255, alpha: 0.90)
    public class func showMessageAddedTo(_ text: String, type: VOXToastType, options: [VOXToastOption]?, inView: UIView, inViewController: UIViewController?) {
        if inView.installedMessage != nil && inView.uninstallMessage == nil { inView.hideMessage() }
        if inView.installedMessage == nil {
            VOXToast(text: text, type: type, options: options, inView: inView, inViewController: inViewController).show()
        }
    }
    
    public func show() {
        
        if inView?.installedMessage != nil { return }
        
        inView?.installedMessage = self
        inView?.addSubview(containerView)
        
        updateFrames()
        
        if animation == .fade {
            messageView.alpha = 0
            UIView.animate(withDuration: animationDuration, animations: { self.messageView.alpha = 1 })
        }
            
        else if animation == .slide && position == .top {
            messageView.transform = CGAffineTransform(translationX: 0, y: -messageHeight)
            UIView.animate(withDuration: animationDuration, animations: { self.messageView.transform = CGAffineTransform(translationX: 0, y: 0) })
        }
            
        else if animation == .slide && position == .bottom {
            messageView.transform = CGAffineTransform(translationX: 0, y: height)
            UIView.animate(withDuration: animationDuration, animations: { self.messageView.transform = CGAffineTransform(translationX: 0, y: 0) })
        }
        
        if autoHide { GS_GCDAfter(autoHideDelay) { self.hide(animated: true) } }
        
    }
    
    public func hide(animated: Bool) {
        
        if inView?.installedMessage !== self || inView?.uninstallMessage != nil { return }
        
        inView?.uninstallMessage = self
        inView?.installedMessage = nil
        
        guard animated else {
            removeFromSuperview()
            return
        }
        
        if animation == .fade {
            UIView.animate(withDuration: self.animationDuration,
                           animations: { [weak self] in if let this = self { this.messageView.alpha = 0 } },
                           completion: { [weak self] finished in self?.removeFromSuperview() }
            )
        }
            
        else if animation == .slide && position == .top {
            UIView.animate(withDuration: self.animationDuration,
                           animations: { [weak self] in if let this = self { this.messageView.transform = CGAffineTransform(translationX: 0, y: -this.messageHeight) } },
                           completion: { [weak self] finished in self?.removeFromSuperview() }
            )
        }
            
        else if animation == .slide && position == .bottom {
            UIView.animate(withDuration: self.animationDuration,
                           animations: { [weak self] in if let this = self { this.messageView.transform = CGAffineTransform(translationX: 0, y: this.height) } },
                           completion: { [weak self] finished in self?.removeFromSuperview() }
            )
        }
        
    }
    
    public fileprivate(set) weak var inView: UIView!
    public fileprivate(set) weak var inViewController: UIViewController?
    
    public fileprivate(set) var containerView = UIView()
    public fileprivate(set) var messageView = UIView()
    public fileprivate(set) var messageText = UILabel()
    
    public fileprivate(set) var animation: VOXToastAnimation = .slide
    public fileprivate(set) var animationDuration: TimeInterval = 0.3
    public fileprivate(set) var autoHide: Bool = true
    public fileprivate(set) var autoHideDelay: Double = 5
    public fileprivate(set) var backgroundColor: UIColor!
    public fileprivate(set) var height: CGFloat = 44
    public fileprivate(set) var hideOnTap: Bool = true
    public fileprivate(set) var offsetY: CGFloat = 0
    public fileprivate(set) var position: VOXToastPosition = .top
    public fileprivate(set) var textColor: UIColor = UIColor.white
    public fileprivate(set) var textPadding: CGFloat = 30
    public fileprivate(set) var textAlignment: NSTextAlignment = .center
    public fileprivate(set) var textNumberOfLines: Int = 1
    public fileprivate(set) var y: CGFloat = 0
    
    fileprivate var observingTableViewController: UITableViewController?
    
    public var messageHeight: CGFloat { return offsetY + height }
    
    public init(text: String, type: VOXToastType, options: [VOXToastOption]?, inView: UIView, inViewController: UIViewController?) {
        
        switch type {
        case .success:  backgroundColor = VOXToast.successBackgroundColor
        case .warning:  backgroundColor = VOXToast.warningBackgroundColor
        case .error:    backgroundColor = VOXToast.errorBackgroundColor
        case .info:     backgroundColor = VOXToast.infoBackgroundColor
        }
        
        if let options = options {
            for option in options {
                switch (option) {
                case let .animation(value): animation = value
                case let .animationDuration(value): animationDuration = value
                case let .autoHide(value): autoHide = value
                case let .autoHideDelay(value): autoHideDelay = value
                case let .height(value): height = CGFloat(value)
                case let .hideOnTap(value): hideOnTap = value
                case let .position(value): position = value
                case let .textColor(value): textColor = value
                case let .textPadding(value): textPadding = CGFloat(value)
                case let .textAlignment(value): textAlignment = value
                case let .textNumberOfLines(value): textNumberOfLines = value
                }
            }
        }
        
        super.init()
        
        if let vc = inViewController as? UITableViewController {
            observingTableViewController = vc
            vc.tableView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: &observerContext)
        }
        
        messageView.backgroundColor = backgroundColor
        containerView.addSubview(messageView)
        
        messageText.text = text
        messageText.font = VOXToast.font
        messageText.textColor = textColor
        messageText.textAlignment = textAlignment
        messageText.numberOfLines = textNumberOfLines
        messageView.addSubview(messageText)
        
        if textNumberOfLines == 0 {
            height = max(text.boundingRect(with: CGSize(width: inView.frame.size.width - textPadding * 2, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: VOXToast.font], context: nil).height + (height - " ".boundingRect(with: CGSize(width: inView.frame.size.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: VOXToast.font], context: nil).height), height)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFrames), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        if position == .top {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
        
        if hideOnTap { messageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))) }
        
        self.inView = inView
        self.inViewController = inViewController
    }
    
    deinit {
        if let tvc = observingTableViewController {
            tvc.tableView.removeObserver(self, forKeyPath: "contentOffset")
            observingTableViewController = nil
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleTap(_ tapGesture: UITapGestureRecognizer) {
        hide(animated: true)
    }
    
    @objc fileprivate func updateFrames() {
        guard let inView = inView else { return }
        y       = 0
        offsetY = 0
        
        switch position {
        case .top:
            if let vc = inViewController {
                if vc.edgesForExtendedLayout == [] {
                    offsetY = 0
                } else {
                    let nav = vc.navigationController ?? (vc as? UINavigationController)
                    let isNavBarHidden = (nav?.isNavigationBarHidden ?? true)
                    let isNavBarTranslucent = (nav?.navigationBar.isTranslucent ?? false)
                    let navBarHeight = (nav?.navigationBar.frame.size.height ?? 44)
                    let isStatusBarHidden = UIApplication.shared.isStatusBarHidden
                    if !isNavBarHidden && isNavBarTranslucent && !isStatusBarHidden { offsetY += 20 }
                    if !isNavBarHidden && isNavBarTranslucent { offsetY += navBarHeight }
                    if (isNavBarHidden && !isStatusBarHidden) { offsetY += 20 }
                }
            }
            y = max(0 - inView.frame.origin.y, 0)
        case .bottom:
            y = inView.bounds.size.height - height
        }
        
        let contentOffsetY = observingTableViewController?.tableView.contentOffset.y ?? 0
        
        containerView.frame = CGRect(x: 0, y: y + contentOffsetY, width: inView.bounds.size.width, height: messageHeight)
        messageView.frame = containerView.bounds
        messageText.frame = CGRect(x: textPadding, y: offsetY, width: messageView.bounds.size.width - textPadding * 2, height: height)
    }
    
    fileprivate func removeFromSuperview() {
        containerView.removeFromSuperview()
        inView?.uninstallMessage = nil
    }
    
}

extension VOXToast {
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        guard let inView = self.inView else { return }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.messageView.frame.origin.y == 0 && inView.frame.origin.y < 0 {
                self.messageView.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.messageView.frame.origin.y != 0 {
                self.messageView.frame.origin.y -= keyboardSize.height
            }
        }
    }
}

extension VOXToast {
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &observerContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == "contentOffset" {
            guard let contentOffset = (change?[.newKey] as? NSValue)?.cgPointValue else { return }
            containerView.frame.origin.y = y + contentOffset.y
        }
    }
}

extension UIView {
    
    fileprivate var installedMessage: VOXToast? {
        get { return objc_getAssociatedObject(self, &installedMessageKey) as? VOXToast }
        set { objc_setAssociatedObject(self, &installedMessageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    fileprivate var uninstallMessage: VOXToast? {
        get { return objc_getAssociatedObject(self, &uninstallMessageKey) as? VOXToast }
        set { objc_setAssociatedObject(self, &uninstallMessageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
}

private var installedMessageKey = ""
private var uninstallMessageKey = ""
private var observerContext = ""

private func GS_GCDAfter(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}




