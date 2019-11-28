//
//  NoteEditViewController.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 08/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class NoteEditViewController: UIViewController {

    var databaseLink : String {
        return "https://purple-team-sprint2.firebaseio.com/notes"
    }
    
//    let imgApiKey = "a77620c09e87be8b738f172f96f160d3"
    
//    var imgUploadLink : String {
//        return "https://api.imgbb.com/1/upload?key=\(imgApiKey)"
//    }
    
    var indexOfNote: Int = 0
    var textView:UITextView!
    var imageView : UIImageView!
    var picker : UIImagePickerController!
    var spinner : UIActivityIndicatorView!
    var delegate : NoteEditDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide
        
        textView = UITextView()
        textView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView!)
        
        let addImageButton = UIButton()
        addImageButton.setImage(UIImage(named: "plus"), for: .normal)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        view.addSubview(addImageButton)
        
        imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if (indexOfNote == delegate!.images.count) {
            imageView.image = UIImage(named: "graySquare")
        } else {
            imageView.image = delegate!.images[indexOfNote]
        }
        
        view.addSubview(imageView)
        
        
//        spinner = UIActivityIndicatorView()
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        imageView.addSubview(spinner)
//        spinner.isHidden = true
//        spinner.hidesWhenStopped = true
//        spinner.startAnimating()
        
        
        let imageBarHeight : CGFloat = 100
        
        textView?.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        textView?.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        textView?.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: imageBarHeight).isActive = true
        textView?.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        addImageButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8).isActive = true
        addImageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addImageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addImageButton.centerYAnchor.constraint(equalTo: safeArea.topAnchor, constant: imageBarHeight / 2).isActive = true
        
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: safeArea.topAnchor, constant: imageBarHeight / 2).isActive = true
        
//        spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
//        spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
//        spinner.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        spinner.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let barItemSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = barItemSave
        
        if ((delegate!.notes.count > 0) && (delegate!.notes.count != indexOfNote)) {
            textView?.text = delegate!.notes[indexOfNote].text
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if indexOfNote != delegate?.notes.count {
            delegate?.downloadImage(link: (self.delegate?.notes[indexOfNote].url)!, completion: { image in
                self.imageView.image = image
            })
        }
    }
    
    @objc
    func saveButtonTapped() {
        var note : Note!
        if (!textView!.text.isEmpty) {
            if (delegate!.notes.count == indexOfNote)
            {
                note = Note()
                delegate!.notes.append(note)
                delegate!.images.append(imageView.image)
            } else {
                note = delegate!.notes[indexOfNote]
                delegate?.images[indexOfNote] = imageView.image
            }
        }
        note.text = textView?.text ?? ""
        delegate?.uploadImage(image : imageView.image!, completion: { urlStr in
            note.url = urlStr
            self.uploadNote(note)
            self.navigationController?.popViewController(animated: true)
            self.delegate?.tableView.reloadData()
        })
        
    }
    
    @objc
    func addImageButtonTapped() {
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary;
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    
}

extension NoteEditViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            let selectedImage : UIImage = image // вот картинка
            self.imageView.image = selectedImage
//            spinner.stopAnimati/ng()
            picker.dismiss(animated: true, completion: nil)
        }
    }
}


class ImageURL : Decodable {
    var url : String = ""
}

class ImageResponce : Decodable {
    var data : ImageURL = ImageURL()
}

extension NoteEditViewController {
    func uploadNote(_ note: Note, completion: () -> Void = { }) {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(databaseLink)/\(indexOfNote).json")!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder.init()
        do {
            let data = try encoder.encode(note)
            print(String(data: data, encoding: .utf8)!)
            request.httpBody = data
            let task = session.uploadTask(with: request, from: data) {_,_,_ in
                
            }
            task.resume()
        } catch {
            print(error)
        }
    }
}
