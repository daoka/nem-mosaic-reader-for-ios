//
//  MosaicListTableViewController.swift
//  MosaicReader
//
//  Created by Kazuya Okada on 2017/10/31.
//  Copyright © 2017年 appirits. All rights reserved.
//

import UIKit
import APIKit

class MosaicListTableViewController: UITableViewController {
    
    var addr:String?
    var mosaics:[OwnedMosaic]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func loadUserMosaics(address:String) {
        userMosaicsFromNIS(address: address)
    }
    
    private func userMosaicsFromNIS(address: String) {
        Session.send(NISAPI.OwnedMosaic(address: address)) { result in
            switch result {
            case .success(let response):
                print(response.data)
                self.addr = address
                self.mosaics = response.data
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if addr != nil {
            return 2
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            if mosaics != nil {
                return mosaics!.count
            }
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return self.tableView(tableView, addressCellRowAt: indexPath)
        } else {
            return self.tableView(tableView, mosaicCellRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, addressCellRowAt indexPaht: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPaht)
        cell.textLabel?.text = addr!
        return cell
    }
    
    func tableView(_ tableView: UITableView, mosaicCellRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mosaicCell", for: indexPath)
        let mosaic = mosaics![indexPath.row]
        cell.textLabel?.text = mosaic.mosaicId.displayMosaicInfo()
        cell.detailTextLabel?.text = String(mosaic.quantity)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "アドレス"
        } else {
            return "モザイク"
        }
    }

}
