import 'package:my_inventory/features/products/model/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  static const String _productTable = 'products';

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'auth.db');
    _database = await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        phoneNumber TEXT,
        businessName TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_productTable(
        productId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        productName TEXT,
        productQuantity INTEGER,
        productAmount REAL,
        productImage TEXT,
        addedBy TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE products(
        productId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        productName TEXT,
        productQuantity INTEGER,
        productAmount REAL,
        productImage TEXT,
        addedBy TEXT
      )
    ''');
    }
  }

  Future<int> registerUser(
    String email,
    String password,
    String businessName,
    String phoneNumber,
  ) async {
    final db = await instance.database;
    return await db.insert('users', {
      'email': email,
      'password': password,
      'businessName': businessName,
      'phoneNumber': phoneNumber,
    });
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertProduct(ProductModel product) async {
    final db = await instance.database;
    return await db.insert(_productTable, product.toMap());
  }

  Future<List<ProductModel>> getProductsByUser(int userId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _productTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  Future<int> updateProduct(ProductModel product) async {
    final db = await instance.database;
    return await db.update(
      _productTable,
      product.toMap(),
      where: 'productId = ?',
      whereArgs: [product.productId],
    );
  }

  Future<int> getUserProductCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_productTable WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> deleteProduct(int productId) async {
    final db = await instance.database;
    return await db.delete(
      _productTable,
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  void resetDatabase() async {
    final dbPath = await getDatabasesPath();
    await deleteDatabase('$dbPath/auth.db');
  }
}
