//
//  PostsTableViewController.swift
//  Snapchat Camera Lab
//
//  Created by Paige Plander on 3/9/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD

class PostsTableViewController: UIViewController {

    enum Constants {
        static let postBackgroundColor = UIColor.black
        static let postPhotoSize = UIScreen.main.bounds
    }
    
    var loadedImagesById: [String:UIImage] = [:]
    
    let currentUser = CurrentUser()
    
    /// Table view holding all posts from each thread
    @IBOutlet weak var postTableView: UITableView!
    
    /// Button that displays the image of the post selected by the user
    var postImageViewButton: UIButton = {
        var button = UIButton(frame: Constants.postPhotoSize)
        button.backgroundColor = Constants.postBackgroundColor
        // since we only want the button to appear when the user taps a cell, hide the button until a cell is tapped
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        
        // add the button that displays the selected post's image to this view
        view.addSubview(postImageViewButton)
        
        // By adding a target here, every time the button is pressed, hidePostImage will be called 
        // (this is the programmatic way of adding an IBAction to a button)
        postImageViewButton.addTarget(self, action: #selector(self.hidePostImage(sender:)), for: UIControlEvents.touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postTableView.reloadData()
        
        // TO DO:
        updateData()
    }
    
    func updateData() {
        getPosts(user: currentUser) { (posts) in
            if let postsCopy = posts {
                clearThreads()
                for post in postsCopy {
                    
                    addPostToThread(post: post)
                    if !post.read {
                        getDataFromPath(path: post.postImagePath, completion: { (data) in
                            if let data = data {
                                if let image = UIImage(data: data) {
                                    self.loadedImagesById[post.postId] = image
                                    
                                }
                            }
                            else {
                                
                                print("error getting post")
                            }
                        })
                    }
                }
                self.postTableView.reloadData()
            }
        }
    }
    
    // MARK: Custom methods (relating to UI)
    @objc func hidePostImage(sender: UIButton) {
        sender.isHidden = true
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    func presentPostImage(forPost post: Post) {
        if let image = loadedImagesById[post.postId] {
            postImageViewButton.isHidden = false
            postImageViewButton.setImage(image, for: .normal)
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
        } else {
            _ = MBProgressHUD.showAdded(to: view, animated: true)
            getDataFromPath(path: post.postImagePath, completion: { (data) in
                if let data = data {
                    let image = UIImage(data: data)
                    self.loadedImagesById[post.postId] = image
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.postImageViewButton.isHidden = false
                    self.postImageViewButton.setImage(image, for: .normal)
                    // hide the navigation and tab bar for presentation
                    self.navigationController?.navigationBar.isHidden = true
                    self.tabBarController?.tabBar.isHidden = true
                }
            })
        }
        

    }

}

extension PostsTableViewController: UITableViewDataSource {
    
    // MARK: Table view delegate and datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return threadNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return threadNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostsTableViewCell
        if let post = getPostFromIndexPath(indexPath: indexPath) {
            if post.read {
                cell.readImageView.image = UIImage(named: "read")
            }
            else {
                cell.readImageView.image = UIImage(named: "unread")
            }
            cell.usernameLabel.text = post.username
            cell.timeElapsedLabel.text = post.getTimeElapsedString()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let threadName = threadNames[section]
        return threads[threadName]!.count
    }
    
}

extension PostsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let post = getPostFromIndexPath(indexPath: indexPath), !post.read {
            presentPostImage(forPost: post)
            post.read = true
            currentUser.addNewReadPost(postID: post.postId)
            // reload the cell that the user tapped so the unread/read image updates
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
