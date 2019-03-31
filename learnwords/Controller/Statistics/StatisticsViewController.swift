//
//  StatisticsViewController.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 21/11/2018.
//  Copyright © 2018 kapala. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController  {
    
    @IBOutlet weak var rememberedWordsLbl: UILabel!
    @IBOutlet weak var masteredWordsLbl: UILabel!
    @IBOutlet weak var lastMonthBtn: UIButton!
    @IBOutlet weak var last7DaysBtn: UIButton!
    @IBOutlet weak var lastYearBtn: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var filtersView: UIView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var chartCardView: UIView!
    var chartValues : [Double] = [0,0,0,0,0,0,0]
    var days : Int = 7
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.cardView.dropShadow()
        self.filtersView.dropShadow()
        self.chartCardView.dropShadow()
        
        self.last7DaysBtn.isSelected = false
        self.last7DaysBtn.backgroundColor = #colorLiteral(red: 0.2628087699, green: 0.7599683404, blue: 0.9947128892, alpha: 1)
        
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        
        chartView.xAxis.enabled = true
        chartView.xAxis.drawGridLinesEnabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size:12)!
        yAxis.setLabelCount(6, force: false)
        yAxis.axisLineColor = .white
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.labelPosition = .bottom
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let wordHistory = WordHistory.getWordHistory(forDate: Calendar.current.startOfDay(for: Date()), inContext: context) {
            self.rememberedWordsLbl.text = "\(wordHistory.remembered)"
            self.masteredWordsLbl.text = "\(wordHistory.mastered)"
        }
        self.chartValues = WordHistory.getRememberedCount(forNumberOfDays: days, inContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        
        self.updateGraph()
    }
    
    @IBAction func last7DaysDidTouch(_ sender: UIButton) {
        self.lastMonthBtn.isSelected = false
        self.lastYearBtn.isSelected = false
        sender.isSelected = true
        self.lastYearBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.lastMonthBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sender.backgroundColor = #colorLiteral(red: 0.2628087699, green: 0.7599683404, blue: 0.9947128892, alpha: 1)
        days = 7
        self.chartValues = WordHistory.getRememberedCount(forNumberOfDays: days, inContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        self.updateGraph()
    }
    
    @IBAction func lastMonthDidTOuch(_ sender: UIButton) {
        self.lastYearBtn.isSelected = false
        self.last7DaysBtn.isSelected = false
        self.last7DaysBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.lastYearBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sender.isSelected = true
        sender.backgroundColor = #colorLiteral(red: 0.2628087699, green: 0.7599683404, blue: 0.9947128892, alpha: 1)
        days = 30
        self.chartValues = WordHistory.getRememberedCount(forNumberOfDays: days, inContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        self.updateGraph()
    }
    @IBAction func lastYearDidTouch(_ sender: UIButton) {
        self.last7DaysBtn.isSelected = false
        self.lastMonthBtn.isSelected = false
        self.last7DaysBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.lastMonthBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sender.backgroundColor = #colorLiteral(red: 0.2628087699, green: 0.7599683404, blue: 0.9947128892, alpha: 1)
        sender.isSelected = true
        days = 365
        self.chartValues = WordHistory.getRememberedCount(forNumberOfDays: days, inContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        self.updateGraph()
    }
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0..<days {
            
            let value = ChartDataEntry(x: Double(i), y: chartValues[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Remembered") //Here we convert lineChartEntry to a LineChartDataSet
        line1.mode = .cubicBezier
        line1.drawCirclesEnabled = false
        line1.lineWidth = 1.8
        line1.circleRadius = 1
        line1.setCircleColor(.white)
        line1.highlightColor = #colorLiteral(red: 0.2628087699, green: 0.7599683404, blue: 0.9947128892, alpha: 1)
        
        line1.drawHorizontalHighlightIndicatorEnabled = false
        line1.fillFormatter = CubicLineSampleFillFormatter()
        line1.drawFilledEnabled = true
        line1.fillColor = #colorLiteral(red: 0.2628087699, green: 0.7599683404, blue: 0.9947128892, alpha: 1)
        line1.fillAlpha = 1
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        data.setDrawValues(false)
        
        chartView.data = data //finally - it adds the chart data to the chart and causes an update
        chartView.animate(xAxisDuration: 0, yAxisDuration: 2)
    }
}

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}
