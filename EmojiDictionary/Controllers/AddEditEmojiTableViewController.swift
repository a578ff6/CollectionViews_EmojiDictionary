//
//  AddEditEmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by 曹家瑋 on 2023/10/9.
//

import UIKit

class AddEditEmojiTableViewController: UITableViewController {
    
    // 輸入欄位
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var usageTextField: UITextField!
    
    // 儲存按鈕
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // 定義id
    struct PropertyKeys {
        static let saveUnwind = "saveUnwind"
    }
    
    // 用於儲存用戶想要編輯的 emoji。
    var emoji: Emoji?
    
    // 初始化方法在創建類的新實例時調用。
    init?(coder: NSCoder, emoji: Emoji?) {
        self.emoji = emoji
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 如果存在一個Emoji（即emoji不為nil）
        if let emoji = emoji {
            symbolTextField.text = emoji.symbol
            nameTextField.text = emoji.name
            descriptionTextField.text = emoji.description
            usageTextField.text = emoji.usage
            title = "Edit Emoji"
        }
        // 如果emoji是nil
        else {
            title = "Add Emoji"
        }
        
        // 呼叫 updateSaveButtonState 更新按鈕的狀態。
        updateSaveButtonState()
    }
    
    // 當任一TextField的內容被修改時
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState() // 更新按鈕的啟用狀態。
    }
    
    /// 只有當TextField都有內容時，才會啟用狀態SaveButton。
    func updateSaveButtonState() {
        // let symbolText = symbolTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        let usageText = usageTextField.text ?? ""
        
        // 檢查所有TextField是否都有內容，並更新儲存按鈕的啟用狀態
        saveButton.isEnabled = containsSingleEmoji(symbolTextField) && !nameText.isEmpty && !descriptionText.isEmpty && !usageText.isEmpty
    }
    
    /// 檢查 UITextField 是否只包含「一個emoj」i。
    func containsSingleEmoji(_ textField: UITextField) -> Bool {
        // 確保TextField中的文字只包含一個字符
        guard let text = textField.text, text.count == 1 else { return false }
        
        // 檢查這個字符是否為一個表情符號，透過檢查Unicode的屬性來完成。
        // 確定該字符是否由多個 unicodeScalars 組成並且是一個emoji。複合emoji，例如國旗或膚色變化的emoji，由多個 unicodeScalars 組成。
        let isCombinedIntoEmoji = text.unicodeScalars.count > 1 && text.unicodeScalars.first?.properties.isEmoji ?? false
        // 確定該字符是否用emoji形式呈現。有些Unicode字符可以有文本表示法和emoji表示法。例如，U+1F60A（笑臉）可以用標準的文本形式或顏色emoji形式呈現。
        let isEmojiPresentation = text.unicodeScalars.first?.properties.isEmojiPresentation ?? false
        
        // 如果字符是表情符號，返回true。否則返回false
        return isCombinedIntoEmoji || isEmojiPresentation
    }

    
    // 在segue被觸發前調用，用於為轉換的目的地畫面準備數據。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 只有當segue的id是"saveUnwind"時，後面的代碼會被執行。
        guard segue.identifier == PropertyKeys.saveUnwind else { return }
        
        // symbol 欄位是必填的
        guard let symbol = symbolTextField.text, !symbol.isEmpty else { return }
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let usage = usageTextField.text ?? ""
        
        // 從四個 TextField 獲取數據，創建一個新的Emoji實例，賦值給emoji
        emoji = Emoji(symbol: symbol, name: name, description: description, usage: usage)
    }
    
}
