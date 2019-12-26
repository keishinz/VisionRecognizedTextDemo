//
//  TranslateViewController.swift
//  VisionRecognizedTextDemo
//
//  Created by Keishin CHOU on 2019/12/26.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {
    
    var translation: String?
    let translateLabel = UILabel()
//    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        
//        translateLabel.sizeToFit();
        self.view.addSubview(translateLabel)
        translateLabel.translatesAutoresizingMaskIntoConstraints = false
        translateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        translateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        translateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        translateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        
        print(translation!)
        translateLabel.text = translation
        translateLabel.textColor = .darkText
        translateLabel.numberOfLines = 0
        translateLabel.lineBreakMode = .byWordWrapping
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
