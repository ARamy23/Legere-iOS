//
//  CreateArticleViewModel.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/19/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import RxSwift
import RxCocoa
import Promises

final class CreateArticleViewModel: BaseViewModel {
    var coverPhoto = BehaviorRelay<UIImage?>(value: nil)
    var title = BehaviorRelay<String>(value: "")
    var body = BehaviorRelay<String>(value: "")
    
    var picker: RxMediaPicker!
    
    override init(cache: CacheProtocol, router: RouterProtocol, network: NetworkProtocol) {
        super.init(cache: cache, router: router, network: network)
        title.accept(cache.getObject(String.self, key: .draftTitle) ?? "")
        body.accept(cache.getObject(String.self, key: .draftBody) ?? "")
        coverPhoto.accept(cache.getObject(String.self, key: .draftCoverPhoto)?.convertToUIImage())
        
        picker = RxMediaPicker(delegate: self)
    }
    
    func publish() {
        CreateArticleInteractor(title: title.value, body: body.value, coverPhoto: coverPhoto.value?.convertToBase64String(), base: baseInteractor).execute(Article.self).then { [weak self] article in
            guard let self = self else { return }
            self.cache.removeObject(key: .draftTitle)
            self.cache.removeObject(key: .draftBody)
            self.cache.removeObject(key: .draftCoverPhoto)
            self.title.accept("")
            self.body.accept("")
            self.coverPhoto.accept(nil)
            self.router.switchTabBar(to: .feed)
        }.catch(handleError)
    }
    
    fileprivate func takeAndUploadImage(pickedImage: (UIImage, UIImage?)) {
        let image: UIImage = (pickedImage.1 != nil) ? pickedImage.1! : pickedImage.0
        let base64String = image.convertToBase64String()
        self.cache.saveObject(base64String, key: .draftCoverPhoto)
        self.coverPhoto.accept(image)
    }
    
    func presentAlertForPhotoInput() {
        let cameraAction: (title: String, style: UIAlertAction.Style, action: () -> Void) = (title: "Camera", style: UIAlertAction.Style.default, {
            self.picker.takePhoto(device: .front, flashMode: .auto, editable: true).subscribe(onNext: self.takeAndUploadImage, onError: { (error) in
                self.router.alert(title: "Error", message: error.localizedDescription, actions: [("Ok", .default)])
            }).disposed(by: self.disposeBag)
        })
        
        let libraryAction: (title: String, style: UIAlertAction.Style, action: () -> Void) = (title: "Photo Library", style: UIAlertAction.Style.default, {
            self.picker.selectImage(source: .photoLibrary, editable: true).subscribe(onNext: self.takeAndUploadImage, onError: { error in
                self.router.alert(title: "Error", message: error.localizedDescription, actions: [("Ok", .default)])
            }).disposed(by: self.disposeBag)
        })
        
        router.alertWithAction(title: "Cover Photo", message: "How do you want to take article's Cover Photo?", actions: [cameraAction, libraryAction])
    }
}

extension UIImage {
    func convertToBase64String() -> String? {
        return self.compressedData(quality: 0.75)?.base64EncodedString()
    }
}

extension String {
    func convertToUIImage() -> UIImage? {
        guard let imageData = Data(base64Encoded: self) else { return nil }
        return UIImage(data: imageData)
    }
}

extension CreateArticleViewModel: RxMediaPickerDelegate {
    func present(picker: UIImagePickerController) {
        router.present(view: picker)
    }
    
    func dismiss(picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
