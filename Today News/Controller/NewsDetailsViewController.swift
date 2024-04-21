//
//  NewsDetailsViewController.swift
//  Today News
//
//  Created by Nandan on 27/03/24.
//

import UIKit
import SDWebImage

class NewsDetailsViewController: UIViewController {

    var article: Article?
    
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var articleTitleLbl: UILabel!
    @IBOutlet weak var articleDescLbl: UILabel!
    @IBOutlet weak var articleImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("selected article: \(article)")
        if let url = URL(string: article?.urlToImage ?? "") {
            articleImgView.sd_setImage(with: url)
        }
        
        articleImgView.layer.cornerRadius = 10
        articleImgView.layer.shadowColor = UIColor.lightGray.cgColor
        articleImgView.layer.shadowOpacity = 0.5
        articleImgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        articleImgView.layer.shadowRadius = 4
        
        articleTitleLbl.text = article?.title
        articleDescLbl.text = article?.description
        authorLbl.text = article?.author
    }

    @IBAction func backPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
