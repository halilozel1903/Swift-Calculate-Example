//
//  ViewController.swift
//  Calculator
//
//  Created by Halil on 29.09.2017.
//  Copyright © 2017 Halil. All rights reserved.
//

import UIKit




class ViewController: UIViewController {

    @IBOutlet weak var textField1: UITextField!
    
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var result=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func toplam(_ sender: Any) {
        
        if let first_number=Int(textField1.text!){
            if let second_number=Int(textField2.text!){
                
                result=first_number+second_number
                
                resultLabel.text=String(result)
                
            }
        }
    }
    
    
    @IBAction func cikarma(_ sender: Any) {
        
        if let first_number=Int(textField1.text!){
            if let second_number=Int(textField2.text!){
                
                result=first_number-second_number
                
                resultLabel.text=String(result)
                
            }
        }
    }
    
    
    @IBAction func carpma(_ sender: Any) {
        
        if let first_number=Int(textField1.text!){
            if let second_number=Int(textField2.text!){
                
                result=first_number*second_number
                
                resultLabel.text=String(result)
                
            }
        }
    }
    
    
    @IBAction func bolme(_ sender: Any) {
        
        if let first_number=Int(textField1.text!){
            if let second_number=Int(textField2.text!){
                
                result=first_number/second_number
                
                resultLabel.text=String(result)
                
            }
        }
    }
    
}

