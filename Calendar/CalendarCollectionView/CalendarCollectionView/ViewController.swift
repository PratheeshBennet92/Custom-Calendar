//
//  ViewController.swift
//  CalendarCollectionView
//
//  Created by 843832 on 16/09/19.
//  Copyright © 2019 tcs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var calendarVC:CalendarViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        calendarVC = CalendarViewController.init(nibName: "CalendarViewController", bundle: nil)
        self.present(calendarVC, animated: true) {
            
        }
        
    }


}

