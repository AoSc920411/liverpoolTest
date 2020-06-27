//
//  ProductCellTableViewCell.swift
//  LiverpoolTest
//
//  Created by Alan Omar Solano Campos on 27/06/20.
//  Copyright © 2020 Alan Omar Solano Campos. All rights reserved.
//

import UIKit

class ProductCellTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fill(record: Records?, tag: Int) {
        self.productTitle.text = record?.productDisplayName
        self.price.text = "\(record?.promoPrice ?? 0)"
        self.location.text = record?.productType
        self.productImage.tag = tag
        self.productImage.imgFromURLString(record?.lgImage, tag: tag)
    }
    
}

extension UIImageView {
    func imgFromURLString(_ urlString: String?, tag: Int) {
        guard let url = URL(string: urlString ?? "") else {return}
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (info, response, error) in
            if error != nil{ return }
            DispatchQueue.main.async {
            if self.tag == tag{
                guard let data = info else { return }
                self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
