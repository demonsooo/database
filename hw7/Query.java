/*
 CSE 414 HW7
 YIJIA LIU 1238339
 */

import java.util.Properties;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import java.io.FileInputStream;

import java.sql.*;

/**
 * Runs queries against a back-end database
 */
public class Query {
	private String configFilename;
	private Properties configProps = new Properties();

	private String jSQLDriver;
	private String jSQLUrl;
	private String jSQLUser;
	private String jSQLPassword;

	// DB Connection
	private Connection conn;
        private Connection customerConn;

	// Canned queries

	// LIKE does a case-insensitive match
    private static final String SEARCH_SQL_BEGIN =
    "SELECT * FROM movie WHERE name LIKE '%";
	private static final String SEARCH_SQL_END =
    "%' ORDER BY id";

	private static final String DIRECTOR_MID_SQL = "SELECT y.* "
					 + "FROM movie_directors x, directors y "
					 + "WHERE x.mid = ? and x.did = y.id";
	private PreparedStatement directorMidStatement;

	private static final String CUSTOMER_LOGIN_SQL = 
		"SELECT * FROM customer WHERE login = ? and password = ?";
	private PreparedStatement customerLoginStatement;

	private static final String BEGIN_TRANSACTION_SQL = 
		"SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; BEGIN TRANSACTION;";
	private PreparedStatement beginTransactionStatement;

	private static final String COMMIT_SQL = "COMMIT TRANSACTION";
	private PreparedStatement commitTransactionStatement;

	private static final String ROLLBACK_SQL = "ROLLBACK TRANSACTION";
	private PreparedStatement rollbackTransactionStatement;
    
    private PreparedStatement actorMidStatement;
    private PreparedStatement getRentals;
    private PreparedStatement getMax;
    private PreparedStatement getPersonal;
    private PreparedStatement rentStatement;
    private PreparedStatement returnStatement;
    private PreparedStatement searchDirector;
    private PreparedStatement searchActor;
    private PreparedStatement getRenter;
    private PreparedStatement searchStatement;

	public Query(String configFilename) {
		this.configFilename = configFilename;
	}

    /**********************************************************/
    /* Connection code to SQL Azure. Example code below will connect to the imdb database on Azure
       IMPORTANT NOTE:  You will need to create (and connect to) your new customer database before 
       uncommenting and running the query statements in this file .
     */

	public void openConnection() throws Exception {
		configProps.load(new FileInputStream(configFilename));

		jSQLDriver   = configProps.getProperty("videostore.jdbc_driver");
		jSQLUrl	   = configProps.getProperty("videostore.imdb_url");
		jSQLUser	   = configProps.getProperty("videostore.sqlazure_username");
		jSQLPassword = configProps.getProperty("videostore.sqlazure_password");


		/* load jdbc drivers */
		Class.forName(jSQLDriver).newInstance();

		/* open connections to the imdb database */

		conn = DriverManager.getConnection(jSQLUrl, // database
						   jSQLUser, // user
						   jSQLPassword); // password
                
		conn.setAutoCommit(true); //by default automatically commit after each statement 

		   conn.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
		   
		   String cSQLUrl = configProps.getProperty("videostore.customer_url");
		   customerConn = DriverManager.getConnection(cSQLUrl,jSQLUser, jSQLPassword);
		   customerConn.setAutoCommit(true); //by default automatically commit after each statement
		   
		   customerConn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); 
	        
	}

	public void closeConnection() throws Exception {
		conn.close();
		customerConn.close();
	}

    /**********************************************************/
    /* prepare all the SQL statements in this method.
      "preparing" a statement is almost like compiling it.  Note
       that the parameters (with ?) are still not filled in */

	public void prepareStatements() throws Exception {
        
		directorMidStatement = conn.prepareStatement(DIRECTOR_MID_SQL);

		customerLoginStatement = customerConn.prepareStatement(CUSTOMER_LOGIN_SQL);
		beginTransactionStatement = customerConn.prepareStatement(BEGIN_TRANSACTION_SQL);
		commitTransactionStatement = customerConn.prepareStatement(COMMIT_SQL);
		rollbackTransactionStatement = customerConn.prepareStatement(ROLLBACK_SQL);

		/* add here more prepare statements for all the other queries you need */
		actorMidStatement = conn.prepareStatement("SELECT a.* "
                                                  + "FROM ACTOR a, CASTS c "
                                                  + "WHERE c.mid = ? AND c.pid = a.id");
		getRentals = customerConn.prepareStatement("SELECT count(*) "
			+"FROM rental r "
			+"WHERE r.cid = ? and r.status = 'closed'");
		getMax = customerConn.prepareStatement("select p.maxMovie "
			+"from plans p, customer c "
			+"where c.id = ? and c.pid = p.id");
		getPersonal = customerConn.prepareStatement("select * "
			+ "from customer where id = ?");
		rentStatement = customerConn.prepareStatement(
			"insert into Rental values (? , ? , 'closed' , getDate())");
		returnStatement = customerConn.prepareStatement(
			"update Rental "
			+ "set status = 'open' "
			+ "where mid = ? and cid = ?");
        getRenter = customerConn.prepareStatement("SELECT cid "
                                          + "FROM rental WHERE mid = ? AND status = 'closed'");
        searchStatement = conn.prepareStatement("SELECT * FROM movie "
                                                + "WHERE name LIKE ? ORDER BY id");
        searchActor = conn.prepareStatement("select m.id, a.fname, a.lname "
                                            + "from actor a, movie m, casts c "
                                            + "where m.name LIKE ? "
                                            + "and a.id = c.pid and m.id = c.mid "
                                            + "ORDER BY m.id");
        searchDirector = conn.prepareStatement("select m.id, d.fname, d.lname "
                                               + "from directors d, movie m, movie_directors md "
                                               + "where m.name LIKE ? "
                                               + "and d.id = md.did and m.id = md.mid "
                                               + "ORDER BY m.id");
	}


    /**********************************************************/
    /* Suggested helper functions; you can complete these, or write your own
       (but remember to delete the ones you are not using!) */

	public int getRemainingRentals(int cid) throws Exception {
		/* How many movies can she/he still rent?
		   You have to compute and return the difference between the customer's plan
		   and the count of outstanding rentals */
		getMax.clearParameters();
		getMax.setInt(1, cid);
        getRentals.clearParameters();
        getRentals.setInt(1, cid);
		ResultSet rentals = getRentals.executeQuery();
		ResultSet max = getMax.executeQuery();
        max.next();
        rentals.next();
        int rented = rentals.getInt(1);
        int maxNum = max.getInt(1);
        rentals.close();
        max.close();
		return maxNum - rented;
	}

	public boolean isValidPlan(int planid) throws Exception {
		/* Is planid a valid plan ID?  You have to figure it out */
		Statement planStatement = customerConn.createStatement();
		ResultSet plan = planStatement.executeQuery("select * from plans"
                                                      + " where id = " + planid);
		plan.close();
        if(plan == null)
			return false;
		return true;
	}

	public boolean isValidMovie(int mid) throws Exception {
		/* is mid a valid movie ID?  You have to figure it out */
		Statement validStatement = conn.createStatement();
		ResultSet movie = validStatement.executeQuery("select * from movie"
                                                       + " where id = " + mid);
        boolean valid = false;
        if(movie.next())
			valid = true;
        movie.close();
        return valid;
	}

	private int getRenterID(int mid) throws Exception {
		/* Find the customer id (cid) of whoever currently rents the movie mid; return -1 if none */
		getRenter.clearParameters();
        getRenter.setInt(1,mid);
		ResultSet renter = getRenter.executeQuery();
        int cid = -1;
		if(renter.next())
			cid = renter.getInt(1);
		renter.close();
        return cid;
	}

    /**********************************************************/
    /* login transaction: invoked only once, when the app is started  */
	public int transaction_login(String name, String password) throws Exception {
		/* authenticates the user, and returns the user id, or -1 if authentication fails */

		int cid = -1;
		customerLoginStatement.clearParameters();
		customerLoginStatement.setString(1,name);
		customerLoginStatement.setString(2,password);
		ResultSet cid_set = customerLoginStatement.executeQuery();
		if (cid_set.next()) cid = cid_set.getInt(1);
		cid_set.close();
		return(cid);

	}
    
    /* println the customer's personal data: name, and plan number */
	public void transaction_printPersonalData(int cid) throws Exception {
        getPersonal.clearParameters();
        getPersonal.setInt(1, cid);
        ResultSet pdata = getPersonal.executeQuery();
        pdata.next();
		int remaining = getRemainingRentals(cid);
		System.out.println("Name: " + pdata.getString(4) + " " + pdata.getString(5)
                           + "  Plan Number: " +  pdata.getInt(6)
                           + "  additional movies you can rent: " + remaining);
        pdata.close();
	}


    /**********************************************************/
    /* main functions in this project: */

	public void transaction_search(int cid, String movie_title)
			throws Exception {
		/* searches for movies with matching titles: SELECT * FROM movie WHERE name LIKE movie_title */
		/* prints the movies, directors, actors, and the availability status:
		   AVAILABLE, or UNAVAILABLE, or YOU CURRENTLY RENT IT */

		/* Interpolate the movie title into the SQL string */
        searchStatement.clearParameters();
        searchStatement.setString(1, '%' + movie_title + '%');
        ResultSet movie_set = searchStatement.executeQuery();
		while (movie_set.next()) {
			int mid = movie_set.getInt(1);
			System.out.println("ID: " + mid + " NAME: "
					+ movie_set.getString(2) + " YEAR: "
					+ movie_set.getString(3));
			/* do a dependent join with directors */
			directorMidStatement.clearParameters();
			directorMidStatement.setInt(1, mid);
			ResultSet director_set = directorMidStatement.executeQuery();
			while (director_set.next()) {
				System.out.println("\t\tDirector: " + director_set.getString(3)
						+ " " + director_set.getString(2));
			}
			director_set.close();
			
            /* now you need to retrieve the actors, in the same manner*/
            actorMidStatement.clearParameters();
			actorMidStatement.setInt(1, mid);
			ResultSet actor_set = actorMidStatement.executeQuery();
			while (actor_set.next()) {
				System.out.println("\t\tActor: " + actor_set.getString(3)
                                   + " " + actor_set.getString(2));
			}
            actor_set.close();
            
			/* then you have to find the status: of "AVAILABLE" "YOU HAVE IT", "UNAVAILABLE"*/
            if(getRenterID(mid) == -1) {
				System.out.println("\t\t" + "AVAILABLE");
			} else {
				if(getRenterID(mid) == cid) {
					System.out.println("\t\t" + "YOU CURRENTLY RENT IT");
				} else {
					System.out.println("\t\t" + "UNAVAILABLE");
				}
			}
            
		}
		movie_set.close();
		System.out.println();
	}

	public void transaction_choosePlan(int cid, int pid) throws Exception {
	    /* updates the customer's plan to pid: UPDATE customer SET plid = pid */
	    /* remember to enforce consistency ! */
        try{
            getPersonal.clearParameters();
            getPersonal.setInt(1, cid);
            ResultSet personal = getPersonal.executeQuery();
            personal.next();
            int prepid = personal.getInt(6);
            personal.close();
            beginTransaction();
            Statement updateStatement = customerConn.createStatement();
            updateStatement.executeUpdate("update Customer"
                                          +" set pid = " + pid
                                          + " where id = " + cid);
            if(!isValidPlan(pid) || prepid > pid) {
                rollbackTransaction();
            } else {
                commitTransaction();
            }
        } catch(SQLException e){
            rollbackTransaction();
        }
    }

	public void transaction_listPlans() throws Exception {
	    /* println all available plans: SELECT * FROM plan */
        Statement planStatement = customerConn.createStatement();
		ResultSet plans_set = planStatement.executeQuery("select * from Plans");
		while(plans_set.next()){
			System.out.println("Plan id: " + plans_set.getInt(1) + " Plan name: "
                               +  plans_set.getString(2) + " max rentals: " + plans_set.getInt(3));
		}
        plans_set.close();
	}

	public void transaction_rent(int cid, int mid) throws Exception {
	    /* rent the movie mid to the customer cid */
	    /* remember to enforce consistency ! */
        try {
            int preRenter = getRenterID(mid);
            int remain = getRemainingRentals(cid);
            beginTransaction();
            rentStatement.clearParameters();
            rentStatement.setInt(1, mid);
            rentStatement.setInt(2, cid);
            rentStatement.executeUpdate();
            if(preRenter != -1 || !isValidMovie(mid) || getRemainingRentals(cid) < 0 ){
                rollbackTransaction();
            } else {
                commitTransaction();
            }
        } catch(SQLException e){
            rollbackTransaction();
        }
	}

	public void transaction_return(int cid, int mid) throws Exception {
	    /* return the movie mid by the customer cid */
        try {
            int renter = getRenterID(mid);
            beginTransaction();
            returnStatement.clearParameters();
            returnStatement.setInt(1, mid);
            returnStatement.setInt(2, cid);
            returnStatement.executeUpdate();
            if(renter != cid){
                rollbackTransaction();
            } else {
                commitTransaction();
            }
        } catch(SQLException e) {
            rollbackTransaction();
        }
	}

	public void transaction_fastSearch(int cid, String movie_title)
			throws Exception {
		/* like transaction_search, but uses joins instead of dependent joins
		   Needs to run three SQL queries: (a) movies, (b) movies join directors, (c) movies join actors
		   Answers are sorted by mid.
		   Then merge-joins the three answer sets */
                searchStatement.clearParameters();
                searchStatement.setString(1,'%' + movie_title + '%' );
        ResultSet movie_set = searchStatement.executeQuery();
        
                searchActor.clearParameters();
                searchActor.setString(1,'%' + movie_title + '%' );
        ResultSet actor_set = searchActor.executeQuery();
         
                searchDirector.clearParameters();
                searchDirector.setString(1,'%' + movie_title + '%' );
        ResultSet director_set = searchDirector.executeQuery();
        
        boolean actorHasNext = actor_set.next();
        boolean directorHasNext = director_set.next();
        while (movie_set.next()) {
            int mid = movie_set.getInt(1);
            System.out.println("ID: " + mid + " NAME: "
                                + movie_set.getString(2) + " YEAR: "
                                + movie_set.getString(3));
            
            while (directorHasNext && director_set.getInt(1) == mid) {
                System.out.println("\t\tDirector: " + director_set.getString(3) + " " + director_set.getString(2));
                directorHasNext = director_set.next();
            }
            
            while (actorHasNext && actor_set.getInt(1) == mid) {
                System.out.println("\t\tActor: " + actor_set.getString(3) + " " + actor_set.getString(2));
                actorHasNext = actor_set.next();
            }
        }
        movie_set.close();
        actor_set.close();
        director_set.close();
                
	}

       public void beginTransaction() throws Exception {
	    customerConn.setAutoCommit(false);
	    beginTransactionStatement.executeUpdate();	
        }

        public void commitTransaction() throws Exception {
	    commitTransactionStatement.executeUpdate();	
	    customerConn.setAutoCommit(true);
	}
        public void rollbackTransaction() throws Exception {
	    rollbackTransactionStatement.executeUpdate();
	    customerConn.setAutoCommit(true);
	    }

}
