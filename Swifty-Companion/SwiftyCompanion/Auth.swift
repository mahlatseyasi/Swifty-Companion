//
//  Auth.swift
//  SwiftyCompanion
//
//  Created by Mahlatse KHOZA on 2019/10/23.
//  Copyright © 2019 Mahlatse KHOZA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Auth: NSObject {

	var token = String()
	let url = "https://api.intra.42.fr/oauth/token"
	let config = [
		"grant_type": "client_credentials",
		"client_id": "bace58439ccef50ba2e082ae076915830a6ceb807d8aa926bb4da0e68fc69f7e",
		"client_secret": "4e4cc0f0e8bded08736dfe03a98e6951e845d28710fd3276fad765685b48d60a"]

	func getToken() {
		let verify = UserDefaults.standard.object(forKey: "token")
		if verify == nil {
			Alamofire.request(url, method: .post, parameters: config).validate().responseJSON {
				response in
				switch response.result {
				case .success:
					if let value = response.result.value {
						let json = JSON(value)
						self.token = json["access_token"].stringValue
						UserDefaults.standard.set(json["access_token"].stringValue, forKey: "token")
						print("NEW token:", self.token)
						self.checkToken()
					}
				case .failure(let error):
					print(error)
				}
			}
		} else {
			self.token = verify as! String
			print("SAME token:", self.token)
			checkToken()
		}
	}
	
	private func checkToken() {
		let url = URL(string: "https://api.intra.42.fr/oauth/token/info")
		let bearer = "Bearer " + self.token
		var request = URLRequest(url: url!)
		request.httpMethod = "GET"
		request.setValue(bearer, forHTTPHeaderField: "Authorization")
		Alamofire.request(request as URLRequestConvertible).validate().responseJSON {
			response in
			switch response.result {
			case .success:
				if let value = response.result.value {
					let json = JSON(value)
					print("The token will expire in:", json["expires_in_seconds"], "seconds.")
				}
			case .failure:
				print("Error: Trying to get a new token...")
				UserDefaults.standard.removeObject(forKey: "token")
				self.getToken()
			}
		}
	}
	
	func checkUser(_ user: String, completion: @escaping (JSON?) -> Void) {
		let userUrl = URL(string: "https://api.intra.42.fr/v2/users/" + user)
		let bearer = "Bearer " + self.token
		var request = URLRequest(url: userUrl!)
		request.httpMethod = "GET"
		request.setValue(bearer, forHTTPHeaderField: "Authorization")
		Alamofire.request(request as URLRequestConvertible).validate().responseJSON {
			response in
			switch response.result {
			case .success:
				if let value = response.result.value {
					let json = JSON(value)
					completion(json)
				}
			case .failure:
				completion(nil)
				print("Error: This login doesn't exists")
			}
		}
	}
}
