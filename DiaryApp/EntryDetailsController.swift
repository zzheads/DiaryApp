//
//  EntryDetailsController.swift
//  DiaryApp
//
//  Created by Alexey Papin on 10.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import UIKit

protocol EntryDetailsControllerDelegate: class {
    func entryDetailsController(didFinishModifyEntry entry: Entry, at indexPath: IndexPath)
}

class EntryDetailsController: UIViewController {
    static let nibName = "\(EntryDetailsController.self)"
    var entry: Entry? = nil
    var indexPath: IndexPath? = nil
    var delegate: EntryDetailsControllerDelegate?
    
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
    
    @IBAction func addLocationPressed() {
        let manager = LocationManager()
        guard
            let location = manager.location,
            let entry = self.entry
            else {
                print("Something is nil, entry=\(self.entry), location=\(manager.location)")
                return
        }
        entry.location = Location(clLocation: location) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let placemark = placemarks.first
                else {
                return
            }
            self.locationButton.isHidden = true
            self.locationLabel.text = placemark.myDescription
            self.locationLabel.isHidden = false
        }
    }
    @IBAction func badMoodPressed() {
        guard let entry = self.entry else {
            return
        }
        entry.mood = .Bad
        self.moodBadgeView.image = Mood.Bad.badgeImage
    }
    @IBAction func averageMoodPressed() {
        guard let entry = self.entry else {
            return
        }
        entry.mood = .Average
        self.moodBadgeView.image = Mood.Average.badgeImage
    }
    @IBAction func goodMoodPressed() {
        guard let entry = self.entry else {
            return
        }
        entry.mood = .Happy
        self.moodBadgeView.image = Mood.Happy.badgeImage
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
        self.entry = entry
        if let photo = entry.photo {
            self.photoImage.image = photo.image
        } else {
            self.photoImage.image = #imageLiteral(resourceName: "icn_picture")
        }
        self.moodBadgeView.image = entry.mood.badgeImage
        if let location = entry.location {
            self.locationButton.setTitle(location.placemark, for: .normal)
        } else {
            self.locationButton.setTitle("Add location", for: .normal)
        }
        self.titleLabel.text = entry.date.formattedString
        self.textView.text = entry.text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoImage.makeCircle()
        self.locationLabel.isHidden = true
        self.locationButton.isHidden = false
        self.selectPhotoButton.backgroundColor = .clear
        self.selectPhotoButton.setTitleColor(.clear, for: .normal)
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
        let text = self.textView.text,
        let entry = self.entry
        else {
            print("SOMETHING WRONG! delegate=\(self.delegate), indexPath=\(self.indexPath), text=\(self.textView.text), entry=\(self.entry)")
            getBack()
            return
        }
        entry.text = text
        delegate.entryDetailsController(didFinishModifyEntry: entry, at: indexPath)
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
        if let entry = self.entry {
            entry.photo = Photo(image: image)
        }
        self.mediaPickerManager.dismissImagePickerController(animated: true) {
            self.photoImage.image = image
        }
    }
}
