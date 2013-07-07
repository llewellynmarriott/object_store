Object Store
==============

A simple local object storage system.

Allows you to easily store and read objects to your file system as JSON.

Usage
-----

Creating a database:

    // Create or open a database, this will store the data in a folder called 'database'.
    ObjectStore db = new ObjectStore("database");
  
Loading a document from a database:

    // Load the cars document from the database.
    List cars = db['cars'];
  
Making changes to a database:

    // Add a few cars.
    cars.add({'colour':'red', 'name':'My red car'});
    cars.add({'colour':'blue', 'name':'My blue car'});
    cars.add({'colour':'green', 'name':'My green car'});
 
    // Remove all red cars.
    cars.removeWhere((car) {return car['colour'] == 'red';});
   
Saving changes:

    // Write changes to database.
    db.saveSync('cars');

See examples for more.