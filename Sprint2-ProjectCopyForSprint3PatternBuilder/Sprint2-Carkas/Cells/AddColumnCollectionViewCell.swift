//
//  MenuTrelloViewController.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 11/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class AddColumnCollectionViewCell : UICollectionViewCell {
    var addColumnButton : UIButton!
    var delegate : CollectionViewCellDelegate?
    public static let reuseId = "AddColumnCollectionViewCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        addColumnButton = UIButton(type: .system)
        addColumnButton.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 50)
        addColumnButton.titleLabel?.textColor = .white
        addColumnButton.backgroundColor = UIColor(named: "LightGray")
        addColumnButton.setTitle("Добавить колонку", for: .normal)
        addColumnButton.titleLabel?.textAlignment = .center
        addColumnButton.tintColor = .black
        addColumnButton.addTarget(self, action: #selector(addColumnButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(addColumnButton)
    }
    
    @objc
    func addColumnButtonTapped() {
        let alertController = UIAlertController(title: "Добавление новой категории", message: "Введите название категории", preferredStyle: .alert)
        alertController.addTextField { (textField) in textField.placeholder = "В процессе" }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (alert) in
            if let text = alertController.textFields![0].text {
                if (!text.isEmpty) {
                    self.delegate?.addColumn(withTitle: text)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        delegate?.present(alertController, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
