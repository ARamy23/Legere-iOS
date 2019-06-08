import Foundation
import MobileCoreServices
import RxSwift
import UIKit
import AVFoundation

enum RxMediaPickerAction {
    case photo(observer: AnyObserver<(UIImage, UIImage?)>)
    case video(observer: AnyObserver<URL>, maxDuration: TimeInterval)
}

public enum RxMediaPickerError: Error {
    case generalError
    case canceled
    case videoMaximumDurationExceeded
}

@objc public protocol RxMediaPickerDelegate {
    func present(picker: UIImagePickerController)
    func dismiss(picker: UIImagePickerController)
}

@objc open class RxMediaPicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    weak var delegate: RxMediaPickerDelegate?

    fileprivate var currentAction: RxMediaPickerAction?

    open var deviceHasCamera: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    public init(delegate: RxMediaPickerDelegate) {
        self.delegate = delegate
    }

    open func recordVideo(device: UIImagePickerController.CameraDevice = .rear,
                          quality: UIImagePickerController.QualityType = .typeMedium,
                          maximumDuration: TimeInterval = 600, editable: Bool = false) -> Observable<URL> {
        return Observable.create { observer in
            self.currentAction = RxMediaPickerAction.video(observer: observer, maxDuration: maximumDuration)

            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.videoMaximumDuration = maximumDuration
            picker.videoQuality = quality
            picker.allowsEditing = editable
            picker.delegate = self

            if UIImagePickerController.isCameraDeviceAvailable(device) {
                picker.cameraDevice = device
            }

            self.presentPicker(picker)

            return Disposables.create()
        }
    }

    open func selectVideo(source: UIImagePickerController.SourceType = .photoLibrary,
                          maximumDuration: TimeInterval = 600,
                          editable: Bool = false) -> Observable<URL> {
        return Observable.create { [unowned self] observer in
            self.currentAction = RxMediaPickerAction.video(observer: observer, maxDuration: maximumDuration)

            let picker = UIImagePickerController()
            picker.sourceType = source
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.allowsEditing = editable
            picker.delegate = self
            picker.videoMaximumDuration = maximumDuration

            self.presentPicker(picker)

            return Disposables.create()
        }
    }

    open func takePhoto(device: UIImagePickerController.CameraDevice = .rear,
                        flashMode: UIImagePickerController.CameraFlashMode = .auto,
                        editable: Bool = false) -> Observable<(UIImage, UIImage?)> {
        return Observable.create { [unowned self] observer in
            self.currentAction = RxMediaPickerAction.photo(observer: observer)

            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = editable
            picker.delegate = self

            if UIImagePickerController.isCameraDeviceAvailable(device) {
                picker.cameraDevice = device
            }

            if UIImagePickerController.isFlashAvailable(for: picker.cameraDevice) {
                picker.cameraFlashMode = flashMode
            }

            self.presentPicker(picker)

            return Disposables.create()
        }
    }

    open func selectImage(source: UIImagePickerController.SourceType = .photoLibrary,
                          editable: Bool = false) -> Observable<(UIImage, UIImage?)> {
        return Observable.create { [unowned self] observer in
            self.currentAction = RxMediaPickerAction.photo(observer: observer)

            let picker = UIImagePickerController()
            picker.sourceType = source
            picker.allowsEditing = editable
            picker.delegate = self

            self.presentPicker(picker)

            return Disposables.create()
        }
    }

    func processPhoto(info: [UIImagePickerController.InfoKey : Any],
                      observer: AnyObserver<(UIImage, UIImage?)>) {
        guard let image = info[.originalImage] as? UIImage else {
            observer.on(.error(RxMediaPickerError.generalError))
            return
        }
        let editedImage = info[.editedImage] as? UIImage

        observer.on(.next((image, editedImage)))
        observer.on(.completed)
    }

    fileprivate func presentPicker(_ picker: UIImagePickerController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.present(picker: picker)
        }
    }

    fileprivate func dismissPicker(_ picker: UIImagePickerController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.dismiss(picker: picker)
        }
    }

    // MARK: UIImagePickerControllerDelegate
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let action = currentAction {
            switch action {
            case .photo(let observer):
                processPhoto(info: info, observer: observer)
                dismissPicker(picker)
            case .video:
                break
            }
        }
    }

    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissPicker(picker)

        if let action = currentAction {
            switch action {
            case .photo(let observer):      observer.on(.error(RxMediaPickerError.canceled))
            case .video(let observer, _):   observer.on(.error(RxMediaPickerError.canceled))
            }
        }
    }
}
