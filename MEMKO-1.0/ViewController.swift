//
//  ViewController.swift
//  MEMKO-1.0
//
//  Created by 陳致元 on 2018/5/27.
//  Copyright © 2018年 Chih-Yuan Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   var test: MasterViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK: Actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        login()
        emailTextField.text = nil
        passwordTextField.text = nil
    
    }
    @IBAction func perpareForUnwind(segue : UIStoryboardSegue){
    
    }
       
    
    //MARK: Function
    func login() {
        view.endEditing(true)
        guard
            let email = emailTextField.text, email == "admin",
            let password = passwordTextField.text, password == "admin"
            else{
                let alert = UIAlertController(title: "Error", message: "Invalid email or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                present(alert, animated: true, completion: nil)
                return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "home") 
        navigationController?.pushViewController(vc!, animated: true)
        
    }
}
