//
//  DetailVC.swift
//  LiveStream
//
//  Created by SSaad Ullah on 9/13/19.
//  Copyright © 2019 SSaadUllah. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var data: UITextField!
    @IBOutlet weak var data1: UITextField!
    @IBOutlet weak var data2: UITextField!
    
    @IBOutlet weak var winLength: UITextField!
    @IBOutlet weak var indexBegin: UITextField!
    @IBOutlet weak var indexEnd: UITextField!
    
    @IBOutlet weak var threshold: UITextField!
    @IBOutlet weak var thresholdLow1: UITextField!
    @IBOutlet weak var thresholdHi2: UITextField!
    
    @IBOutlet weak var answer: UILabel!
    
    var type = ""
    var myData = [[String]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type {
        case "searchContinuityAboveValue":
            data1.isEnabled=false
            data2.isEnabled=false
            thresholdLow1.isEnabled=false
            thresholdHi2.isEnabled=false
            
            break
        case "backSearchContinuityWithinRange":
            data1.isEnabled=false
            data2.isEnabled=false
            threshold.isEnabled=false
            thresholdLow1.isEnabled=true
            thresholdHi2.isEnabled=true
            break
            
        case "searchContinuityAboveValueTwoSignals":
            data1.isEnabled=true
            data2.isEnabled=true
            thresholdLow1.isEnabled=true
            thresholdHi2.isEnabled=true
            
            data.isEnabled=false
            threshold.isEnabled=false
            
            
            break
        case "searchMultiContinuityWithinRange":
            data1.isEnabled=false
            data2.isEnabled=false
            threshold.isEnabled=false
            thresholdLow1.isEnabled=true
            thresholdHi2.isEnabled=true
            break
        default:
            print("default")
        }

    }

    @IBAction func calculateResult(_ sender: UIButton) {
        switch type {
        case "searchContinuityAboveValue":

            //Start Index will fetch the first timestamp row of that indexBegin from Column list
            let index = Int(indexBegin.text!)!
            
            let data = myData[index]
            let ans = searchContinuityAboveValue(data: data, indexBegin: Int(indexBegin.text!)!, indexEnd: Int(indexEnd.text!)!, threshold: Float(threshold.text!)!, winLength: Int(winLength.text!)!)
            
            // Print Answer
            answer.text = "RESULT : \(ans)"

            break
        case "backSearchContinuityWithinRange":
            
            //Start Index will fetch the first timestamp row of that indexBegin from Column list
            let index = Int(indexBegin.text!)!
            
            let data = myData[index]
            let ans = backSearchContinuityWithinRange(data: data, indexBegin: Int(indexBegin.text!)!, indexEnd: Int(indexEnd.text!)!, thresholdLo: Float((thresholdLow1.text!))! , thresholdHi: Float((thresholdHi2.text!))!, winLength: Int(winLength.text!)!)
            
            // Print Answer
            answer.text = "RESULT : \(ans)"
            
            break
            
        case "searchContinuityAboveValueTwoSignals":
            
            //Start Index will fetch the first timestamp row of that indexBegin from Column list
            let indexData1 = Int((data1.text!))!
            let dataLo = myData[indexData1]
            
            let indexData2 = Int((data2.text)!)!
            let dataHi = myData[indexData2]
            
            let ans = searchContinuityAboveValueTwoSignals(data1: dataLo, data2: dataHi, indexBegin: Int(indexBegin.text!)! , indexEnd: Int(indexEnd.text!)!, thresholdLo: Float((thresholdLow1.text!))! , thresholdHi: Float((thresholdHi2.text!))!, winLength: Int(winLength.text!)!)
            
            // Print Answer
            answer.text = "RESULT : \(ans)"
            
            break
        case "searchMultiContinuityWithinRange":
            
            let index = Int(indexBegin.text!)!
            let data = myData[index]
            let ans = searchMultiContinuityWithinRange(data: data, indexBegin: Int(indexBegin.text!)!, indexEnd: Int(indexEnd.text!)!, thresholdLo: Float((thresholdLow1.text!))! , thresholdHi: Float((thresholdHi2.text!))!, winLength: Int(winLength.text!)!)
            
            // Print Answer
            answer.text = "RESULT : \(ans)"
            
            break
        default:
            print("default")
        }
    }
}


extension DetailVC{
    func searchContinuityAboveValue(data: [String], indexBegin : Int, indexEnd: Int, threshold : Float,
                                    winLength: Int) -> Int {
        var count=1;
        
        var start = indexBegin
        var prevIndex = -1000
        for i in indexBegin...indexEnd{
            let ithData = data[i]
            if ithData.count>0{
                let value : Float = Float(data[i])!
                if(value>threshold) {
                    if(prevIndex == (i-1)) {
                        count += 1
                    }else {
                        start = i;
                        count=1;
                    }
                    prevIndex=i;
                    if(count>=winLength){
                        return start
                    }
                }
            }
        }
        
        return -1
    }
    
    func backSearchContinuityWithinRange(data: [String], indexBegin : Int, indexEnd: Int,
                                         thresholdLo : Float, thresholdHi: Float, winLength: Int) -> Int{
        
        var count=1;
        var start = indexBegin
        var prevIndex = -1000
        
        for i in indexBegin...indexEnd{
            let ithData = data[i]
            if ithData.count > 0{
                
                let value : Float = Float(data[i])!
                
                if(value>thresholdLo && value<thresholdHi) {
                    if(prevIndex == (i-1)) {
                        count += 1
                    }else {
                        start = i;
                        count=1;
                    }
                    prevIndex=i;
                    if(count>=winLength){
                        return start
                    }
                }
            }
        }
        return -1
    }
    
    func searchContinuityAboveValueTwoSignals(data1: [String], data2: [String], indexBegin : Int, indexEnd: Int,
                                              thresholdLo : Float, thresholdHi: Float, winLength: Int) -> [Int] {
        
        var indexList = [Int]()
        indexList = getIndexAboveValue(data: data1,indexBegin: indexBegin,indexEnd: indexEnd,threshold: thresholdLo,winLength: winLength,indexArr: indexList)
        indexList = getIndexAboveValue(data: data2,indexBegin: indexBegin,indexEnd: indexEnd,threshold: thresholdHi,winLength: winLength,indexArr: indexList)
        
        if(indexList.count == 2) {
            return indexList
        }
        
        return [-1,-1]
    }
    
    func searchMultiContinuityWithinRange(data: [String], indexBegin : Int, indexEnd: Int,
                                         thresholdLo : Float, thresholdHi: Float, winLength: Int) -> [Int]{
        
        var count=1;
        var start = indexBegin
        var prevCount = -1
        
        var list = [Int]()
        var result = [Int]()
        for i in indexBegin...indexEnd{
            let value : Float = Float(data[i])!
            if(value>thresholdLo && value<thresholdHi){
                list.append(i)
            }
        }
        
        
        for i in 1...list.count-1{
            if(list[i]==(list[i-1]+1)) {
                count += 1
            }else {
                prevCount=count;
                if(prevCount>=winLength) {
                    result.append(start)
                    result.append(i-1);
                    return result
                }
                start = i
                count=1
            }
        }
        
        if(result.count==2){
            return result
        }
        return [-1,-1]
    }
    
  
    
    // This will Run twice to get the values above the Two Signals
    func getIndexAboveValue(data: [String], indexBegin : Int, indexEnd: Int, threshold : Float,
                            winLength: Int , indexArr: [Int]) -> [Int] {
        var count=1;
        var start = indexBegin
        var prevIndex = -1000
        var myList = indexArr
        
        for i in indexBegin...indexEnd{
            let ithData = data[i]
            if ithData.count>0{
                let value : Float = Float(data[i])!
                if(value>threshold) {
                    if(prevIndex == (i-1)) {
                        count += 1
                    }else {
                        start = i;
                        count=1;
                    }
                    prevIndex=i;
                    if(count>=winLength){
                        myList.append(start)
                        return myList
                    }
                }
            }
        }
        
        return myList
    }
    
    
    
    
    
}


