var express = require('express');
var router = express.Router();

yaml = require('js-yaml');
fs   = require('fs');

/* GET home page. */
router.get('/', function(req, res) {
  // Get document, or throw exception on error
  try {
    var doc_string = fs.readFileSync('/home/ypanousi/projects/data-ageing/gcloud/flocker/deployment.yml', 'utf8');
    var doc = yaml.safeLoad(doc_string);
    console.log(doc);
  } catch (e) {
    console.log(e);
  }
  res.render('index', { title: 'Express', deployment: doc_string });
});

module.exports = router;
