//
//  ViewController.swift
//  LiverpoolTest
//
//  Created by Alan Omar Solano Campos on 27/06/20.
//  Copyright © 2020 Alan Omar Solano Campos. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var records:[RecordModel]?
    var recordsCD:[RecordEntity?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProductCellTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProductCellTableViewCell")
        
        self.searchBar.delegate = self
        self.recordsCD = []
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
            do {
                self.recordsCD = try context.fetch(fetchRequest)
            } catch  {
                print("Error readCoreData")
            }
        }
        self.searchBar.text = self.getLastSearchText()
    }
    
    func searchRequestWith(_ searchText: String) {
    
        guard let url = URL(string: "https://shoppapp.liverpool.com.mx/appclienteservices/services/v3/plp?force-plp=true&search-string=\(searchText)&page-number=1&number-of-items-per-page=12") else {
            print("error URL")
            return
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (info, response, error) in
            
            if error != nil { print("request error") }
            guard let jsonData = info else {
                print("request error data")
                return
            }
            do{
                let responseModel = try JSONDecoder().decode(ResponseModel.self, from: jsonData)
                self.records = responseModel.plpResults?.records
                DispatchQueue.main.async {
                    self.cleanEntity()
                    self.records?.forEach({ (record) in
                        self.recordsCD?.append(self.createRecordEntity(recordModel: record))
                    })
                    self.tableView.reloadData()
                }
            }catch{
                print("request error data decode")
            }
            
        }.resume()
        
    }
    
    func createRecordEntity(recordModel: RecordModel?) -> RecordEntity?{
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return nil}
        let recordEntity = NSEntityDescription.insertNewObject(forEntityName: "RecordEntity", into: context) as! RecordEntity
        
        recordEntity.productDisplayName = recordModel?.productDisplayName
        recordEntity.lgImage = recordModel?.lgImage
        recordEntity.listPrice = recordModel?.listPrice ?? 0
        recordEntity.productType = recordModel?.productType
        
        do{
            try context.save()
        }catch{
            print("Error saveCoreData")
            return nil
        }
        
        return recordEntity
    }
    
    func cleanEntity() { // predicate in format "property == 1"
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecordEntity")
            do {
                let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(DelAllReqVar)
                try context.save()
                self.recordsCD = []
            } catch  {
                print("Error readCoreData")
            }
            
        }
    }
    
    func saveSearchText(with text: String) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}
        let searchText = NSEntityDescription.insertNewObject(forEntityName: "SearchString", into: context) as! SearchString
        
        searchText.text = text
        
        do{
            try context.save()
        }catch{
            print("Error saveCoreData")
            return
        }
        
        return
    }
    
    func getLastSearchText() -> String?{
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchRequest: NSFetchRequest<SearchString> = SearchString.fetchRequest()
            do {
                let result = try context.fetch(fetchRequest)
                return result.last?.text
            } catch  {
                print("Error readCoreData")
            }
        }
        return nil
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordsCD?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCellTableViewCell", for: indexPath) as! ProductCellTableViewCell
        cell.fill(record: recordsCD?[indexPath.row], tag: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? true {return}
        if searchBar.text?.hasSpecialCharacters() ?? true { return }
        self.searchRequestWith(searchBar.text!)
        self.saveSearchText(with: searchBar.text!)
        
    }
}

extension String{
    func hasSpecialCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
        
    }
}
