//
//  ProfileVC.swift
//  SwiftyCompanion
//
//  Created by Mahlatse KHOZA on 2019/10/23.
//  Copyright © 2019 Mahlatse KHOZA. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var photo: UIImageView!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var nickname: UILabel!
	@IBOutlet weak var mobile: UILabel!
	@IBOutlet weak var wallet: UILabel!
	@IBOutlet weak var correction: UILabel!
	@IBOutlet weak var grade: UILabel!
	@IBOutlet weak var level: UILabel!
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var skillTV: UITableView!
	@IBOutlet weak var projectsTV: UITableView!
	@IBOutlet weak var location: UILabel!
	
	var data: JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
		
		photo.layer.borderWidth = 2
		photo.layer.masksToBounds = true
		photo.layer.borderColor = UIColor.white.cgColor
		photo.layer.cornerRadius = photo.frame.width / 2
		progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
		progressBar.layer.cornerRadius = progressBar.frame.height / 2
		progressBar.clipsToBounds = true
		progressBar.layer.sublayers![1].cornerRadius = progressBar.frame.height / 2
		progressBar.subviews[1].clipsToBounds = true
		skillTV.layer.cornerRadius = 5
		skillTV.clipsToBounds = true
		projectsTV.layer.cornerRadius = 5
		projectsTV.clipsToBounds = true
		location.textColor = UIColor.white
		location.textAlignment = .center
		
		loadData()
		loadPhoto()
		print(data as Any)
    }

	func loadData() {
		if let value = data!["displayname"].string {
			name.text = value
		}
		if let value = data!["login"].string {
			nickname.text = "(\(value))"
		}
		if let value = data!["phone"].string {
			mobile.text = value
		}
		if let value = data!["wallet"].int {
			wallet.text = "Wallet: \(value)"
		}
		if let value = data!["correction_point"].int {
			correction.text = "Corrections: \(value)"
		}
		if let value = data!["cursus_users"][0]["grade"].string {
			grade.text = "Grade: \(value)"
		}
		if let value = data!["cursus_users"][0]["level"].float {
			level.text = "Level: \(Int(value)) - \(Int(modf(value).1 * 100))%"
			progressBar.progress = modf(value).1
		}
		if let value = data!["location"].string {
			location.text = "Available\n\(value)"
		}
		else
		{
			location.text = "Unavailable\n-"
		}
	}
	
	func loadPhoto() {
		let strUrl = data!["image_url"].string!
		if let url = URL(string: strUrl) {
			if let data = NSData(contentsOf: url) {
				photo.image = UIImage(data: data as Data)
			} else {
				photo.image = #imageLiteral(resourceName: "background")
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == skillTV
		{
			return data!["cursus_users"][0]["skills"].count
		}
		else
		{
			return data!["projects_users"].count
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if tableView == skillTV
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "skill", for: indexPath) as! SkillTVC
			let skillName = data!["cursus_users"][0]["skills"][indexPath.row]["name"].string
			let skillLevel = data!["cursus_users"][0]["skills"][indexPath.row]["level"].float!

			cell.label.text = skillName! + " - level: " + String(skillLevel)
			cell.progress.progress = modf(skillLevel).1
			return cell
		}
		else
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "project", for: indexPath) as! ProjectsTVC
			let projectName = data!["projects_users"][indexPath.row]["project"]["name"].string
			let projectMark = data!["projects_users"][indexPath.row]["final_mark"].float
			let projectStatus = data!["projects_users"][indexPath.row]["validated?"].bool
			
			switch projectStatus
			{
			case true:
				cell.status.image = #imageLiteral(resourceName: "success")
			case false:
				cell.status.image = #imageLiteral(resourceName: "fail")
			default:
				cell.status.image = #imageLiteral(resourceName: "in_progress")
			}
			if (projectMark != nil)
			{
				cell.label.text = projectName! + " - " + String(projectMark!) + "%"
			}
			else
			{
				cell.label.text = projectName! + " - in progress"
			}
			return cell
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
