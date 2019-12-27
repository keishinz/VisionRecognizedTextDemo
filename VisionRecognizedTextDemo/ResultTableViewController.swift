//
//  ResultTableViewController.swift
//  VisionRecognizedTextDemo
//
//  Created by Keishin CHOU on 2019/12/26.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import Vision

import Amplify

class ResultTableViewController: UITableViewController {
    
    var observations = [VNRecognizedTextObservation]()

    var resultsArray = [String]()
    var resultString = String()
    var translationString = String()
    
    var totalResults = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for observation in observations {
            let bestObservation = observation.topCandidates(1).first
            guard let string = bestObservation?.string else { return }
//            results[0].append(string)
//            resultString.append(string + " ")
            resultsArray.append(string)
            resultString += (string + " ")
        }
        
        for _ in 0 ... 1 {
            totalResults.append([])
        }
        totalResults[0] = resultsArray
        totalResults[1] = [resultString]
        
        print(resultString)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Translate", style: .plain, target: self, action: #selector(translateResult))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return totalResults[section].count
        
        switch section {
        case 0:
            return resultsArray.count
            
        case 1:
            return 1
        
        default:
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = totalResults[indexPath.section][indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @objc func translateResult() {
        translateText(text: resultString)
    }
    
    func translateText(text:String) {
        _ = Amplify.Predictions.convert(textToTranslate: text,
                                        language: .english,
                                        targetLanguage: .japanese,
                                        options: PredictionsTranslateTextRequest.Options(),
                                        listener: { (event) in
            switch event {
                case .completed(let result):
                    print(result.text)
//                    self.translationString = result.text
                    DispatchQueue.main.async {
                        let newViewController = TranslateViewController()
                        newViewController.translation = result.text
                        print(result.text)
                        self.navigationController?.pushViewController(newViewController, animated: true)
                }
                
                default:
                    print("")
                }
        })

    }
    
}
