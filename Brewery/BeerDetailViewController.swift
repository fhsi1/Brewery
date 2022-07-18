//
//  BeerDetailViewController.swift
//  Brewery
//
//  Created by Yujean Cho on 2022/04/21.
//

import UIKit

class BeerDetailViewController: UITableViewController {
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = beer?.name ?? "이름 없는 맥주"
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell")
        tableView.rowHeight = UITableView.automaticDimension
        
        // 상단 imageView
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        let headerView = UIImageView(frame: frame)
        let imageURL = URL(string: beer?.imageURL ?? "")
        
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "beer_icon.png"))
        
        tableView.tableHeaderView = headerView
    }
}


// UITableView Datasource, Delegate
extension BeerDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3: // food pairing, 문자열의 배열
            return beer?.foodPairing?.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ID"
        case 1:
            return "DESCRIPTION"
        case 2:
            return "BREWERS TIPS"
        case 3:
            let isFoodPairingEmpty = beer?.foodPairing?.isEmpty ?? true
            return isFoodPairingEmpty ? nil : "FOOD PAIRING"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell")
        
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none // tap 할 때마다 회색 음영이 표현되지 않도록 설정
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = String(describing: beer?.id ?? 0)
            return cell
        case 1:
            cell.textLabel?.text = beer?.description ?? "설명 없는 맥주"
            return cell
        case 2:
            cell.textLabel?.text = beer?.brewersTips ?? "팁 없는 맥주"
            return cell
        case 3:
            cell.textLabel?.text = beer?.foodPairing?[indexPath.row] ?? ""
            return cell
        default:
            return cell
        }
    }
}
