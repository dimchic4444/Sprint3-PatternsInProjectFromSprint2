//
//  TasksViewController.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 08/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

let MARGIN : CGFloat = 10
let TITLE_LABEL_HEIGHT : CGFloat = 75
let boardId = "5dc3fef481303c440b972ac5"

struct Column {
    var name : String = ""
    var id : String = ""
    var cards : [Card] = []
    
    init(title : String) {
        self.name = title
    }
    
    init(title : String, id: String) {
        self.name = title
        self.id = id
    }
}

class TasksViewController: UIViewController{
    
    let layout = UICollectionViewFlowLayout()
    var columns : UICollectionView!
    var spinner : UIActivityIndicatorView!
    
    var data : [Column] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBarItem = UITabBarItem(title: "Tasks", image: UIImage(named: "tasks"), selectedImage: UIImage(named: "tasks-selected"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Purple")
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: TITLE_LABEL_HEIGHT))
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        titleLabel.text = "Tasks"
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        layout.itemSize = CGSize(width: view.frame.width * 0.7, height: view.frame.height - 2 * MARGIN - TITLE_LABEL_HEIGHT)
        layout.minimumInteritemSpacing = MARGIN
        layout.minimumLineSpacing = MARGIN
        layout.scrollDirection = .horizontal
        
        columns = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 2 * MARGIN, height: layout.itemSize.height), collectionViewLayout: layout)
        columns.center = CGPoint(x: view.center.x, y: view.center.y + TITLE_LABEL_HEIGHT / 2)
        columns.backgroundColor = UIColor(named: "Purple")
        view.addSubview(columns)
        
        columns.register(ColumnCollectionViewCell.self, forCellWithReuseIdentifier: ColumnCollectionViewCell.reuseId)
        columns.register(AddColumnCollectionViewCell.self, forCellWithReuseIdentifier: AddColumnCollectionViewCell.reuseId)
        
        columns.delegate = self
        columns.dataSource = self
        
        columns.allowsMultipleSelection = false
        
        
        spinner = UIActivityIndicatorView()
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
}




extension TasksViewController : UICollectionViewDelegate {
    
}

extension TasksViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == columns.numberOfItems(inSection: columns.numberOfSections - 1) - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddColumnCollectionViewCell.reuseId, for: indexPath) as! AddColumnCollectionViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColumnCollectionViewCell.reuseId, for: indexPath) as! ColumnCollectionViewCell
            cell.title = data[indexPath.row].name
            cell.id = indexPath.row
            cell.collectionView.reloadData()
            cell.delegate = self
            return cell
        }
    }
}

protocol CollectionViewCellDelegate {
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)
    func addColumn(withTitle title: String)
    func addCard(withTitle title: String, in listInd: Int)
    var data : [Column] { get set }
}

extension TasksViewController : CollectionViewCellDelegate {
    func addColumn(withTitle title: String) {
        createAndUploadList(name: title, completion: { () in
            self.loadData()
        })
    }
    
    func addCard(withTitle title: String, in listInd: Int) {
        createAndUploadCard(name: title, listInd: listInd, completion: { () in
            self.columns.reloadItems(at: [IndexPath(row: listInd, section: 0)])
        })
    }
}


//MARK: Network

class List: Codable {
    var id : String
    var name : String
}

class Card: Codable {
    var id : String
    var name : String
    
    init(name : String) {
        self.name = name
        self.id = ""
    }
}

extension TasksViewController {
    var listsLink : String {
        return "https://api.trello.com/1/boards/\(boardId)/lists?fields=id,name&key=\(apiKey)&token=\(token)"
    }
    
    func cardLink(listId : String) -> String {
        return "https://api.trello.com/1/lists/\(listId)/cards?fields=id,name&key=\(apiKey)&token=\(token)"
    }
    
    var token : String {
        return UserDefaults.standard.string(forKey: "token")!
    }
    
    func loadLists(completion: @escaping ([Column]) -> Void) {
        let session = URLSession.shared
        let request = URLRequest(url: URL(string: listsLink)!)
        
        let task = session.dataTask(with: request) { (data, resonse, error) in
            do {
                let lists = try JSONDecoder().decode([List].self, from: data!)
                DispatchQueue.main.async {
                    completion(lists.map({ Column(title: $0.name, id: $0.id) }))
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
                print(error)
            }
        }
        task.resume()
    }
    
    func loadCards(byLink link : String, completion: @escaping ([Card]) -> Void) {
        let session = URLSession.shared
        let request = URLRequest(url: URL(string: link)!)
        let task = session.dataTask(with: request) { (data, resonse, error) in
            do {
                let cards = try JSONDecoder().decode([Card].self, from: data!)
                DispatchQueue.main.async {
                    completion(cards)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
                print(error)
            }
        }
        task.resume()
    }
    
    func loadData() {
        columns.isHidden = true
        spinner.startAnimating()
        loadLists(completion: { (_ data: [Column]) in
            self.data = data
            self.columns.reloadData()
            for (i, list) in self.data.enumerated() {
                self.loadCards(byLink: self.cardLink(listId: list.id), completion: { (_ cards : [Card]) in
                    self.data[i].cards = cards
                    self.columns.reloadItems(at: [IndexPath(row: i, section: 0)])
                })
            }
            self.columns.reloadData()
            self.spinner.stopAnimating()
            self.columns.isHidden = false
        });
    }
    
    func createAndUploadList(name: String, completion: @escaping () -> Void) {
        let link = "https://api.trello.com/1/lists?name=\(name)&idBoard=\(boardId)&key=\(apiKey)&token=\(token)&pos=bottom"
        let session = URLSession.shared
        guard let url = URL(string: link) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
    
    func createAndUploadCard(name: String, listInd : Int, completion: @escaping () -> Void) {
        let link = "https://api.trello.com/1/cards?name=\(name)&idList=\(data[listInd].id)&key=\(apiKey)&token=\(token)"
        guard let url = URL(string: link) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.data[listInd].cards.append(Card(name: name))
                completion()
            }
        }
        task.resume()
    }
}
