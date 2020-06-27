//
//  ViewController.swift
//  LiverpoolTest
//
//  Created by Alan Omar Solano Campos on 27/06/20.
//  Copyright © 2020 Alan Omar Solano Campos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var records:[Records]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProductCellTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProductCellTableViewCell")
        
        self.searchBar.delegate = self
        self.searchRequestWith("")
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
                    self.tableView.reloadData()
                }
            }catch{
                print("request error data decode")
            }
            
        }.resume()
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCellTableViewCell", for: indexPath) as! ProductCellTableViewCell
        cell.fill(record: records?[indexPath.row], tag: indexPath.row)
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
