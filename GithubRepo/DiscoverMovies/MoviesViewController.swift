//
//  MoviesViewController.swift
//  GithubRepo
//
//  Created by admin on 24/10/2021.
//

import UIKit
import RxSwift
import RxDataSources

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var btnRefresh: UIBarButtonItem!
    
    private let movieClient = MovieNetworkClient()
    
    private let disposeBag = DisposeBag()
    private let viewModel = MoviesViewModel()
    private let viewDidLoadSubject = PublishSubject<Void>()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Movies"
        
        moviesCollectionView.delegate = self
        
        setupCollectionViewBind()
        
        viewDidLoadSubject.onNext(())
        
    }
}

// MARK: - Setup tableview bind and observables
extension MoviesViewController {
    func setupCollectionViewBind() {
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<MoviesSection>(configureCell: {
            dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
            cell.setData(poster: item.poster_path!, service: ConfigServiceProvider())
            return cell
        })
        
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieHeaderCollectionReusableView.identifier, for: indexPath) as! MovieHeaderCollectionReusableView
            header.lblHeader.text = dataSource.sectionModels[indexPath.section].header
            header.delegate = self
            return header
        }
        
        disposeBag.insert(
            viewModel
                .dataSource
                .asObservable()
                .bind(to: moviesCollectionView.rx.items(dataSource: dataSource)),
            
            moviesCollectionView
                .rx
                .modelSelected(MovieInfoResponse.self)
                .asObservable()
                .bind(to: viewModel.bindLoadMovieDetail),
            
            viewModel
                .bindLoadMovies(to: viewDidLoadSubject),
            
            viewModel
                .dataSource
                .map{ !($0.count > 0) }
                .drive(moviesCollectionView.rx.isHidden),
            
            viewModel
                .movieDetail
                .drive(onNext: { [weak self] model in
                    self?.presentMovieDetail(with: model)
                }),
            
            btnRefresh.rx.tap
                .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
                .subscribe { _ in
                    print("refresh button tap")
                }
        )
    }
}

// MARK: - Get tap action from header cell
extension MoviesViewController: SeemoreActionFromHeaderProtocol {
    func seemoreBtnTap(with category: String) {
        self.pushMovieList(category: category)
    }
}

// MARK: - Navigation
extension MoviesViewController {
    func presentMovieDetail(with model: MovieInfoResponse) {
        let detailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController

        let detailViewModel = MovieDetailViewModel(model: model)
        detailVC.setup(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func pushMovieList(category: String) {
        let movieListVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
        Observable.just(category)
            .compactMap { $0 }
            .bind(to: movieListVC.category)
            .disposed(by: disposeBag)
        self.navigationController?.pushViewController(movieListVC, animated: true)
    }
}

// MARK: - Collection view flow layout
extension MoviesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}
