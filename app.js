'use strict'

//Module Dependencies
require('coffee-script');
require('coffee-script/register');

var express = require('express');
var http = require('http');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var bodyParser = require('body-parser');
var methodOverride = require('method-override');
var static_dir = require('serve-static');
var errorHandler = require('errorhandler');
var crypto = require('crypto')
var cluster = require('cluster');
var cookieParser = require('cookie-parser');
var session = require('express-session');
var MongoStore = require('connect-mongo/es5')(session);
var timeout = require('connect-timeout');
var flash = require('connect-flash');
var device = require('express-device');

// The application
if (cluster.isMaster) {
  var cpuCount, i = undefined;
  cpuCount = require("os").cpus().length;
  i = 0;
  while (i < cpuCount) {
    cluster.fork();
    i += 1;
  }
} else {

  var app = express();
  var port = 4040;
  var server = app.listen(port);

  //All environments
  app.set('views', path.join(__dirname, 'views'));
  app.set('view engine', 'jade');
  app.use(favicon(path.join(__dirname, 'public/favicon.ico')));
  app.use(logger('dev'));
  app.use(cookieParser());
  app.use(bodyParser.json());
  app.use(device.capture());
  app.use(bodyParser.urlencoded({extended: true}));

  app.use(session({
      secret: 'secret_session',
      cookie: { maxAge: 24 * 60 * 60, expires: null },
      saveUninitialized: true,
      resave: true
    }));

  app.use(flash());
  app.use(methodOverride());
  var routes = require('./routes')(app);
  app.use(static_dir(path.join(__dirname, 'public')));

  // Error Handling (Uncomment in production!)
  // 404
  // app.use(function(req, res) {
  //  res.status(404).send("404: Not Found");
  // });

  // 500
  // app.use(function(err, req, res, next) {
  //  res.status(500).send(err, "500: Server Error");
  // });

  // Development only
  if ('development' == app.get('env')) {
    app.use(errorHandler());
  }

  http.createServer(app).listen(app.get(port), function(){
    var cpuNum = undefined;
    cpuNum = parseInt(cluster.worker.id) - 1
    cpuNum = cpuNum.toString()
    console.log('Express server listening on port ' + port + ', cpu:worker:' + cpuNum);
  });
}

cluster.on('exit', function (worker) {
    var cpuNum = undefined;
    cpuNum = parseInt(worker.id) - 1
    cpuNum = cpuNum.toString()
    console.log('cpu:worker:' + cpuNum + ' died unexpectedly, respawning...');
    cluster.fork();
});
