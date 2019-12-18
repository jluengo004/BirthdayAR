//
//  HintModalViewController.swift
//  SpotTheScientist
//
//  Created by Marisa on 18/12/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class HintModalViewController: UIViewController {

    @IBOutlet var hintLabel: UILabel!
    public var hintLabelText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hintLabel.text = hintLabelText

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
    }
     
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }


}
