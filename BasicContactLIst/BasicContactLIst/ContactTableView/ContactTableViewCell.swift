//
//  ContactTableViewCell.swift
//  BasicContactLIst
//
//  Created by Krishna on 26/05/23.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContactDetail(contact: Contact) {
        print(contact.name)
        contactName.text = contact.name
    }
    
}
