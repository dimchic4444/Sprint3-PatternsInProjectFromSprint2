//
//  NoteScreenTableViewCell.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 11/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    public static let reusedId = "cellNote"
    var spinner : UIActivityIndicatorView!
    var imageLink : String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        textLabel?.lineBreakMode = .byTruncatingTail
        textLabel?.numberOfLines = 1
        imageView?.backgroundColor = .lightGray
       //  imageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView?.image = UIImage(named: "graySquare")
        spinner = UIActivityIndicatorView()
        spinner.frame.size = CGSize(width: 30, height: 30)
        imageView?.addSubview(spinner)
        spinner.hidesWhenStopped = true
//        spinner.startAnimating()
        
//        contentView.frame.size.height = 200
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
