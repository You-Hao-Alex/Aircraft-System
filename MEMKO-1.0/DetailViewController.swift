//
//  DetailViewController.swift
//  MEMKO-1.0
//
//  Created by 陳致元 on 2018/5/27.
//  Copyright © 2018年 Chih-Yuan Chen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
   
     var test: ViewController? = nil
    
    @IBAction func logout(_sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "index", sender: self)
      
    }
    
    @IBAction func back(_sender: UIBarButtonItem){
        let vc = storyboard?.instantiateViewController(withIdentifier: "home")
        navigationController?.pushViewController(vc!, animated: true)
    
    }
    @IBOutlet weak var a1: UILabel!
    @IBOutlet weak var a2: UILabel!
    @IBOutlet weak var a3: UILabel!
    @IBOutlet weak var a4: UILabel!
    @IBOutlet weak var a5: UILabel!
    var detailaircraft: Aircraft? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailaircraft = detailaircraft {
            if let a1 = a1 {
              a5.text = detailaircraft.AC_TYPE
                a5.textColor = UIColor.red
                a1.text = detailaircraft.AC
                a1.textColor = UIColor.red
                 a2.text = detailaircraft.AC_SN
                a2.textColor = UIColor.red
                 a3.text = detailaircraft.AC_SERIES
                a3.textColor = UIColor.red
                 a4.text = detailaircraft.STATUS
                a4.textColor = UIColor.red
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
