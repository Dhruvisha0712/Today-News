//
//  HomeViewController.swift
//  Today News
//
//  Created by Nandan on 27/03/24.
//

import UIKit
import Toast
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var siddeViewHideBtn: UIButton!
    @IBOutlet weak var newsTblView: UITableView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideViewWidth: NSLayoutConstraint!
    
    let defaults = UserDefaults.standard
    var newsDataManager = NewsDataManager()
    
    var newsArticles = [Article]()
    var selectedArticle: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        if !defaults.bool(forKey: "loginOrNot") {
            self.performSegue(withIdentifier: Constants.HomeToLoginSegue, sender: self)
        }
        
        sideView.isHidden = true
        sideViewWidth.constant = 0
        siddeViewHideBtn.isHidden = true
        
        let email = defaults.string(forKey: "email")
        emailLbl.text = email

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.bool(forKey: "loginOrNot") {
            newsTblView.delegate = self
            newsTblView.dataSource = self
            newsTblView.register(UINib(nibName: Constants.newsTableViewCellNibName, bundle: nil), forCellReuseIdentifier: Constants.newsCellReuseId)
            
            newsTblView.rowHeight = UITableView.automaticDimension
            newsTblView.estimatedRowHeight = 100
            
            newsDataManager.delegate = self
            newsDataManager.getNewsData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? NewsDetailsViewController {
            destinationViewController.article = selectedArticle
        }
    }
    
    func showSideMenu() {
        // Animate side menu into view
        UIView.animate(withDuration: 0.3) {
            self.sideView.isHidden = false
            self.sideViewWidth.constant = 200
            self.siddeViewHideBtn.isHidden = false
        }
    }

    func hideSideMenu() {
        // Animate side menu out of view
        UIView.animate(withDuration: 0.3) {
            self.sideView.isHidden = true
            self.sideViewWidth.constant = 0
            self.siddeViewHideBtn.isHidden = true
        }
    }
    
    @IBAction func sideViewHidePressed(_ sender: UIButton) {
        hideSideMenu()
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            // Perform logout actions
            UserDefaults.standard.set(false, forKey: "loginOrNot")
            
            // Perform segue after logout
            self.performSegue(withIdentifier: Constants.HomeToLoginSegue, sender: self)
        }
        alert.addAction(logoutAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sideBtnPressed(_ sender: UIButton) {
        showSideMenu()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticle = newsArticles[indexPath.row]
        self.performSegue(withIdentifier: Constants.homeToNewsSegue, sender: self)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCellReuseId, for: indexPath) as! NewsTableViewCell
        
        let article = newsArticles[indexPath.row]
        
        let url = URL(string: article.urlToImage ?? "")
        cell.newsImgView.sd_setImage(with: url)
        
        cell.newsTitleLbl.text = article.title
        
        return cell
    }

}

extension HomeViewController: NewsDataManagerDelegate {
    func updateUIOnSuccess(articles: [Article]) {
        print("here: \(articles)")
        newsArticles = articles
        newsTblView.reloadData()
    }
    
    func updateUIOnfail() {
        view.makeToast("Something went wrong!")
    }
}
