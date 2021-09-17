//
//  ViewController.swift
//  mvgarbuzovPW1
//
//  Created by Matvey Garbuzov on 10.09.2021.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        print(hexColor, hexColor.count)
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = 1
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
    
        return nil
    }
}

func randomCharacter() -> String? {
    let numbers = [0,1,2,3,4,5,6, 7, 8, 9]
    let letters = ["A","B","C","D","E","F"]
    
    let numberOrLetter = arc4random_uniform(2)
    
    switch numberOrLetter {
    	case 0: return String(numbers[Int(arc4random_uniform(10))])
        case 1: return letters[Int(arc4random_uniform(6))]
        default: return nil
    }
}

func characterArrayToHexString(array: [String]) -> String {
    var hexString = ""
    for character in array {
        hexString += character
    }
    return hexString
}

func randomHex() -> String {
    var characterArray: [String] = []
    for _ in 0...8 {
        characterArray.append(randomCharacter()!)
      }
    return characterArrayToHexString(array: characterArray)
}

func generateRandomPalette(amount: Int) -> [String] {
    var colors: [String] = []
    for _ in 0...amount - 1 {
        colors.append(randomHex())
    }
    return colors
}

class ViewController: UIViewController {

    @IBOutlet var views: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeColorButtonPressed(_ sender: Any) {
        let button = sender as? UIButton
        button?.isEnabled = false
        var set = Set<UIColor>()
        while set.count < views.count {
            let randomHexColor = generateRandomPalette(amount: views.count)[0]
            set.insert(UIColor(hex: randomHexColor)!)
        }
        print("============")
        /*
         added this let (const) below due to an error I got when adding a random animation duration for each cube. There was an overlap (one animation went 0.5, and the other 1 second), as I understood, the button was activated again as soon as the first element of the "views" array completed the animation. I had to make a random animation duration for each element
         
         Used this line of code
         "UIView.animate(withDuration: .random(0.5...1), ..."
         */
        let duration = Double.random(in: 0.5...1)
        for view in views {
            UIView.animate(withDuration: duration, animations: {
                view.backgroundColor = set.popFirst()
                view.layer.cornerRadius = .random(in: 5...40)
            }) { complition in
                button?.isEnabled = true
            }
        }
    }
    
}

