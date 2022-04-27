//
//  LevelBumpViewController.swift
//  GM Tools
//
//  Created by Micheal Smith on 11/20/20.
//

import UIKit

class LevelBumpViewController: UIViewController {
    @IBOutlet weak var levelBumpTitleLbl: UILabel!
    @IBOutlet weak var levelBumpInfoLbl: UILabel!
    @IBOutlet weak var levelBumpBulletInfoLbl: UILabel!
    @IBOutlet weak var mentorshipInfoLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background Color
        SystemColor.setViewBG(view: self.view)
        

        let bulletArray: [String] = ["Increase every DC the PC has by 1.", "Increase the attack modifiers, attack damage, spell damage, saving throw modifiers, skill modifiers, Perception modifiers, and AC of the PC by 1.", "Increase the Hit Point totals of the PC by 10 or by 10%, whichever is higher."]
        
        let bulletList = add(stringList: bulletArray, font: UIFont.systemFont(ofSize: 14))
        
        // Do any additional setup after loading the view.
        
        levelBumpTitleLbl.text = "Level Bump"
        
        levelBumpInfoLbl.text = "To provide low level players a more fun and fair experience, PCs whose level equals the adventure’s base level (such as a 3rd-level PC playing in a Level 3–6 scenario) gain a temporary boost when playing in the higher level range called a level bump to represent the higher-level PCs’ mentorship and support."
        levelBumpBulletInfoLbl.attributedText = bulletList
        
        mentorshipInfoLbl.text = "These adjustments are less beneficial than gaining a level, yet they provide the PC more survivability and opportunity to contribute to the adventure experience, reducing the degree to which higher-level PCs might overshadow these less experienced Pathfinders. \n\nYou should also remind higher level PCs to apply any mentor boons they might have purchased."
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func add(stringList: [String], font: UIFont, bullet: String = "\u{2022}", indentation: CGFloat = 10, lineSpacing: CGFloat = 2, paragraphSpacing: CGFloat = 1, textColor: UIColor = .black, bulletColor: UIColor = .black) -> NSAttributedString {
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        //paragraphStyle.firstLineHeadIndent = 0
        //paragraphStyle.headIndent = 20
        //paragraphStyle.tailIndent = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        return bulletList
    }
}
