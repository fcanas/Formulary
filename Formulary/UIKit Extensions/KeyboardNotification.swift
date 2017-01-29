// Thanks to Kristopher Johnson
// https://gist.github.com/kristopherjohnson/13d5f18b0d56b0ea9242

import UIKit

/// Wrapper for the NSNotification userInfo values associated with a keyboard notification.
///
/// It provides properties retrieve userInfo dictionary values with these keys:
///
/// - UIKeyboardFrameBeginUserInfoKey
/// - UIKeyboardFrameEndUserInfoKey
/// - UIKeyboardAnimationDurationUserInfoKey
/// - UIKeyboardAnimationCurveUserInfoKey

struct KeyboardNotification {
    
    let notification: Notification
    let userInfo: NSDictionary
    
    /// Initializer
    ///
    /// - parameter notification: Keyboard-related notification
    init(_ notification: Notification) {
        self.notification = notification
        if let userInfo = notification.userInfo {
            self.userInfo = userInfo as NSDictionary
        }
        else {
            self.userInfo = NSDictionary()
        }
    }
    
    /// Start frame of the keyboard in screen coordinates
    var screenFrameBegin: CGRect {
        if let value = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            return value.cgRectValue
        }
        else {
            return CGRect.zero
        }
    }
    
    /// End frame of the keyboard in screen coordinates
    var screenFrameEnd: CGRect {
        if let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return value.cgRectValue
        }
        else {
            return CGRect.zero
        }
    }
    
    /// Keyboard animation duration
    var animationDuration: Double {
        if let number = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            return number.doubleValue
        }
        else {
            return 0.25
        }
    }
    
    /// Keyboard animation curve
    ///
    /// Note that the value returned by this method may not correspond to a
    /// UIViewAnimationCurve enum value.  For example, in iOS 7 and iOS 8,
    /// this returns the value 7.
    var animationCurve: Int {
        if let number = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            return number.intValue
        }
        return UIViewAnimationCurve.easeInOut.rawValue
    }
    
    /// Start frame of the keyboard in coordinates of specified view
    ///
    /// - parameter view: UIView to whose coordinate system the frame will be converted
    /// - returns: frame rectangle in view's coordinate system
    func frameBeginForView(_ view: UIView) -> CGRect {
        return view.convert(screenFrameBegin, from: view.window)
    }
    
    /// Start frame of the keyboard in coordinates of specified view
    ///
    /// - parameter view: UIView to whose coordinate system the frame will be converted
    /// - returns: frame rectangle in view's coordinate system
    func frameEndForView(_ view: UIView) -> CGRect {
        return view.convert(screenFrameEnd, from: view.window)
    }
}
