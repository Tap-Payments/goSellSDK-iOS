//
//  TapNavigationBar.swift
//  goSellSDK
//
//  Created by Dennis Pashkov on 5/15/18.
//

@IBDesignable internal class TapNavigationBar: UINavigationBar {
    
    // MARK: - Internal -
    // MARK: Properties
    
    @IBInspectable internal var customHeight: CGFloat = 100.0
    
    // MARK: Methods
    
    internal override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        if self.customHeight > 0.0 {
            
            let screen = self.window?.screen ?? .main
            let width = self.superview?.bounds.width ?? screen.bounds.width
            
            return CGSize(width: width, height: self.customHeight)
        }
        else {
            
            return super.sizeThatFits(size)
        }
    }
}
