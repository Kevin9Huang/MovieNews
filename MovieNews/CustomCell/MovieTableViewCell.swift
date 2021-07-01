//
//  MovieTableViewCell.swift
//  MovieNews
//
//  Created by Kevin Huang on 01/07/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directedByLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public var cellMovie: MovieModel! {
        didSet {
            self.titleLabel.text = cellMovie.title
            self.directedByLabel.text = cellMovie.director
            self.yearLabel.text = cellMovie.release_date
            self.descriptionLabel.text = cellMovie.description
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func prepareForReuse() {
        titleLabel.text = ""
        directedByLabel.text = ""
        yearLabel.text = ""
        descriptionLabel.text = ""
    }
    
}
