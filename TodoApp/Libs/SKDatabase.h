


#import <UIKit/UIKit.h>
#import <sqlite3.h>

@protocol SKDatabaseDelegate <NSObject>
@optional
- (void)databaseTableWasUpdated:(NSString *)table;
@end

@interface SKDatabase : NSObject {
	
	id<SKDatabaseDelegate> delegate;
	sqlite3 *dbh;
	BOOL dynamic;
}

@property (nonatomic, retain) id<SKDatabaseDelegate> delegate;
@property sqlite3 *dbh;
@property BOOL dynamic;

/*
 * Initializes the DB with the name of a database file bundled with the application.
 */
- (id)initWithFile:(NSString *)dbFile;

/*
 * Initializes the DB with the contents of an NSData, and writes it's contents out to the specified file.
 */
- (id)initWithData:(NSData *)data andFile:(NSString *)dbFile;

/*
 * Close the database connect.
 */
- (void)close;

/*
 * Executes the supplied SQL, and returns a single column.
 */
- (id)lookupColForSQL:(NSString *)sql;

/*
 * Executes the supplied SQL, and returns a single row.
 */
- (NSDictionary *)lookupRowForSQL:(NSString *)sql;

/** Executes the supplied SQL, and returns everything.
 */
- (NSArray *)lookupAllForSQL:(NSString *)sql;


/*
 * Executes the supplied SQL, returning nothing.
 */


/**
 This method will run the SQL query
 
 This method accepts a String value representing the SQL query
 
 
 To use it, simply call
 
  localDB?.performSQL(Your SQL Query)
 
  localDB is Object of our SKdatabase Wrapper Class

 
 */
- (void) performSQL:(NSString *)sql;

/*
 * Escape a string. Useful for preparing SQL statements.
 */
- (NSString *)escapeString:(NSString *)dirtyString;

@end



