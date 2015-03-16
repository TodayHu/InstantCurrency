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
import SWXMLHash

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    var data = [[String: String]]()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.fetchDataFromCurrencyFeed()
    }

    @IBAction func refreshClick() {
        self.data.removeAll(keepCapacity: false)
        self.fetchDataFromCurrencyFeed()
    }
    private func loadTableData() {
        table.setNumberOfRows(data.count, withRowType: "TableRowController")
        
        for(index, currencyData) in enumerate(data){
            let row = table.rowControllerAtIndex(index) as TableRowController
            
            for(key, value) in currencyData{
                row.currencyLabel.setText(String(key))
                row.valueLabel.setText(value as String)
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
        
        Alamofire.request(.GET, "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22EURIDR%22,%20%22USDIDR%22,%20%22AUDIDR%22,%20%22SGDIDR%22,%20%22JPYIDR%22)&env=store://datatables.org/alltableswithkeys", parameters: nil)
            .response { (request, response, data, error) in
                println(response)
                println(error)
            
                let xml = SWXMLHash.parse(data as NSData)
                
                var arrayTemp = [[String:String]]()
                
                for el in xml["query"]["results"]["rate"]{
                    
                    let key = el["Name"].element!.text as String?
                    let value = el["Rate"].element!.text as String?
                    
                    let dict = [key!: value!]
                    
                    self.data.append(dict as [String: String])
                }
                
                
                self.loadTableData()
        }
    }
}
