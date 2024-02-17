//
//  ViewController.swift
//  Chat
//
//  Created by Yusuf Bayindir on 2/7/24.
//

import UIKit
import UserNotifications
class WelcomeViewController: UIViewController {
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var registerButtonLabel: UIButton!
    @IBOutlet weak var logInButtonLabel: UIButton!
    
    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        appIcon.layer.cornerRadius = 150.0
        mainView.backgroundColor = UIColor(hex: Constants.ColorsPattern.blueColor)
        appTitle.textColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        
        registerButtonLabel.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        registerButtonLabel.backgroundColor = UIColor(hex: Constants.ColorsPattern.whiteColor)
        registerButtonLabel.layer.cornerRadius = 15.0
        
        logInButtonLabel.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        logInButtonLabel.backgroundColor = UIColor(hex: Constants.ColorsPattern.whiteColor)
        logInButtonLabel.layer.cornerRadius = 15.0
        
        // Bildirim yetkisi isteme
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Kullanıcı bildirimlere izin verdi.")
            }
        }
        
        appTitle.alpha = 0
        appIcon.alpha = 0
        UIView.animate(withDuration: 2.0) {
            self.appIcon.alpha = 1
            self.appTitle.alpha = 1
        }
        
    }

}
import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        let hexColor: String

        // Check the prefix and remove it if necessary
        if hex.hasPrefix("#") {
            hexColor = String(hex.dropFirst())
        } else {
            hexColor = hex
        }
        
        // Ensure the hex color string length is valid
        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
                g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
                b = CGFloat(hexNumber & 0x0000FF) / 255.0
                a = 1.0 // Opaque color
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        
        return nil
    }
}


