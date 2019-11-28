//
//  NoteScreenViewController.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 08/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, NoteEditDelegate {
    //MARK: Network
    
    let apiKey = "AIzaSyAr9aXlB6-WX91OrLpegXRGnJtfgMY9OtU"
    
    var databaseLink : String {
        return "https://purple-team-sprint2.firebaseio.com/notes.json?addr_token=\(apiKey)"
    }
    
    var session : URLSession!
    public var notes : [Note] = []
    public var images : [UIImage?] = []
    
    
    
    let tableView = UITableView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Notes", image: UIImage(named: "notes"), selectedImage: UIImage(named: "notes-selected"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getNotesNumber(completion: { notesNumber in
//            UserDefaults.standard.set(notesNumber, forKey: "notesNumber")
//        })
        
        view.backgroundColor = .white
        
        let barItemAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(itemPressed))
        navigationItem.rightBarButtonItem = barItemAdd
        
        let barItemEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(itemEdit))
        navigationItem.leftBarButtonItem = barItemEdit
        
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.reusedId)
        tableView.reloadData()
        
        view.addSubview(tableView)
        
        
        let config : URLSessionConfiguration = .default
        session = URLSession(configuration: config)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadNotes(completion: { notes in
            print("Nodes downloaded")
            self.notes = notes
            self.images = []
            for _ in self.notes {
                self.images.append(UIImage(named: "graySquare"))
            }
            self.loadVisibleCellsImages()
//            if UserDefaults.standard.integer(forKey: "notesNumber") == 0 {
//                UserDefaults.standard.set(self.notes.count, forKey: "notesNumber")
//            }
            self.tableView.reloadData()
        })
    }
    
    private func loadVisibleCellsImages() {
        for cell in tableView.visibleCells {
            let indexPath = tableView.indexPath(for: cell)!
            guard let url = self.notes[indexPath.row].url else { continue }
            downloadImage(link: url, completion: { image in
                self.images[indexPath.row] = image
//                cell.imageView?.image = image
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            })
        }
    }
    
    @objc
    func itemPressed() {
        let noteEditVC = NoteEditViewController()
        noteEditVC.delegate = self
        noteEditVC.indexOfNote = notes.count
        navigationController?.pushViewController(noteEditVC, animated: true)
    }
    
    @objc
    func itemEdit() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
}

extension NotesViewController: UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteEditVC = NoteEditViewController()
        noteEditVC.delegate = self
        noteEditVC.indexOfNote = indexPath.row
        navigationController?.pushViewController(noteEditVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            notes.remove(at: indexPath.row)
            images.remove(at: indexPath.row)
            
//            Запись массива заметок на сервер
            
            let session = URLSession.shared
            var request = URLRequest(url: URL(string: databaseLink)!)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder.init()
            do {
                let data = try encoder.encode(notes)
                print(String(data: data, encoding: .utf8)!)
                request.httpBody = data
                let task = session.uploadTask(with: request, from: data) {_,_,_ in
                    
                }
                task.resume()
            } catch {
                print("\(error) Заметка не удалилась!!!!!!")
            }
            
//            end Запись массива заметок на сервер
            
            
            
            title = "\(notes.count) notes"
            self.tableView.endUpdates()
            tableView.reloadData()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadVisibleCellsImages()
    }
    
}


extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.reusedId, for: indexPath) as! NotesTableViewCell
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text
        cell.spinner.center = CGPoint(x: cell.imageView!.center.x - 15.0, y: cell.imageView!.center.y)
        cell.spinner.startAnimating()
        if let image = images[indexPath.row] {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(named: "graySquare")
        }
        cell.spinner.stopAnimating()
        cell.imageLink = note.url!
        return cell
    }
    
    
}

class ImageData : Decodable {
    var mediaLink : String
}

// MARK: Network
extension NotesViewController {
    
    func uploadImage(image : UIImage, completion: @escaping(String) -> Void) {
        let session = URLSession.shared
        let random = Int.random(in: 1...1000000000)
        let url = URL(string: "https://www.googleapis.com/upload/storage/v1/b/purple-team-sprint2.appspot.com/o?uploadType=media&name=imgName\(random)")
        var request = URLRequest(url: url!)
        let imgData = image.pngData()!
        request.httpMethod = "POST"
        request.addValue("image/png", forHTTPHeaderField: "Content-Type")
        request.addValue("\(imgData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = imgData
        let task = session.dataTask(with: request) { (data,response,error) in
            do {
                let body = try JSONDecoder().decode(ImageData.self, from: data!)
                DispatchQueue.main.async {
//                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "notesNumber") + 1, forKey: "notesNumber")
//                    self.pushNotesNumber()
                    completion(body.mediaLink)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    func reloadNotes(completion:  @escaping([Note]) -> Void) {
        let url = URL(string: databaseLink)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120)
        let task = session.dataTask(with: request) { (data : Data?, response: URLResponse?, error : Error?) in
            do {
                let notes = try JSONDecoder().decode([Note].self, from: data!)
                DispatchQueue.main.async {
                    completion(notes)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func downloadImage(link: String, completion: @escaping(UIImage) -> Void) {
        let url = URL(string: link)
        print(url)
        let request = URLRequest(url: url!)
        let task = self.session.dataTask(with: request) { (data : Data?, response: URLResponse?, error : Error?) in
            guard let image = UIImage(data: data!) else { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
    
//    func getNotesNumber(completion:  @escaping(Int) -> Void) {
//        let url = URL(string: "https://purple-team-sprint2.firebaseio.com/number.json?addr_token=\(apiKey)")
//        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120)
//        let task = session.dataTask(with: request) { (data : Data?, response: URLResponse?, error : Error?) in
//            do {
//                let notesNumber = try JSONDecoder().decode(NotesNumber.self, from: data!)
//                DispatchQueue.main.async {
//                    completion(notesNumber.notesNumber)
//                }
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
//
//    func pushNotesNumber() {
//        let url = URL(string: "https://purple-team-sprint2.firebaseio.com/number.json?addr_token=\(apiKey)")
//        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120)
//        request.httpMethod = "POST"
//        let notesNumber = NotesNumber(notesNumber: UserDefaults.standard.integer(forKey: "notesNumber"))
//        do {
//            let task = try session.uploadTask(with: request, from: JSONEncoder().encode(notesNumber))
//            task.resume()
//        } catch {
//            print(error)
//        }
//    }
}


protocol NoteEditDelegate {
    var notes : [Note] { get set }
    var images : [UIImage?] { get set }
    var tableView : UITableView { get }
    func downloadImage(link: String, completion: @escaping(UIImage) -> Void)
    func uploadImage(image : UIImage, completion: @escaping(String) -> Void)
}
