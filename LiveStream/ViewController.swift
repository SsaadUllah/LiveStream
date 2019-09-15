//
//  ViewController.swift
//  LiveStream
//
//  Created by SSaad Ullah on 8/29/19.
//  Copyright © 2019 SSaadUllah. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    //1 backsearchwithRange
    //2. searchContAboveRange
    //3. searchContAboveValueTwoSignals
    //4. searchMultiContWithinRange
    
    
    let kCSVFileName = "latestSwing"
    let kCSVFileExtension = "csv"
    
    var myData = [[String]]()
    
    var selected = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var data = readDataFromCSV(fileName: kCSVFileName, fileType: kCSVFileExtension)
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        myData = csvRows
        print(csvRows[1][1]) //-1.136719
        
        
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        let tag = sender.tag
        switch tag {
        case 1:
            //backSearchContinuityWithinRange
            selected = "backSearchContinuityWithinRange"
            performSegue(withIdentifier: "funcSegue", sender: self)
            break
        case 2:
            //searchContinuityAboveValue
            selected = "searchContinuityAboveValue"
            performSegue(withIdentifier: "funcSegue", sender: self)
            break
        case 3:
            //searchContinuityAboveValueTwoSignals
            selected = "searchContinuityAboveValueTwoSignals"
            performSegue(withIdentifier: "funcSegue", sender: self)
            break
        case 4:
            //searchMultiContinuityWithinRange
            selected = "searchMultiContinuityWithinRange"
            performSegue(withIdentifier: "funcSegue", sender: self)
            break
        default:
            print("")
        }
        
    }
    
    
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
 

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "funcSegue") {
            if let nextViewController = segue.destination as? DetailVC {
                nextViewController.type = selected
                nextViewController.myData = myData
            }
        }
    }
}























