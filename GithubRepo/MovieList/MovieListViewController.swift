//
//  MovieListViewController.swift
//  GithubRepo
//
//  Created by admin on 25/11/2021.
//

import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var MovieListTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var viewModel: MovieListViewModelType?
    private let viewDidLoadSubject = PublishSubject<Void>()
    
    var didSelectMovie: (MovieDetailViewModelProtocol) -> ()  = { _ in }
    
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = category
        self.viewModel = MovieListViewModel(category: category)
        setupTableViewBind()
        setupObservables()
        
        viewDidLoadSubject.onNext(())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = MovieListTableView.indexPathForSelectedRow {
            MovieListTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}

// MARK: - Setup tableview bind and observalbes
extension MovieListViewController {
    
    func setupTableViewBind() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        disposeBag.insert(
            viewModel
                .dataSource
                .asObservable()
                .bind(to:
                        MovieListTableView.rx.items(cellIdentifier: MovieTableViewCell.identifer,
                                                    cellType: MovieTableViewCell.self)) { (_, movie, cell) in
                    let viewModel = MovieCellViewModel(model: movie, service: ConfigServiceProvider())
                    cell.setUp(viewModel: viewModel)
                },
            
            MovieListTableView
                .rx
                .modelSelected(MovieInfoResponse.self)
                .asObservable()
                .bind(to: viewModel.bindLoadMovieDetail),
            
            Observable.just(150.0)
                .bind(to: MovieListTableView.rx.rowHeight)
        )
    }
    
    func setupObservables() {
        guard let viewModel = self.viewModel else {
            return
        }
        disposeBag.insert(
            viewModel
                .bindLoadFirstPage(to: viewDidLoadSubject),
            
            viewModel
                .movieDetail
                .drive(onNext: { [weak self] movie in
                    let detailViewModel = MovieDetailViewModel(model: movie)
                    self?.didSelectMovie(detailViewModel)
                }),
            
            viewModel
                .dataSource
                .map{ !($0.count > 0) }
                .drive(MovieListTableView.rx.isHidden)
        )
    }
}
