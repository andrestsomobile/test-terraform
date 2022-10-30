var mysql = require('mysql');

var connection = mysql.createConnection({
  host     : 'process.env.RDS_HOSTNAME',
  user     : 'root',
  password : 'mysql2022',
  port     : 3306
});

connection.connect(function(err) {
  if (err) {
    console.error('Database connection failed: ' + err.stack);
    return;
  }

  console.log('Connected to database.');
});

connection.end();