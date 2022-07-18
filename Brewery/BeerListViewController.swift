//
//  BeerListViewController.swift
//  Brewery
//
//  Created by Yujean Cho on 2022/04/21.
//

import UIKit

class BeerListViewController: UITableViewController {
    // Data source
    var beerList = [Beer]()
    
    // 한 번 불러온 페이지는 다시 불러오지 않기 위한 전역변수
    var dataTasks = [URLSessionTask]()
    
    // 첫 번째 보낼 page 설정
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UINavigationBar
        title = "Brewery"
        navigationController?.navigationBar.prefersLargeTitles = true // 큰 타이틀 형태로 보여준다.
        
        // UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        
        // pagination 을 위한 prefetch delegate 추가
        tableView.prefetchDataSource = self
        
        
        fetchBeer(of: currentPage)
    }
}

// UITableView DataSource, Delegate
extension BeerListViewController: UITableViewDataSourcePrefetching {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
    
    // prefetch - 보여질 row 을 받아준다.
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else { return } // 첫 번째 페이지는 처음에 가져오므로
        
        indexPaths.forEach {
            if ($0.row + 1) / 25 + 1 == currentPage { // 25 개씩 1 페이지이므로
                self.fetchBeer(of: currentPage)
            }
        }
    }
}

// Data Fetching
private extension BeerListViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
              dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil // dataTasks 안에 있는 url, 요청된 url 이 새롭게 요청된, url 에 없는 새로운 값이어야 한다.
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            switch response.statusCode {
            case (200...299): // success
                self.beerList += beers
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499): // client error
                print("""
                    ERROR: Client ERROR \(response.statusCode)
                    Response: \(response)
                """)
            case (500...599): // server error
                print("""
                    ERROR: Server ERROR \(response.statusCode)
                    Response: \(response)
                """)
            default:
                print("""
                    ERROR: \(response.statusCode)
                    Response: \(response)
                """)
            }
        }
        dataTask.resume() // 반드시 해주어야 한다.
        dataTasks.append(dataTask) // 한 번 실행되었던 작업에 대해서 추가해준다.
    }
}
