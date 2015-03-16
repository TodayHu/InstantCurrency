//
//  InterfaceController.swift
//  InstantCurrency WatchKit Extension
//
//  Created by Hisma Mulya S on 3/16/15.
//  Copyright (c) 2015 Ice House. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    var data: Array<Dictionary<String,Int>> = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        data = [["USD":1000],["JPY": 1], ["GBP": 23], ["AUD":1000], ["EUR": 1]]
        self.loadTableData()
        self.fetchDataFromCurrencyFeed()
    }

    private func loadTableData() {
        table.setNumberOfRows(data.count, withRowType: "TableRowController")
        
        for(index, currencyData) in enumerate(data){
            let row = table.rowControllerAtIndex(index) as TableRowController
            
            for(key, value) in currencyData{
                row.currencyLabel.setText(String(key))
                row.valueLabel.setText(String(value))
            }
        }
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func fetchDataFromCurrencyFeed(){
        Alamofire.request(.GET, "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22EURIDR%22,%20%22USDIDR%22,%20%22AUDIDR%22)&env=store://datatables.org/alltableswithkeys", parameters: nil)
            .response { (request, response, data, error) in
                println(response)
                println(error)
                println("data : \(data)")
        }
    }
}
