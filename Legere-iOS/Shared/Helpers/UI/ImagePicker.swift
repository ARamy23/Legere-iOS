//
//  ImagePicker.swift
//  NearHero
//
//  Created by Mohamed Matloub on 3/3/18.
//  Copyright © 2018 Atia Mohamedein. All rights reserved.
//

import Foundation
import RxSwift

class ImagePicker: RxMediaPickerDelegate {
	    var picker: RxMediaPicker!
		weak var viewController: UIViewController?
	    let disposeBag = DisposeBag()

	init(viewController: UIViewController) {
		self.viewController = viewController
		picker = RxMediaPicker(delegate: self)

	}
    func pickImageWith(title: String, message: String, completion :@escaping (_ image: UIImage) -> Void) {

		let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {[weak self] (_) in
//            guard let strongSelf = self else {
//                return
//            }
//            strongSelf.picker.selectImage(source: .camera, editable: false).subscribe(onNext: { (image1, _) in
//                completion(image1)
//            }).disposed(by: strongSelf.disposeBag)
//        }))

		actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {[weak self] (_) in
			guard let strongSelf = self else {
				return
			}
			strongSelf.picker.selectImage(source: .photoLibrary, editable: false).do(onNext: { (image1, _) in
				completion(image1)
			}, onError: { (error) in
				 print(error)
			}, onCompleted: {

			}).subscribe().disposed(by: strongSelf.disposeBag)
		}))
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
		}))
		viewController?.present(actionSheet, animated: true, completion: nil)
	}

	func dismiss(picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}

	func present(picker: UIImagePickerController) {
		viewController?.present(picker, animated: true, completion: nil)
	}

}
