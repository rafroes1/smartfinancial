//
//  ViewController.swift
//  smartfinancial
//
//  Created by Rafael Fróes Monteiro Carvalho
//  Copyright © rafafroes. All rights reserved.
//

import UIKit
import RealmSwift
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var videoPlayerLayer: AVPlayerLayer?
    var videoLooper: AVPlayerLooper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        //let realm  = try! Realm()
        
        //get file url, copy path starting at /// and paste on terminal: open 'path'
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        /*
        //adding data to realm file
        let manobra = Manobra()
        manobra.ciclo = "43"
        manobra.cliente = "iss"
        
        try! realm.write{
            realm.add(manobra)
        }
 
         */
        
        /*
        //getting data from realm
        let results = realm.objects(Manobra.self).filter("ciclo = '43'")
        
        print(results[0])
         */
        
    }
    
    @IBAction func createAccountClick(_ sender: Any) {
        let alert = UIAlertController(title: "Restrito", message: "Favor requisitar um novo login para empresa", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func setUpElements(){
        Decorator.styleHollowButton(signupButton)
        Decorator.styleFilledButton(loginButton)
    }
}

