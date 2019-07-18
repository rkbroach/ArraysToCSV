//
//  ViewController.swift
//  ArraysToCSV
//
//  Created by Rohan Kevin Broach on 7/10/19.
//  Copyright © 2019 rkbroach. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var taskArr = [Task]()
    var task: Task!
    
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        createCSV()
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setSubject("Your csv file")
            mailComposer.setMessageBody("YAYAYAYAYAYAYA", isHTML: false)
            mailComposer.setToRecipients(["rkbroach@gmail.com"])
            
            UIApplication.shared.keyWindow?.rootViewController?.present(mailComposer, animated: true)
            
            
            let imageData: NSData = UIImagePNGRepresentation(imageView.image)!
            mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "imageName.png")

            
            guard let filePath = Bundle.main.path(forResource: "Tasks", ofType: "csv") else {
                return
            }
            let url = URL(fileURLWithPath: filePath)
            
            do {
                let attachmentData = try Data(contentsOf: url)
                mailComposer.addAttachmentData(attachmentData, mimeType: "application/csv", fileName: "Tasks")
                mailComposer.mailComposeDelegate = self
                
                //self.present(mailComposer, animated: true, completion: nil)

                
//                self.dismiss(animated: true, completion: {
//                    self.present(mailComposer, animated: true, completion: nil)
//                    })

//                self dismissViewControllerAnimated:YES completion:^{
//                    self presentViewController:crashMailAlertController animated:YES completion:nil
//                    }
                
                //self.present(mailComposer, animated: true, completion: nil)
                
                
            } catch let error {
                print("We have encountered error \(error.localizedDescription)")
            }
            
        } else {
            print("Email is not configured in settings app or we are not able to send an email")
        }
    }
    
        
 
        
        //MARK:- MailcomposerDelegate
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            
            //controller.dismiss(animated: true, completion: nil)
            controller.dismiss(animated: true, completion: {
                self.present(controller, animated: true, completion: nil)
            })
            
            
            switch result {
            case .cancelled:
                print("User cancelled")
                break
                
            case .saved:
                print("Mail is saved by user")
                break
                
            case .sent:
                print("Mail is sent successfully")
                break
                
            case .failed:
                print("Sending mail is failed")
                break
            default:
                break
            }
            
            
            
        }
    
    
    // MARK: CSV file creation
    func createCSV() -> Void {
        let fileName = "Tasks.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Date,Task Name,Time Started,Time Ended\n"
        
        for task in taskArr {
            let newLine = "\(task.date),\(task.name),\(task.startTime),\(task.endTime)\n"
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        print(path ?? "not found")
    }
    
    // End of Class
}
