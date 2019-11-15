//
//  CodeEditingViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 11/14/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import Highlightr
import RxCocoa

class CodeEditingViewController: BaseViewController {

    @IBOutlet var codeTextView: PlaceholderTextView!
    var highlightr : Highlightr!
    let textStorage = CodeAttributedString()
    var didFinishTypingCode: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highlightr = textStorage.highlightr
        
        codeTextView.rx.text.subscribe(onNext: { (text) in
            let formattedText = self.format(code: text ?? "")
            self.codeTextView.attributedText = self.highlightr.highlight(formattedText, as: "swift", fastRender: true)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        didFinishTypingCode?(codeTextView.attributedText.string)
        self.navigationController?.popViewController()
    }
    
    private func format(code: String) -> String {
        var text = code
        let numberOfBraces = code.count(of: "{") - code.count(of: "}")
        
        if text.ends(with: "\n") {
            for _ in 0..<numberOfBraces {
                text.append("\t")
            }
        }
        
        return text
    }
}
