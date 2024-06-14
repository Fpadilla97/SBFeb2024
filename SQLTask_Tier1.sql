{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "7621b0ac-25b9-4d3d-9f0d-f8b40aea5b44",
   "metadata": {},
   "source": [
    "Welcome to the SQL mini project. You will carry out this project partly in\n",
    "the PHPMyAdmin interface, and partly in Jupyter via a Python connection.\n",
    "\n",
    "This is Tier 1 of the case study, which means that there'll be more guidance for you about how to \n",
    "setup your local SQLite connection in PART 2 of the case study. \n",
    "\n",
    "The questions in the case study are exactly the same as with Tier 2. \n",
    "\n",
    "PART 1: PHPMyAdmin\n",
    "You will complete questions 1-9 below in the PHPMyAdmin interface. \n",
    "Log in by pasting the following URL into your browser, and\n",
    "using the following Username and Password:\n",
    "\n",
    "URL: https://sql.springboard.com/\n",
    "Username: student\n",
    "Password: learn_sql@springboard\n",
    "\n",
    "The data you need is in the \"country_club\" database. This database\n",
    "contains 3 tables:\n",
    "    i) the \"Bookings\" table,\n",
    "    ii) the \"Facilities\" table, and\n",
    "    iii) the \"Members\" table.\n",
    "\n",
    "In this case study, you'll be asked a series of questions. You can\n",
    "solve them using the platform, but for the final deliverable,\n",
    "paste the code for each solution into this script, and upload it\n",
    "to your GitHub.\n",
    "\n",
    "Before starting with the questions, feel free to take your time,\n",
    "exploring the data, and getting acquainted with the 3 tables. */\n",
    "\n",
    "\n",
    "/* QUESTIONS\n",
    "/* Q1: Some of the facilities charge a fee to members, but some do not.\n",
    "Write a SQL query to produce a list of the names of the facilities that do. */\n",
    "SELECT * FROM `Facilities` WHERE `membercost` > 0\n",
    "\n",
    "\n",
    "/* Q2: How many facilities do not charge a fee to members? */\n",
    "SELECT COUNT(`name`)\n",
    "FROM Facilities\n",
    "WHERE `membercost` = 0;\n",
    "\n",
    "\n",
    "/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,\n",
    "where the fee is less than 20% of the facility's monthly maintenance cost.\n",
    "Return the facid, facility name, member cost, and monthly maintenance of the\n",
    "facilities in question. */\n",
    "SELECT `facid`,`name`,`membercost`,`monthlymaintenance`\n",
    "FROM `Facilities` \n",
    "WHERE `membercost` < (0.20 * `monthlymaintenance`)\n",
    "\n",
    "/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.\n",
    "Try writing the query without using the OR operator. */\n",
    "SELECT *\n",
    "FROM `Facilities`\n",
    "WHERE facid =1\n",
    "OR facid =5;\n",
    "\n",
    "\n",
    "/* Q5: Produce a list of facilities, with each labelled as\n",
    "'cheap' or 'expensive', depending on if their monthly maintenance cost is\n",
    "more than $100. Return the name and monthly maintenance of the facilities\n",
    "in question. */\n",
    "SELECT name, monthlymaintenance,\n",
    "CASE WHEN monthlymaintenance >100\n",
    "THEN 'expensive'\n",
    "ELSE 'cheap'\n",
    "END AS 'cost'\n",
    "FROM Facilities;\n",
    "\n",
    "/* Q6: You'd like to get the first and last name of the last member(s)\n",
    "who signed up. Try not to use the LIMIT clause for your solution. */\n",
    "SELECT surname, firstname, joindate\n",
    "FROM `Members` \n",
    "ORDER BY joindate ASC;\n",
    "\n",
    "\n",
    "/* Q7: Produce a list of all members who have used a tennis court.\n",
    "Include in your output the name of the court, and the name of the member\n",
    "formatted as a single column. Ensure no duplicate data, and order by\n",
    "the member name. */\n",
    "SELECT bf.facid, m.surname, m.firstname, bf.name\n",
    "FROM (\n",
    "\n",
    "SELECT DISTINCT b.facid, b.memid, f.name\n",
    "FROM Bookings AS b\n",
    "LEFT JOIN Facilities AS f ON b.facid = f.facid\n",
    "WHERE b.facid =0\n",
    "OR b.facid =1\n",
    ") AS bf\n",
    "LEFT JOIN Members AS m ON bf.memid = m.memid\n",
    "ORDER BY m.surname, m.firstname;\n",
    "\n",
    "\n",
    "/* Q8: Produce a list of bookings on the day of 2012-09-14 which\n",
    "will cost the member (or guest) more than $30. Remember that guests have\n",
    "different costs to members (the listed costs are per half-hour 'slot'), and\n",
    "the guest user's ID is always 0. Include in your output the name of the\n",
    "facility, the name of the member formatted as a single column, and the cost.\n",
    "Order by descending cost, and do not use any subqueries. */\n",
    "SELECT b.facid, b.starttime, f.membercost, f.guestcost, f.name, m.surname, m.firstname\n",
    "FROM Bookings AS b\n",
    "LEFT JOIN Facilities AS f ON b.facid = f.facid\n",
    "LEFT JOIN Members as m ON b.memid = m.memid \n",
    "WHERE b.starttime LIKE '2012-09-14%'\n",
    "AND (f.membercost >=30 OR f.guestcost >=30)\n",
    "ORDER BY f.guestcost DESC;\n",
    "\n",
    "\n",
    "/* Q9: This time, produce the same result as in Q8, but using a subquery. */\n",
    "SELECT bf.facid, bf.memid, bf.starttime, bf.membercost, bf.guestcost, bf.name, m.surname, m.firstname\n",
    "FROM (\n",
    "\n",
    "SELECT b.facid, b.memid, b.starttime, f.membercost, f.guestcost, f.name\n",
    "FROM Bookings AS b\n",
    "LEFT JOIN Facilities AS f ON b.facid = f.facid\n",
    "WHERE b.starttime LIKE '2012-09-14%'\n",
    "AND (\n",
    "f.membercost >=30\n",
    "OR f.guestcost >=30\n",
    ")\n",
    ") AS bf\n",
    "LEFT JOIN Members AS m ON bf.memid = m.memid\n",
    "ORDER BY bf.guestcost DESC;\n",
    "\n",
    "\n",
    "/* PART 2: SQLite\n",
    "/* We now want you to jump over to a local instance of the database on your machine. \n",
    "\n",
    "Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. \n",
    "\n",
    "Make sure that the SQLFiles folder containing thes files is in your working directory, and\n",
    "that you haven't changed the name of the .db file from 'sqlite\\db\\pythonsqlite'.\n",
    "\n",
    "You should see the output from the initial query 'SELECT * FROM FACILITIES'.\n",
    "\n",
    "Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back\n",
    "to the PHPMyAdmin interface as and when you need to. \n",
    "\n",
    "You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.\n",
    " \n",
    "QUESTIONS:\n",
    "/* Q10: Produce a list of facilities with a total revenue less than 1000.\n",
    "The output of facility name and total revenue, sorted by revenue. Remember\n",
    "that there's a different cost for guests and members! */\n",
    "SELECT sub.name, SUM( sub.revenue ) AS revenue\n",
    "FROM (\n",
    "SELECT b.facid, b.memid, f.name, f.guestcost, f.membercost, COUNT( b.facid ) AS facid_count,\n",
    "CASE\n",
    "WHEN b.memid =0\n",
    "THEN COUNT( b.facid ) * f.guestcost\n",
    "ELSE COUNT( b.facid ) * f.membercost\n",
    "END AS 'revenue'\n",
    "FROM Bookings AS b\n",
    "LEFT JOIN Facilities AS f ON b.facid = f.facid\n",
    "GROUP BY b.facid, b.memid\n",
    ") AS sub\n",
    "GROUP BY sub.facid\n",
    "HAVING revenue <=1000;\n",
    "\n",
    "/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */\n",
    "SELECT m.surname, m.firstname, m.recommendedby AS recomender_id, r.surname AS recomender_surname, r.firstname AS recomender_firstname\n",
    "FROM Members AS m\n",
    "LEFT JOIN Members AS r ON m.recommendedby = r.memid\n",
    "WHERE m.recommendedby != 0\n",
    "ORDER BY r.surname, r.firstname;\n",
    "\n",
    "/* Q12: Find the facilities with their usage by member, but not guests */\n",
    "SELECT b.facid, COUNT( b.memid ) AS mem_usage, f.name\n",
    "FROM (\n",
    "SELECT facid, memid\n",
    "FROM Bookings\n",
    "WHERE memid !=0\n",
    ") AS b\n",
    "LEFT JOIN Facilities AS f ON b.facid = f.facid\n",
    "GROUP BY b.facid;\n",
    "\n",
    "\n",
    "/* Q13: Find the facilities usage by month, but not guests */\n",
    "SELECT b.months, COUNT( b.memid ) AS mem_usage\n",
    "FROM (\n",
    "SELECT MONTH( starttime ) AS months, memid\n",
    "FROM Bookings\n",
    "WHERE memid !=0\n",
    ") AS b\n",
    "GROUP BY b.months;"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.11.5"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
