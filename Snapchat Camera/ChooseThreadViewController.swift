//
//  ChooseThreadViewController.swift
//  snapChatProject
//
//  Created by Paige Plander on 3/8/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChooseThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /// Table view displaying the names of each thread
    @IBOutlet weak var threadTableView: UITableView!
    
    /// The image picked by the user from the image picker
    var chosenImage: UIImage?

    /// Displays the name of the thread that the user has selected
    @IBOutlet weak var chosenThreadLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        threadTableView.delegate = self
        threadTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    /// Posts the image selected from the image picker to the
    /// thread specified by the user
    ///
    /// - Parameter sender: The send button (blue arrow button)
    @IBAction func postToFeed(_ sender: UIButton) {
        if let threadName = chosenThreadLabel.text, threadName != "" {
            if let imageToPost = chosenImage {
                addPost(postImage: imageToPost, thread: threadName, username: (Auth.auth().currentUser?.displayName)!)
                performSegue(withIdentifier: "unwindToImagePicker", sender: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "No thread selected", message: "You must select a thread to post your snap to.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    // MARK: Tableview delegate and datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseThreadCell") as! ChooseThreadTableViewCell
        cell.threadNameLabel.text = threadNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threadNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenThreadLabel.text = threadNames[indexPath.row]
    }
}
