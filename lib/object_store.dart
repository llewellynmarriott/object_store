import 'dart:io';
import 'dart:async';
import 'dart:collection';
import 'dart:json' as JSON;

class ObjectStore implements HashMap<String, Object> {
  HashMap<String, Object> _docs;
  String storeLocation;
  
  ObjectStore(this.storeLocation) {
    _docs = new HashMap<String, Object>();
    // Create store directory if it doesn't exist.
    var directory = new Directory(this.storeLocation);
    directory.createSync(recursive: true);
  }
  
  void operator []=(String key, Object value) {
    if(!_docs.containsKey(key)) {
      _loadKey(key);
    }
    _docs[key] = value;
  }

  Object operator [](String key) {
    // Load the key from the file if it isnt loaded already.
    if(!_docs.containsKey(key)) {
      _loadKey(key);
    }
    
    return _docs[key];
  }
  
  void _loadKey(key) {
    var access = _openDoc(key, FileMode.READ);
    
    // Read file into buffer.
    var buffer = new List<int>(access.lengthSync());
    access.readIntoSync(buffer, 0,access.lengthSync());
    // Conver buffer into string.
    String s = new String.fromCharCodes(buffer);
    // Convert string into JSON object.
    var json = null;
    try {
      if(s.length > 0) {
        json = JSON.parse(s);
      }
    } on FormatException catch (e) {
      print(e);
    }
    _docs[key] = json;
  }
  
  RandomAccessFile _openDoc(String key, FileMode mode) {
      // Create file if it doesn't exist.
      File f = new File(new Path(storeLocation).append(key + '.json').toString());
      if(!f.existsSync()) {
        f.createSync();
      }
      
      // Open with read and write.
      var randomAccess = f.openSync(mode: mode);
      
      return randomAccess;

  }
  
  // Redirect to _docs.
  int get length => _docs.length;
  bool get isEmpty => _docs.isEmpty;
  bool get isNotEmpty => _docs.isNotEmpty;
  List<String> get keys => _docs.keys;
  List<Object> get values => _docs.values;
  bool containsValue(Object v) => _docs.containsValue(v);
  bool containsKey(String k) => _docs.containsKey(k);
  void addAll(Map<String, Object> m) => _docs.addAll(m); 
  Object putIfAbsent(String key, cb) => _docs.putIfAbsent(key, cb);
  Object remove(String k) => _docs.remove(k);
  void clear() => _docs.clear();
  void forEach(cb) => _docs.forEach(cb);
  
  void saveSync(String document) {
    // Open document file in write mode.
    var access = _openDoc(document, FileMode.WRITE);
    
    // Write data as JSON
    access.writeStringSync(JSON.stringify(_docs[document]));
    // Flush and close.
    access.flushSync();
    access.closeSync();
  }
  
  void saveAllSync() {
    _docs.forEach((String key, Object value) {
      saveSync(key);
    });
  }
 
}