//
//  ShowPicViewController.swift
//  CircleGraphs
//
//  Created by Parker Chen on 2021/5/5.
//

import UIKit

class ShowPicViewController: UIViewController {

    var dataInfo: DataInfo = DataInfo(selectCase: 0, lineWidth: 0, radius: 0, percents: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch dataInfo.selectCase {
        case 0:
            showSingleCirclePercent()
        case 1:
            showMultiCirRingSegPercents()
        case 2:
            showMultiCirPieSegPercents()
        default:
            print("None this case !")
        }
    }
    
    func showSingleCirclePercent() {
        // single circle percent :
        let aDegree = CGFloat.pi / 180
        let startDegree: CGFloat = 270
        let lineWidth: CGFloat = CGFloat(dataInfo.lineWidth)
        let radius: CGFloat = CGFloat(dataInfo.radius)
        
        //從(view.center.x, view.center.y)作為左上角頂點，畫一個(radius*2)*(radius*2)的內圓環
        let circlePath = UIBezierPath(ovalIn: CGRect(x: view.center.x - radius, y: view.center.y - radius, width: radius*2, height: radius*2))
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor  = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clear.cgColor
        
        //以(view.center.x, view.center.y)當作圓心，半徑radius，從最上點(270度)開始，畫出dataInfo.percents[0]%的圓周長圓環
        let percentage: CGFloat = CGFloat(dataInfo.percents[0])
        let percentagePath = UIBezierPath(arcCenter: CGPoint(x: view.center.x, y: view.center.y), radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * (startDegree + 360 * percentage / 100), clockwise: true)
        let percentageLayer = CAShapeLayer()
        percentageLayer.path = percentagePath.cgPath
        percentageLayer.strokeColor  = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
        percentageLayer.lineWidth = lineWidth
        percentageLayer.lineCap = .round
        percentageLayer.fillColor = UIColor.clear.cgColor
        
        let view1 = UIView()
        view1.layer.addSublayer(circleLayer)
        view1.layer.addSublayer(percentageLayer)
        
        //在正中央放上 百分比% label
        let label = UILabel(frame: CGRect(x: view.center.x - radius - lineWidth, y: view.center.y - radius - lineWidth, width: 2*(radius+lineWidth), height: 2*(radius+lineWidth)))
        label.textAlignment = .center
        label.text = "\(percentage)%"
        view1.addSubview(label)
        
        view.addSubview(view1)
    }
    
    func showMultiCirRingSegPercents() {
        // circle : fine
        let aDegree = CGFloat.pi / 180
        var startDegree: CGFloat = 270
        let lineWidth: CGFloat = CGFloat(dataInfo.lineWidth)//40
        let radius: CGFloat = CGFloat(dataInfo.radius)//100//50

        //定出中心點位置，使 view為 2*(radius+lineWidth)W * 2*(radius+lineWidth)H
        let view1 = UIView(frame: CGRect(x: view.center.x - radius - lineWidth, y: view.center.y - radius - lineWidth, width: 2*(radius+lineWidth), height: 2*(radius+lineWidth)))
        let center = CGPoint(x: lineWidth + radius, y: lineWidth + radius)
        
        //transfer Int Array into CGFloat Array
        let doubleArray = dataInfo.percents.map {
            CGFloat(($0 as Int))
        }
        let percentages: [CGFloat] = doubleArray
        //依 Array的各值， show出對應的甜甜圈弧度區域
        for percentage in percentages {
            let endDegree = startDegree + 360 * percentage / 100
            let percentagePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
            let percentageLayer = CAShapeLayer()
            percentageLayer.path = percentagePath.cgPath
            percentageLayer.strokeColor  = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
            percentageLayer.lineWidth = lineWidth
            percentageLayer.fillColor = UIColor.clear.cgColor
            view1.layer.addSublayer(percentageLayer)
            //show Label code
            let label = createLabel(percentage: percentage, startDegree: startDegree, center: center, radius: radius, aDegree: aDegree, fontSize: radius/4)
            startDegree = endDegree
            view1.addSubview(label) //add label in view1, cause the label x,y in scope view1
            view.addSubview(view1)
        }
    }
    
    func showMultiCirPieSegPercents() {
        // full cookie : fine
        let aDegree = CGFloat.pi / 180
        var startDegree: CGFloat = 270
        let radius: CGFloat = CGFloat(dataInfo.radius)

        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 2*(radius), height: 2*(radius)))
        let center = CGPoint(x: view.center.x, y: view.center.y)
        
        //transfer Int Array into CGFloat Array
        let doubleArray = dataInfo.percents.map {
            CGFloat(($0 as Int))
        }
        let percentages: [CGFloat] = doubleArray
        //依 Array的各值， show出對應的餅圖比例區域
        for percentage in percentages {
            let endDegree = startDegree + 360 * percentage / 100
            let percentagePath = UIBezierPath()

            //以 view 中心為圓心，畫出圓餅比例圖
            percentagePath.move(to: view.center)
            percentagePath.addArc(withCenter: view.center, radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
            let percentageLayer = CAShapeLayer()
            percentageLayer.path = percentagePath.cgPath
            percentageLayer.fillColor  = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
            view1.layer.addSublayer(percentageLayer)
            
            //show Label code
            let label = createLabel(percentage: percentage, startDegree: startDegree, center: center, radius: radius/2, aDegree: aDegree, fontSize: radius/5)
            startDegree = endDegree
            view1.addSubview(label) //add label in view1, cause the label x,y in scope view1
            view.addSubview(view1)
        }
    }
    
    func createLabel(percentage: CGFloat, startDegree: CGFloat, center: CGPoint, radius: CGFloat, aDegree: CGFloat, fontSize: CGFloat) -> UILabel {
        //let text position is at half of the part of circle
        let textCenterDegree = startDegree + (360 * percentage / 100) / 2
        let textPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: aDegree * textCenterDegree, endAngle: aDegree * textCenterDegree, clockwise: true)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: radius, height: radius/5*3))
        label.backgroundColor = UIColor.yellow
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.text = "\(percentage)%"
        label.sizeToFit()
        label.center = textPath.currentPoint
        return label
    }
}
