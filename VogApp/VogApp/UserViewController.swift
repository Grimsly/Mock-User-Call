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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "User Profile"
        basicInfo.delegate = self;
        basicInfo.dataSource = self;
        basicInfo.tableFooterView = UIView();
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return userInfo.count + 1;
        }
        else{
            return passwordInfo.count + 1;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            if (indexPath.row < userInfo.count){
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as? UserTableViewCell else{
                    fatalError("The dequed cell is not an instance of UserTableViewCell")
                }
                cell.subject.text = userInfo[indexPath.row];
                cell.content.text = "";
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
    
    @objc func savePressed(_ sender: UIButton){
        if (sender.tag == 0){
            print("Info");
        }else{
            print("Password");
        }
    }
}
