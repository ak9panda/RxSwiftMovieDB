//
//  MovieTableViewCell.swift
//  GithubRepo
//
//  Created by Aung Kyaw Phyo on 11/29/21.
//

import UIKit
import RxSwift
import RxCocoa

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReleaseYear: UILabel!
    @IBOutlet weak var lblPopularity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    static var identifer: String {
        String(describing: self)
    }
    
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func setUp(viewModel: MovieCellViewModel) {
        disposeBag.insert(
            viewModel.posterImage.drive(imgPoster.rx.image),
            viewModel.title.drive(lblTitle.rx.text),
            viewModel.ReleaseYear.drive(lblReleaseYear.rx.text),
            viewModel.popularity.drive(lblReleaseYear.rx.text),
            viewModel.overview.drive(lblDescription.rx.text)
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
