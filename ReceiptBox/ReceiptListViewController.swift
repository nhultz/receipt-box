//
//  MainViewController.swift
//  ReceiptBox
//
//  Created by Nick Hultz on 11/11/17.
//  Copyright © 2017 nhultz. All rights reserved.
//

import UIKit
import AVFoundation


class ReceiptListViewController: UIViewController {

    @IBOutlet weak var viewModel: ReceiptViewModel!
    @IBOutlet weak var receiptTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.reloadSections = { [weak self] (section: Int) in
            self?.receiptTableView.beginUpdates()
            self?.receiptTableView.reloadSections([section], with: .fade)
            self?.receiptTableView.endUpdates()
        }

        receiptTableView.dataSource = viewModel
        receiptTableView.delegate = viewModel

        receiptTableView.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
    }

}

extension ReceiptListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        AppPhotoAlbum.shared.save(image) { (localDeviceId) in
            print(localDeviceId ?? "No ID Returned")
        }

        dismiss(animated: true, completion: nil)
    }

    func launchCamera() {
        let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        if (deviceHasCamera) {
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch authStatus {
            case .authorized:
                showCameraPicker()
            case .denied:
                showAlertForCameraSettings()
            case .notDetermined:
                showAlertToPrimeForAccess()
            default:
                showAlertToPrimeForAccess()
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }

    func showCameraPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    func showAlertToPrimeForAccess() {
        let alertController = UIAlertController(title: "ReceiptBox Would Like To Access The Camera", message: "Please grant permission to use the Camera so that you can record receipts.", preferredStyle: .alert)
        let allowAction = UIAlertAction(title: "Allow", style: .default) { _ in
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.launchCamera()
                }
            })
        }
        alertController.addAction(allowAction)

        let declineAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
        alertController.addAction(declineAction)

        present(alertController, animated: true, completion: nil)
    }

    func showAlertForCameraSettings() {
        let alertController = UIAlertController(title: "ReceiptBox Would Like To Access The Camera", message: "Please grant permission to use the Camera so that you can record receipts.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Open Settings", style: .cancel) { _ in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

}
