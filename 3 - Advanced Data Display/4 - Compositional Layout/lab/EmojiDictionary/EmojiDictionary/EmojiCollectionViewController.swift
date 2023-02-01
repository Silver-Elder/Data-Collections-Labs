// EmojiDictionary

import UIKit

private let gridReuseIdentifier = "Item"
private let columnReuseIdentifier = "ColumnItem"
private let headerIdentifier = "Header"
private let headerKind = "header"

class EmojiCollectionViewController: UICollectionViewController {
    
    @IBOutlet var layoutButton: UIBarButtonItem!
    
    var emojis: [Emoji] = [
        Emoji(symbol: "😀", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
        Emoji(symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
        Emoji(symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
        Emoji(symbol: "🧑‍💻", name: "Developer", description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software, programming"),
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
    
    var sections: [Section] = []
    
    enum Layout {
        case grid
        case column
    }
    var activeLayout: Layout = .grid {
        didSet {
            if let layout = layout[activeLayout] {
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
                // Note: “It's important to call reloadItems before the collection view layout is updated, as you have done here, for a smooth transition between layouts" (Develop in Swift Data Collections – Emoji Dictionary Lab (Part 3), p.665).
                
                collectionView.setCollectionViewLayout(layout, animated: true) { (_) in
                    switch self.activeLayout {
                    case .grid:
                        self.layoutButton.image = UIImage(systemName: "rectangle.grid.1x2")
                    case .column:
                        self.layoutButton.image = UIImage(systemName: "square.grid.2x2")
                    }
                }
            }
        }
    }
    var layout: [Layout: UICollectionViewLayout] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(EmojiCollectionViewHeader.self, forSupplementaryViewOfKind: headerKind, withReuseIdentifier: headerIdentifier)
            // Note: “In a collection view, a supplementary view is registered with a normal reuse identifier and a “kind,” which is a string used to indicate its purpose. Supplementary views are not limited to just headers and footers" (Develop in Swift Data Collections – Emoji Dictionary Lab (Part 3), p.653).
        
        layout[.grid] = generateGridLayout()
        layout[.column] = generateColumnLayout()
        
        if let layout = layout[activeLayout] {
            collectionView.collectionViewLayout = layout
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSections()
        collectionView.reloadData()
    }
    
    func generateColumnLayout() -> UICollectionViewLayout {
        let padding: CGFloat = 10
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(120)
        ), subitems: [item])
        
        group.interItemSpacing = .fixed(padding)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: 0, bottom: padding, trailing: 0)
        
        section.boundarySupplementaryItems = [generateHeader()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func generateGridLayout() -> UICollectionViewLayout {
        let padding: CGFloat = 20
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/4)
            ),
            subitem: item,
            count: 2
        )
        
        group.interItemSpacing = .fixed(padding)
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: padding,
            bottom: 0,
            trailing: padding
        )
            /* Note:
             “The interItemSpacing property sets the interior space between cells contained by the group. The contentInsets sets the standard padding on the leading and trailing edges of the group (or row). While you could use the contentInsets property of item to set the inter-item spacing, ensuring that you don't end up with twice the padding between the items in the row (where the items' leading and trailing edges meet) or the wrong amount of padding at the outer edges is challenging. It's easier to use this combination of interItemSpacing and group contentInsets
             ” (Develop in Swift Data Collections – Emoji Dictionary Lab (Part 3), p.650).

             
             
             */
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = padding
        
        /*
        section.contentInsets.top = padding
        section.contentInsets.bottom = padding
            // This (^^^) is just anothe rway to do this (vvv) (and I think this bottom way's the better approach, personally
         */
        
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: 0, bottom: padding, trailing: 0)
            // Note: “A section's interGroupSpacing is similar to a group's interItemSpacing (other than it being a CGFloat and not an enum). This is essentially the same as what you did above for the group, just rotated 90°" (Develop in Swift Data Collections – Emoji Dictionary Lab (Part 3), p.651).
        
        section.boundarySupplementaryItems = [generateHeader()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func generateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(40)
        ),
         elementKind: headerKind,
         alignment: .top
        )
        
        header.pinToVisibleBounds = true
        
        return header
    }
    
    func updateSections() {
        sections.removeAll()
        
        let grouped = Dictionary(grouping: emojis, by: { $0.sectionTitle})
        
        for (title, emojis) in grouped.sorted(by: { $0.0 < $1.0 }) {
            sections.append(
                Section(
                    title: title,
                    emojis: emojis.sorted(by: { $0.name < $1.name })
               )
            )
        }
            // Note: “updateSections() loops over the grouped dictionary to sort the entries by key (the section titles), and a new Section is created from each key/value pair. The emojis in the section are sorted by name before being stored. This new Section is appended to the sections array, creating a sorted and grouped list of all emojis for display" (Develop in Swift Data Collections – Emoji Dictionary Lab (Part 3), p.655).
                  
    }
    
    @IBAction func switchLayouts(sender: UIBarButtonItem) {
        switch activeLayout {
        case .grid:
            activeLayout = .column
        case .column:
            activeLayout = .grid
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].emojis.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = activeLayout == .grid ? gridReuseIdentifier : columnReuseIdentifier
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! EmojiCollectionViewCell
    
        //Step 2: Fetch model object to display
        let emoji = sections[indexPath.section].emojis[indexPath.item]

        //Step 3: Configure cell
        cell.update(with: emoji)

        //Step 4: Return cell
        return cell
    }
    
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
            // Editing Emoji
            let emojiToEdit = sections[indexPath.section].emojis[indexPath.item]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
            // Adding Emoji
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
    }
   
    func indexPath(for emoji: Emoji) -> IndexPath? {
        if let sectionIndex = sections.firstIndex(where: { $0.title == emoji.sectionTitle}), let index = sections[sectionIndex].emojis.firstIndex(where: { $0 == emoji}) {
            return IndexPath(item: index, section: sectionIndex)
        }
        
        return nil
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? AddEditEmojiTableViewController,
            let emoji = sourceViewController.emoji else { return }
        
        if let path = collectionView.indexPathsForSelectedItems?.first, let index = emojis.firstIndex(where:  { $0 == emoji}) {
            
            emojis[index] = emoji
            updateSections()
            
            collectionView.reloadItems(at: [path])
        } else {
            
            emojis.append(emoji)
            updateSections()
            
            if let newIndexPath = indexPath(for: emoji) {
                collectionView.insertItems(at: [newIndexPath])
            }
        }
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
            let delete = UIAction(title: "Delete") { (action) in
                self.deleteEmoji(at: indexPath)
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
        }
        
        return config
    }

    func deleteEmoji(at indexPath: IndexPath) {
        let emoji = sections[indexPath.section].emojis[indexPath.item]
        guard let index = emojis.firstIndex(where:  { $0 == emoji}) else { return }
        
        emojis.remove(at: index)
        sections[indexPath.section].emojis.remove(at: indexPath.item)
            // Note: “Using the emoji's index and indexPath, the emoji is removed from both emojis and sections. Unlike cases above where emojis could be modified and updateSections() called afterward, a delete requires the arrays to be modified individually. Calling updateSections() here would confuse the collection view layout engine, because the updated sections may not match the expected layout. Finally, the item is deleted from the collection view" (Develop in Swift Data Collections – Emoji Dictionary Lab (Part 3), p.658).
        
        collectionView.deleteItems(at: [indexPath])
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! EmojiCollectionViewHeader
        
        header.titleLabel.text = sections[indexPath.section].title
        
        return header
    }
        // Note: “When the collection view asks for a header, this method is called to configure the view. Similar to regular collection view items, a reusable view is dequeued, configured with the section's title, and returned" (Develop in Swift Data Collections – Emoji Dictionary Lab (Part 3), p.659).
}
