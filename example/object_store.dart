import '../lib/object_store.dart';

main () {
  
  // Create or open a database, this will store the data in a folder called 'database'.
  ObjectStore db = new ObjectStore("database");
  
  // Load the cars document from the database.
  List cars = db['cars'];
  
  // If the database is empty, make a new list.
  if(cars == null) {
    cars = [];
    db['cars'] = cars;
  }
  
  // Add a few cars.
  cars.add({'colour':'red', 'name':'My red car'});
  cars.add({'colour':'blue', 'name':'My blue car'});
  cars.add({'colour':'green', 'name':'My green car'});
 
  // Remove all red cars.
  cars.removeWhere((car) {return car['colour'] == 'red';});
   
  // Write changes to database.
  db.saveSync('cars');

}