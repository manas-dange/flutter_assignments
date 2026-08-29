// ignore_for_file: avoid_print

// ==========================================
// DART CONSOLE PROGRAM: LIBRARY SYSTEM MODEL
// Demonstrating:
// 1. Variables and Data Types
// 2. Control Flow & Loops (for, for-in, while)
// 3. Functions & Methods
// 4. Object-Oriented Programming (OOP) & Inheritance
// ==========================================

/// Base Class representing a general item in the library catalog.
class LibraryItem {
  final String id;
  final String title;
  final int publicationYear;
  bool isBorrowed;

  LibraryItem({
    required this.id,
    required this.title,
    required this.publicationYear,
    this.isBorrowed = false,
  });

  /// Method to check out the item.
  bool checkOut() {
    if (!isBorrowed) {
      isBorrowed = true;
      return true;
    }
    return false;
  }

  /// Method to return the item.
  bool returnItem() {
    if (isBorrowed) {
      isBorrowed = false;
      return true;
    }
    return false;
  }

  /// Method to display item details (overridden by subclasses).
  void displayInfo() {
    final status = isBorrowed ? 'Borrowed' : 'Available';
    print(
      'ID: $id | Title: "$title" | Year: $publicationYear | Status: $status',
    );
  }
}

/// Subclass 1: Book inheriting from LibraryItem.
class Book extends LibraryItem {
  final String author;
  final String genre;
  final int pageCount;

  Book({
    required super.id,
    required super.title,
    required super.publicationYear,
    required this.author,
    required this.genre,
    required this.pageCount,
    super.isBorrowed,
  });

  @override
  void displayInfo() {
    final status = isBorrowed ? 'Borrowed' : 'Available';
    print(
      '[BOOK] ID: $id | "$title" by $author | Genre: $genre | Pages: $pageCount | Year: $publicationYear | Status: $status',
    );
  }
}

/// Subclass 2: DVD inheriting from LibraryItem.
class DVD extends LibraryItem {
  final String director;
  final int durationMinutes;

  DVD({
    required super.id,
    required super.title,
    required super.publicationYear,
    required this.director,
    required this.durationMinutes,
    super.isBorrowed,
  });

  @override
  void displayInfo() {
    final status = isBorrowed ? 'Borrowed' : 'Available';
    print(
      '[DVD]  ID: $id | "$title" directed by $director | Runtime: ${durationMinutes}mins | Year: $publicationYear | Status: $status',
    );
  }
}

/// Subclass 3: Magazine inheriting from LibraryItem.
class Magazine extends LibraryItem {
  final int issueNumber;
  final String publisher;

  Magazine({
    required super.id,
    required super.title,
    required super.publicationYear,
    required this.issueNumber,
    required this.publisher,
    super.isBorrowed,
  });

  @override
  void displayInfo() {
    final status = isBorrowed ? 'Borrowed' : 'Available';
    print(
      '[MAGAZINE] ID: $id | "$title" (Issue #$issueNumber) | Publisher: $publisher | Year: $publicationYear | Status: $status',
    );
  }
}

/// Class representing a registered library member.
class LibraryMember {
  final String memberId;
  final String name;
  final List<LibraryItem> borrowedItems = [];

  LibraryMember({required this.memberId, required this.name});

  void displayMemberSummary() {
    print(
      'Member ID: $memberId | Name: $name | Borrowed Count: ${borrowedItems.length}',
    );
    if (borrowedItems.isNotEmpty) {
      print('  Borrowed Titles:');
      for (final item in borrowedItems) {
        print('   - ${item.title}');
      }
    }
  }
}

/// Class managing library operations, catalog, and members.
class Library {
  final String libraryName;
  final List<LibraryItem> catalog = [];
  final Map<String, LibraryMember> members = {};

  Library(this.libraryName);

  /// Adds a new LibraryItem to the catalog.
  void addItem(LibraryItem item) {
    catalog.add(item);
    print('Added "${item.title}" to $libraryName catalog.');
  }

  /// Registers a library member.
  void registerMember(LibraryMember member) {
    members[member.memberId] = member;
    print('Registered member: ${member.name} (${member.memberId})');
  }

  /// Demonstrating loop iteration over catalog.
  void displayCatalog() {
    print('\n========================================');
    print('       $libraryName CATALOG');
    print('========================================');
    if (catalog.isEmpty) {
      print('No items in the catalog.');
      return;
    }

    for (final item in catalog) {
      item.displayInfo();
    }
    print('========================================\n');
  }

  /// Search for items matching a keyword in title.
  List<LibraryItem> searchByTitle(String keyword) {
    final results = <LibraryItem>[];
    for (final item in catalog) {
      if (item.title.toLowerCase().contains(keyword.toLowerCase())) {
        results.add(item);
      }
    }
    return results;
  }

  /// Issues an item to a member.
  bool issueItem(String memberId, String itemId) {
    final member = members[memberId];
    if (member == null) {
      print('Error: Member ID $memberId not found.');
      return false;
    }

    LibraryItem? targetItem;
    for (var i = 0; i < catalog.length; i++) {
      if (catalog[i].id == itemId) {
        targetItem = catalog[i];
        break;
      }
    }

    if (targetItem == null) {
      print('Error: Item ID $itemId not found in catalog.');
      return false;
    }

    if (targetItem.checkOut()) {
      member.borrowedItems.add(targetItem);
      print('Success: ${member.name} borrowed "${targetItem.title}".');
      return true;
    } else {
      print('Notice: "${targetItem.title}" is already borrowed.');
      return false;
    }
  }

  /// Returns an item borrowed by a member.
  bool returnItem(String memberId, String itemId) {
    final member = members[memberId];
    if (member == null) {
      print('Error: Member ID $memberId not found.');
      return false;
    }

    LibraryItem? targetItem;
    for (final item in member.borrowedItems) {
      if (item.id == itemId) {
        targetItem = item;
        break;
      }
    }

    if (targetItem == null) {
      print(
        'Error: Member ${member.name} does not have item ID $itemId checked out.',
      );
      return false;
    }

    if (targetItem.returnItem()) {
      member.borrowedItems.remove(targetItem);
      print('Success: ${member.name} returned "${targetItem.title}".');
      return true;
    }
    return false;
  }
}

/// Helper function to format header prints.
void printHeader(String title) {
  print('\n>>> $title <<<');
}

void main() {
  print('==============================================');
  print('   WELCOME TO THE DART LIBRARY SYSTEM MODEL   ');
  print('==============================================');

  // 1. Variables & Data Types
  final String libraryName = 'City Central Library';
  final Library cityLibrary = Library(libraryName);

  printHeader('1. Adding Items (OOP Inheritance & Polymorphism)');

  final Book book1 = Book(
    id: 'B001',
    title: 'The Great Gatsby',
    publicationYear: 1925,
    author: 'F. Scott Fitzgerald',
    genre: 'Classic Fiction',
    pageCount: 180,
  );

  final Book book2 = Book(
    id: 'B002',
    title: 'Clean Code',
    publicationYear: 2008,
    author: 'Robert C. Martin',
    genre: 'Software Engineering',
    pageCount: 464,
  );

  final DVD dvd1 = DVD(
    id: 'D001',
    title: 'Inception',
    publicationYear: 2010,
    director: 'Christopher Nolan',
    durationMinutes: 148,
  );

  final Magazine mag1 = Magazine(
    id: 'M001',
    title: 'National Geographic',
    publicationYear: 2024,
    issueNumber: 245,
    publisher: 'NatGeo Media',
  );

  cityLibrary.addItem(book1);
  cityLibrary.addItem(book2);
  cityLibrary.addItem(dvd1);
  cityLibrary.addItem(mag1);

  printHeader('2. Registering Members');
  final member1 = LibraryMember(memberId: 'MEM01', name: 'Alice Smith');
  final member2 = LibraryMember(memberId: 'MEM02', name: 'Bob Johnson');

  cityLibrary.registerMember(member1);
  cityLibrary.registerMember(member2);

  printHeader('3. Displaying Catalog (Loop Iteration)');
  cityLibrary.displayCatalog();

  printHeader('4. Searching Items (Function & Conditionals)');
  final searchKeyword = 'code';
  print('Searching for items containing "$searchKeyword":');
  final searchResults = cityLibrary.searchByTitle(searchKeyword);
  for (final result in searchResults) {
    result.displayInfo();
  }

  printHeader('5. Borrowing Items');
  cityLibrary.issueItem('MEM01', 'B001'); // Alice borrows Gatsby
  cityLibrary.issueItem('MEM01', 'D001'); // Alice borrows Inception
  cityLibrary.issueItem(
    'MEM02',
    'B001',
  ); // Bob tries to borrow Gatsby (already borrowed)

  printHeader('6. Displaying Member Status');
  member1.displayMemberSummary();
  print('');
  member2.displayMemberSummary();

  printHeader('7. Returning Items & Final Catalog Check');
  cityLibrary.returnItem('MEM01', 'B001'); // Alice returns Gatsby

  printHeader('8. Processing System Queue (While Loop)');
  final List<String> taskQueue = [
    'Audit catalog',
    'Send return reminders',
    'Backup database',
  ];
  int index = 0;
  while (index < taskQueue.length) {
    print('Processing system task ${index + 1}: ${taskQueue[index]}');
    index++;
  }

  cityLibrary.displayCatalog();

  print('==============================================');
  print('          LIBRARY SYSTEM SIMULATION END       ');
  print('==============================================');
}
