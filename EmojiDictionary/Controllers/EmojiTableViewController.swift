//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by 曹家瑋 on 2023/10/7.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    /// 用來存儲表格的數據
    var emojis: [Emoji] = [
        Emoji(symbol: "😀", name: "Grinning Face",description: "A typical smiley face.", usage: "happiness"),
        Emoji(symbol: "😕", name: "Confused Face",description: "A confused, puzzled face.", usage: "unsurewhat to think; displeasure"),
        Emoji(symbol: "😍", name: "Heart Eyes",description: "A smiley face with hearts for eyes.",usage: "love of something; attractive"),
        Emoji(symbol: "🧑‍💻", name: "Developer",description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software,programming"),
        Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "something slow"),
        Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
        Emoji(symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
        Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
        Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping"),
        Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework, studying"),
        Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness"),
        Emoji(symbol: "💤", name: "Snore", description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
        Emoji(symbol: "🏁", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion")
    ]
    
    
    // 用來定義 id
    struct PropertyKeys {
        static let emojiTableViewCell = "EmojiTableViewCell"
        static let saveUnwind = "saveUnwind"
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設置單元格的佈局邊距遵從螢幕的可讀寬度。
        // 而不是橫向填充整個表格視圖。有助於在較寬的螢幕（如iPad）上增強內容的可讀性。
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        
        // 使用預定義的editButtonItem按鈕
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.rowHeight = UITableView.automaticDimension     // 自動調整行高
        tableView.estimatedRowHeight = 44.0                      // 給一個預估 row 高值，以優化性能
        
        // 用自定義的 EmojiTableViewCell
        // 並設定其 reuseIdentifier 為 "emojiTableViewCell"
        // tableView.register(EmojiTableViewCell.self, forCellReuseIdentifier: PropertyKeys.emojiTableViewCell)
    }
    
    // 每次視圖將要出現在螢幕上時都會被呼叫
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 通知表格視圖重新加載所有的數據
        tableView.reloadData()
    }
    
    // 處理用戶點擊添加按鈕或點擊行(row)以編輯一個表情符號的操作。
    // 根據用戶的操作初始化 AddEditEmojiTableViewController 並傳遞相應的表情符號或nil。
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        
        // 嘗試將 sender 轉型為 UITableViewCell。如果轉型成功，表示用戶想要編輯一個現有的表情符號。
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            // 編輯現有的Emoji
            // 通過 indexPath 從 emojis陣列 中獲取要編輯的表情符號，並將其傳遞給新視圖控制器。
            let emojiToEdit = emojis[indexPath.row]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } 
        // 如果 sender 不是一個 UITableViewCell（如果用戶點擊了添加按鈕）
        else {
            // 添加新的Emoji
            // 使用 nil 初始化 AddEditEmojiTableViewController 表示將創建一個新的表情符號。
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
    }
    
    
    // 根據情況更新表格的內容
    @IBAction func unwindToEmojiTableView(_ unwindSegue: UIStoryboardSegue) {
        // 確認segue與來源控制器的身份，並取得emoji數據
        guard unwindSegue.identifier == PropertyKeys.saveUnwind,
              let sourceViewController = unwindSegue.source as? AddEditEmojiTableViewController,
              let emoji = sourceViewController.emoji else { return }
        
        // 確認是編輯現有的emoji還是新增一個emoji
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // 更新現有emoji
            emojis[selectedIndexPath.row] = emoji
            
            // 更新現有emoji的表格行（ 更新指定的行，使其加載新數據。）
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
        else {
            // 新增一個emoji
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            
            // 新增一個emoji的表格行（ 在表格的[newIndexPath]位置插入一行。）
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
    }

    // MARK: - Table view data source
    
    // 設置section（區段）
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1    // 只有一個 Section
    }

    // 設置Row(行)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count      // 有多少 emoji 就有多少行
    }

    // 配置 Cell(單元格) 顯示數據
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 使用之前註冊的 reuseIdentifier ("emojiTableViewCell") 來從表格視圖的一個可重用的單元格池中取出或創建一個單元格。
        // 取出單元格（Cell）並強制轉型為 EmojiTableViewCell，這樣就可以使用 update(with:)。
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.emojiTableViewCell, for: indexPath) as? EmojiTableViewCell else {         
            fatalError("Unable to dequeue EmojiTableViewCell")
        }
        
        // 從 emojis array中獲取對應行的 emoji 對象，用於配置單元格的顯示內容。
        let emoji = emojis[indexPath.row]
        cell.update(with: emoji)
        
        // 允許cell顯示重新排序控件，即在編輯模式下顯示右側的三條橫線拖動顯示狀態。
        cell.showsReorderControl = true
        
        // 回傳單元格
        return cell
    }
    
    // 確保表格處於編輯模式（移動單元格（row））
    // sourceIndexPath：被移動單元格的原始位置。
    // destinationIndexPath：用戶希望移動到的新位置。
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 從 data source 中移除被移動的單元格的數據。
        let movedEmoji = emojis.remove(at: sourceIndexPath.row)
        // 將剛剛移除的單元格數據插入到新的位置。
        emojis.insert(movedEmoji, at: destinationIndexPath.row)
    }
    
    // 支援編輯表格視圖
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 設置為delete
        if editingStyle == .delete {
            // 從data source 中刪除行
            emojis.remove(at: indexPath.row)
            // 從表格視圖中刪除行，並帶有動畫效果
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Table view delegate
    
    // 響應用戶的選擇
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取得被選擇的 emoji
        let emoji = emojis[indexPath.row]
        
        // 輸出 emoji 符號和對應的索引路徑
        print("\(emoji.symbol) \(indexPath)")
    }
    
    // 為每個單元格(row)定義編輯樣式
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // 允許刪除項目
        return .delete
    }

}
