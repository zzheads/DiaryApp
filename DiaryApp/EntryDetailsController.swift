//
//  EntryDetailsController.swift
//  DiaryApp
//
//  Created by Alexey Papin on 10.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import CoreData

protocol EntryDetailsControllerDelegate: class {
    func entryDetailsController(didFinishModifyEntry entryWrapper: EntryWrapper, at indexPath: IndexPath)
}

class EntryDetailsController: UIViewController {
    static let nibName = "\(EntryDetailsController.self)"

    let entryWrapper = EntryWrapper()
    var indexPath: IndexPath? = nil
    var delegate: EntryDetailsControllerDelegate? = nil
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var averageButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodBadgeView: UIImageView!
    @IBOutlet weak var locationView: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var changeDateButton: UIButton!
    @IBOutlet weak var newDateTextField: UITextField!
    @IBAction func changeDatePressed() {
    }
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    @IBAction func selectPhotoPressed() {
        self.mediaPickerManager.presentImagePickerController(animated: true)
    }
    
    class func loadFromNib(entry: Entry, indexPath: IndexPath) -> EntryDetailsController{
        let controller = UINib(nibName: EntryDetailsController.nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EntryDetailsController
        controller.setupWith(entry: entry)
        controller.indexPath = indexPath
        return controller
    }
    
    func setupWith(entry: Entry) {
        self.entryWrapper.updateWith(entry: entry)
        
        self.photoImage.image = entry.photo
        self.moodBadgeView.image = entry.mood.badgeImage
        self.titleLabel.text = entry.date.formattedString
        self.textView.text = entry.text
        
        guard let placemark = entry.placemark else {
            return
        }
        self.locationButton.isHidden = true
        self.locationLabel.isHidden = false
        self.locationLabel.text = placemark
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoImage.makeCircle()
        self.locationLabel.isHidden = true
        self.locationButton.isHidden = false
        self.selectPhotoButton.backgroundColor = .clear
        self.selectPhotoButton.setTitleColor(.clear, for: .normal)
        self.changeDateButton.backgroundColor = .clear
        self.changeDateButton.setTitleColor(.clear, for: .normal)
        self.changeDateButton.addTarget(self, action: #selector(self.startEditDate), for: .touchUpInside)
        self.newDateTextField.addTarget(self, action: #selector(self.endEditDate), for: UIControlEvents.editingDidEnd)
        endEditDate()
        self.badButton.addTarget(self, action: #selector(self.moodPressed(sender:)), for: .touchUpInside)
        self.averageButton.addTarget(self, action: #selector(self.moodPressed(sender:)), for: .touchUpInside)
        self.goodButton.addTarget(self, action: #selector(self.moodPressed(sender:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Diary Entry Details"
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelEntryDetails(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveEntryDetails(sender:)))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

extension EntryDetailsController {
    func saveEntryDetails(sender: UIBarButtonItem) {
        guard
        let delegate = self.delegate,
        let indexPath = self.indexPath,
        let text = self.textView.text
        else {
            print("SOMETHING WRONG! delegate=\(self.delegate), indexPath=\(self.indexPath), text=\(self.textView.text), entryWrapper=\(self.entryWrapper)")
            getBack()
            return
        }
        self.entryWrapper.text = text
        delegate.entryDetailsController(didFinishModifyEntry: self.entryWrapper, at: indexPath)
        getBack()
    }
    
    func cancelEntryDetails(sender: UIBarButtonItem) {
        getBack()
    }
    
    private func getBack() {
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
}

extension EntryDetailsController: MediaPickerManagerDelegate {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        self.entryWrapper.photo = image
        self.mediaPickerManager.dismissImagePickerController(animated: true) {
            self.photoImage.image = image
        }
    }
}

// MARK: Handle events here (buttons pressed etc)

extension EntryDetailsController {
    @objc fileprivate func startEditDate() {
        self.newDateTextField.placeholder = "Enter date DD/MM/YYYY"
        self.newDateTextField.isHidden = false
        self.changeDateButton.isHidden = true
        self.titleLabel.isHidden = true
        self.newDateTextField.becomeFirstResponder()
    }
    
    @objc fileprivate func endEditDate() {
        self.newDateTextField.isHidden = true
        self.changeDateButton.isHidden = false
        self.titleLabel.isHidden = false
        guard
        let newDate = self.newDateTextField.text?.formattedDate
            else {
                return
        }
        self.entryWrapper.date = newDate
        self.titleLabel.text = newDate.formattedString
    }
    
    @IBAction func addLocationPressed() {
        let manager = LocationManager.sharedInstance
        guard
            let location = manager.location
            else {
                print("Location=\(manager.location), location services enabled=\(CLLocationManager.locationServicesEnabled())")
                return
        }
        if (!manager.isAuthorized) {
            print("Authorization requested!")
            manager.requestAuthorization()
            print("Authorization answered?")
        }
        
        self.entryWrapper.location = location
        self.entryWrapper.setPlacemark { (placemark, error) in
            DispatchQueue.main.async {
                guard
                    let placemark = placemark
                    else {
                        return
                }
                self.locationButton.isHidden = true
                self.locationLabel.text = placemark
                self.locationLabel.isHidden = false
            }
        }
    }

    func moodPressed(sender: UIButton) {
        guard let titleButton = sender.title(for: .normal) else {
            return
        }
        let mood = Mood(rawValue: titleButton)
        self.entryWrapper.mood = mood
        self.moodBadgeView.image = mood.badgeImage
    }
}
