//
//  MovieHeaderCollectionReusableView.swift
//  GithubRepo
//
//  Created by admin on 27/10/2021.
//

import UIKit
import RxSwift

// send tap data to movie view with protocol
protocol SeemoreActionFromHeaderProtocol {
    func seemoreBtnTap(with category: String)
}

class MovieHeaderCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnSeemore: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var delegate: SeemoreActionFromHeaderProtocol? = nil
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        btnSeemore.rx.tap
            .throttle(.microseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.delegate?.seemoreBtnTap(with: self?.lblHeader.text ?? "")
            }
            .disposed(by: disposeBag)
    }
    
}
