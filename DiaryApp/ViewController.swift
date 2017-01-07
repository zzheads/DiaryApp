//
//  ViewController.swift
//  DiaryApp
//
//  Created by Alexey Papin on 06.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let mood = Mood.mood(withTitle: "Bad")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(mood)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

