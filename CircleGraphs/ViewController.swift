//
//  ViewController.swift
//  CircleGraphs
//
//  Created by Parker Chen on 2021/5/5.
//

import UIKit

class ViewController: UIViewController {
    
    var dataInfo: DataInfo = DataInfo(selectCase: 0, lineWidth: 0, radius: 0, percents: [])

    @IBOutlet var selectSW: [UISwitch]!{
        didSet {
            selectSW.sort { $0.tag < $1.tag }
        }
    }
    
    @IBOutlet weak var singleCirclePercent: UITextField!
    @IBOutlet weak var multiCirRingSegPercents: UITextField!
    @IBOutlet weak var multiCirPieSegPercents: UITextField!
    @IBOutlet weak var lineWidth: UITextField!
    @IBOutlet weak var radiusLength: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func switchDetect(_ sender: UISwitch) {
        
        selectSW.forEach { sw in
            sw.isOn = false
        }
        selectSW[sender.tag].isOn = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let showVC = (segue.destination as! ShowPicViewController)
        showVC.dataInfo = self.dataInfo
    }
    
    @IBAction func showButton(_ sender: UIButton) {
        var selectItem: Int?
        selectSW.forEach { sw in
            if sw.isOn {
                selectItem = sw.tag
            }
        }
        if let sel = selectItem {
            
            dataInfo.selectCase = sel
            switch sel {
            case 0:
                guard let lineWidth = lineWidth.text else { return print("Please Input lineWidth field") }
                dataInfo.lineWidth = Int(lineWidth) ?? 0
                
                guard let radius = radiusLength.text else { return print("Please Input radius field") }
                dataInfo.radius = Int(radius) ?? 0
                
                guard let percents = singleCirclePercent.text else { return print("Please Input percents field") }
                dataInfo.percents = getElements(percents: percents)
                
            case 1:
                guard let lineWidth = lineWidth.text else { return print("Please Input lineWidth field") }
                dataInfo.lineWidth = Int(lineWidth) ?? 0
                
                guard let radius = radiusLength.text else { return print("Please Input radius field") }
                dataInfo.radius = Int(radius) ?? 0
                
                guard let percents = multiCirRingSegPercents.text else { return print("Please Input percents field") }
                dataInfo.percents = getElements(percents: percents)
                
            case 2:
                guard let radius = radiusLength.text else { return print("Please Input radius field") }
                dataInfo.radius = Int(radius) ?? 0
                
                guard let percents = multiCirPieSegPercents.text else { return print("Please Input percents field") }
                dataInfo.percents = getElements(percents: percents)
                
            default:
                print("Out of Switch select case")
            }
            
            performSegue(withIdentifier: "ToShowPicVC", sender: sender)
        }
        
        func getElements(percents: String) -> Array<Int> {
            let pArray = percents.components(separatedBy: [","])    //it's String Array
            let intArray = pArray.map { Int($0)! }   //transfer into Int Array
            return intArray
        }
        
    }
    
}

