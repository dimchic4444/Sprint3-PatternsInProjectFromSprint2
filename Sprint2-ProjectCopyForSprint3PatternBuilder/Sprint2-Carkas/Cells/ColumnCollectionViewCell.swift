//
//  ColumnsCollectionViewCell.swift
//  Sprint2-Carkas
//
//  Created by Aleksey Shepelev on 12/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class ColumnCollectionViewCell: UICollectionViewCell {
    public static let reuseId = "ColumnsCollectionViewCellId"
    public let label = UILabel()
    public var title : String {
        get {
            return label.text ?? ""
        }
        set(newValue) {
            label.text = newValue
        }
    }
    
    var delegate: CollectionViewCellDelegate?
    
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    var id : Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("init")
        
        self.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: 50)
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.isHidden = false
        
        contentView.addSubview(label)
        
        layout.itemSize = CGSize(width: contentView.frame.maxX - 2 * MARGIN, height: 50)
        layout.minimumInteritemSpacing = MARGIN
        layout.minimumLineSpacing = MARGIN
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: layout)
        collectionView.frame = CGRect(x: 0, y: 50, width: contentView.frame.width, height:  contentView.frame.height - 50)
        collectionView.backgroundColor = .clear
        contentView.addSubview(collectionView)
        collectionView.register(CardsCollectionViewCell.self, forCellWithReuseIdentifier: CardsCollectionViewCell.reuseId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColumnCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == delegate?.data[id].cards.count)
        {
            let alertController = UIAlertController(title: "Добавление новой задачи", message: "Введите описание задачи", preferredStyle: .alert)
            alertController.addTextField { (textField) in textField.placeholder="Купить похавать собаке" }
            let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
            let addAction = UIAlertAction(title: "Добавить", style: .default) { (alert) in
                if let text = alertController.textFields![0].text {
                    if (!text.isEmpty) {
                        self.delegate?.addCard(withTitle: text, in: self.id)
//                        self.delegate?.data[self.id].cards.append(Card(name: text))
//                        collectionView.reloadData()
                    }
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            delegate?.present(alertController, animated: true, completion: nil)
        }
    }
}

extension ColumnCollectionViewCell: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (delegate?.data[id].cards.count)! + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardsCollectionViewCell.reuseId, for: indexPath) as! CardsCollectionViewCell
        if indexPath.row == collectionView.numberOfItems(inSection: collectionView.numberOfSections - 1) - 1 {
            cell.label.text = "Добавить карточку"
        } else {
            cell.label.text = delegate?.data[id].cards[indexPath.row].name
        }
        return cell
    }
}
