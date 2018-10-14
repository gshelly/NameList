//
//  ViewController.swift
//  NameList
//
//  Created by shelly.gupta on 5/12/18.
//  Copyright © 2018 shelly.gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var names: [String] = []
    var alphabetizedName = [String: [String]]()
    var sortedKeys: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://raw.githubusercontent.com/dominictarr/random-name/master/names.json")
        
        do {
            let data = try Data(contentsOf: url!)
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let name = object as? [String] {
                names = name
            }
        } catch let error {
            print("Failed to load : \(error.localizedDescription)")
        }
        alphabetizedName = alphabatizedArray(namesList: names)
        //sort the keys
        sortedKeys = alphabetizedName.keys.sorted(by: <)
    }

    
    func alphabatizedArray(namesList:[String]) -> [String:[String]] {
        var result = [String :[String]]()
        
        //
        for item in namesList {
            if let firstLetter = item.getSubstringFromStart(num: 1) {
                if result[firstLetter] != nil {
                    result[firstLetter]?.append(item)
                }
                else {
                    result[firstLetter] = [item]
                }
            }
        }
        
        // sorting the keys
        for(key, value) in result {
            result[key] = value.sorted(by: <)
        }
        return result
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedKeys?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //fetch the names in a section
        let key = sortedKeys![section]
        
        if let name = alphabetizedName[key] {
            return name.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        //assign the name in cell
        let key = sortedKeys![indexPath.section]
        
        if let name = alphabetizedName[key] {
            cell.textLabel?.text = name[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedKeys![section]
    }
}
extension String {
    func getSubstringFromStart(num :Int) -> String? {
        if self.count > num {
            let index = self.index(self.startIndex, offsetBy: num)
            //capturing first letter of the string with the help of index
            let subString = self[..<index].uppercased()
            return subString
        }
        return nil
    }
}

