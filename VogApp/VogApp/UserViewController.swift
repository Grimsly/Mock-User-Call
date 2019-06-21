//
//  UserViewController.swift
//  VogApp
//
//  Created by Xian-Meng Low on 2019-06-19.
//  Copyright © 2019 Xian-Meng Low. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var basicInfo: UITableView!
    private var userInfo : [String] = ["Username", "First Name", "Last Name"]
    private var passwordInfo : [String] = ["New Password", "Re-enter Password"]
    private var userData : [String] = ["","",""];
    private var passwordData : [String] = ["", ""];
    private var jsonData : Data?;
    private var message : String = "";
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "User Profile"
        basicInfo.delegate = self;
        basicInfo.dataSource = self;
        basicInfo.tableFooterView = UIView();
        //Read the JSON from "https://api.foo.com/profiles/mine".
        connectURL(url: "https://api.foo.com/profiles/mine", errorTitle: "User Data Retrieval Failed", errorMessage: "Soemthing went wrong", successMessage: "User data read successfully", post: false, section: 0);

    }
    
    //Two section, one for the user data and the password section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Basic Information";
        }
        else{
            return "Password"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView{
            headerView.contentView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0);
            headerView.textLabel?.textColor = .gray;
        }
    }
    
    //Give the each section rows for the username, password, etc. plus one more row for the button table cell.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return userInfo.count + 1;
        }
        else{
            return passwordInfo.count + 1;
        }
    }
    
    //Fill the rows with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            if (indexPath.row < userInfo.count){
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as? UserTableViewCell else{
                    fatalError("The dequed cell is not an instance of UserTableViewCell")
                }
                cell.subject.text = userInfo[indexPath.row];
                cell.content.text = userData[indexPath.row];
                
                //Tag the text field of each row with a section and a row number for future use
                cell.content.section = indexPath.section;
                cell.content.row = indexPath.row;
                cell.content.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged);
                return cell;
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SaveChangesViewCell", for: indexPath) as? SaveChangesTableViewCell else{
                    fatalError("The dequed cell is not an instance of SaveChangesTableViewCell")
                }
                cell.saveChangesButton.layer.borderColor = UIColor.white.cgColor;
                cell.saveChangesButton.tag = indexPath.section;
                cell.saveChangesButton.addTarget(self, action: #selector(savePressed(_:)), for: .touchUpInside);
                return cell;
            }
        }else{
            if (indexPath.row < passwordInfo.count){
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as? UserTableViewCell else{
                    fatalError("The dequed cell is not an instance of UserTableViewCell")
                }
                cell.subject.text = passwordInfo[indexPath.row];
                cell.content.text = "";
                cell.content.section = indexPath.section;
                cell.content.row = indexPath.row;
                cell.content.isSecureTextEntry = true;
                cell.content.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged);
                return cell;
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SaveChangesViewCell", for: indexPath) as? SaveChangesTableViewCell else{
                    fatalError("The dequed cell is not an instance of SaveChangesTableViewCell")
                }
                cell.saveChangesButton.layer.borderColor = UIColor.white.cgColor;
                cell.saveChangesButton.tag = indexPath.section;
                cell.saveChangesButton.addTarget(self, action: #selector(savePressed(_:)), for: .touchUpInside);
                return cell;
            }
        }
    }
    
    //Depending on which section the button belongs, it will POST whatever is in the text fields of that section.
    @objc func savePressed(_ sender: UIButton){
        //If the button is from section 0 (Basic Info section), it will POST the name changes to "https://api.foo.com/profiles/update"
        if (sender.tag == 0){
            print(userData);
            let json : [String:Any] = ["data" : ["firstName" : userData[1], "lastName" : userData[2], "userName" : userData[0]]];
            jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            connectURL(url: "https://api.foo.com/profiles/update", errorTitle: "User Data Change Failed", errorMessage: "Soemthing went wrong", successMessage: "User data successfully changed", post: true, section: 0);
            
        }
        //If the button is from section 1 (Password section), it will POST all the password info to "https://api.foo.com/password/change"
        else{
            print(passwordData);
            let json : [String:Any] = ["data" : ["currentPassword" : userData[1], "newPassword" : userData[2], "passwordConfirmation" : userData[0]]];
            jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            connectURL(url: "https://api.foo.com/password/change", errorTitle: "Password Change Failed", errorMessage: "Something went wrong", successMessage: "Password changed successfully", post: true, section: 1);
        }
    }
    
    //Checks which specific text fields from which table cell changed
    @objc func textFieldDidChange(_ textField: CustomTextFields){
        if (textField.section == 0){
            userData[textField.row!] = textField.text!;
        }else{
            passwordData[textField.row!] = textField.text!;
        }
    }
    
    //Function for reading JSON object
    func readJSONObject(object: [String: AnyObject], section: Int) {
        message = object["message"] as! String;
        guard let data = object["data"] as? [String: AnyObject] else { return }
        
        if section == 0{
            userData[0] = data["userName"] as! String;
            userData[1] = data["firstName"] as! String;
            userData[2] = data["lastName"] as! String;
        }
    }
    
    //Function for either extracting or uploading the JSON object
    func connectURL(url: String, errorTitle: String, errorMessage: String, successMessage: String, post: Bool, section: Int){
        let url = URL(string: url);
        var request = URLRequest(url: url!);
        
        //If uploading, set the httpMethod to POST and attach a JSON to the URLRequest
        if (post){
            request.httpMethod = "POST";
            
            request.httpBody = jsonData;
        }
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            //If an error occured, an alert dialog will pop up and tell the user something is wrong
            if let error = error {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert);
                    alertController.addAction(UIAlertAction(title: "Confirm", style: .default));
                    self.present(alertController, animated: true, completion: nil);
                }
                print ("error: \(error)");
                return;
            }
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else{
                print("Server Error");
                return;
            };
            
            guard let data = data, error == nil else {
                return
            };
            
            //But if the connection went through, and something was returned, grab the data and turn it into a readable form like a disctionary.
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    self.readJSONObject(object: dictionary, section: 0);
                    //Tell the user that the data was read successfully
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: self.message, message: successMessage, preferredStyle: .alert);
                        alertController.addAction(UIAlertAction(title: "Confirm", style: .default));
                        self.present(alertController, animated: true, completion: nil);
                    }
                }
            }
            //If the read failed, then return an error.
            catch {
                print("Error reading JSON file")
            }
        }
        
        task.resume();
    }
}
