//
//  MovieDetailViewController.swift
//  GithubRepo
//
//  Created by admin on 31/10/2021.
//

import UIKit
import RxSwift

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imgMovieCover: UIImageView!
    @IBOutlet weak var imgMoviePoster: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblReleaseYear: UILabel!
    @IBOutlet weak var lblRuntime: UILabel!
    @IBOutlet weak var btnBackToHome: UIButton!
    
    var viewModel: MovieDetailViewModelProtocol?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservable()
        
        btnBackToHome.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func setup(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
    }
    
}

// MARK: - Observable setup
private extension MovieDetailViewController {
  func setupObservable() {
    guard let viewModel = viewModel else {
      assertionFailure("Missing view model")
      return
    }
    
    disposeBag.insert(
        viewModel.title.drive(lblMovieTitle.rx.text),
        viewModel.posterImage.drive(imgMoviePoster.rx.image),
        viewModel.backdropImage.drive(imgMovieCover.rx.image),
        viewModel.overview.drive(lblDetail.rx.text),
        viewModel.releaseYear.drive(lblReleaseYear.rx.text),
        viewModel.runtime.drive(lblRuntime.rx.text)
    )
  }
}
