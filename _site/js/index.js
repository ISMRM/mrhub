/* MRHUB Submissions   */

var options = {
  valueNames: [ 'name', 'short-description', 'full-description', 'category', 'Developers', 'Keywords' ]
};

var featureList = new List('mrhub-list', options);

$('#filter-recon').click(function() {
  featureList.filter(function(item) {
    if (item.values().category == "Reconstruction") {
      return true;
    } else {
      return false;
    }
  });
  return false;
});

$('#filter-simulation').click(function() {
  featureList.filter(function(item) {
    if (item.values().category == "Simulation") {
      return true;
    } else {
      return false;
    }
  });
  return false;
});
$('#filter-none').click(function() {
  featureList.filter();
  return false;
});