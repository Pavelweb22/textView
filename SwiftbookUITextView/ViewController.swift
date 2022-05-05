//
//  ViewController.swift
//  SwiftbookUITextView
//
//  Created by Павел Яковенко on 20.04.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self // назначение делегата, того кто будет нести ответственность за использование методов
        textView.text = ""
        
        textView.font = UIFont(name: "Rockwell", size: 20)
        textView.backgroundColor = self.view.backgroundColor
        textView.layer.cornerRadius = 10
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true) //  Скрытие клавиатуры для любого объекта
    }

    @objc func updateTextView(notification: Notification){
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyboardFrame.height - textViewBottomConstraint.constant,
                                                 right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }

}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) { // момент начала редактирования поля
        textView.backgroundColor = .white
        textView.textColor = .gray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) { // момент окончания редактирования поля
        textView.backgroundColor = self.view.backgroundColor
        textView.textColor = .black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        label.text = "\(textView.text.count)"
        return textView.text.count + (text.count - range.length) <= 60
    }
}
