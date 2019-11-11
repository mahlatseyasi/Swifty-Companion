//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Mahlatse KHOZA on 2019/10/20.
//  Copyright © 2019 Mahlatse KHOZA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var searchButton: UIButton!
	
	var jsonData: JSON?
	var auth = Auth()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
		searchButton.layer.cornerRadius = 5
		searchButton.isEnabled = false
		searchButton.backgroundColor = UIColor.lightGray
		auth.getToken()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func editText(_ sender: UITextField) {
		if sender.text != ""
		{
			searchButton.isEnabled = true
			searchButton.backgroundColor = UIColor.green
		}
		else
		{
			searchButton.isEnabled = false
			searchButton.backgroundColor = UIColor.lightGray
		}
		
	}
	
	@IBAction func search(_ sender: UIButton) {
		if let login = textField.text?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil) {
			auth.checkUser(login) {
				completion in
				if completion != nil {
					self.jsonData = completion
					self.performSegue(withIdentifier: "Profile", sender: nil)
					self.searchButton.isEnabled = true
				} else {
					let alert = UIAlertController(title: "Error", message: "This login doesn't exists", preferredStyle: UIAlertControllerStyle.alert)
					alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
					self.present(alert, animated: true, completion: nil)
					self.searchButton.isEnabled = true
				}
			}
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "Profile" {
			let new = segue.destination as! ProfileVC
			new.data = jsonData
		}
	}
}

