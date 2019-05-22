var options = {
  valueNames: [ 'name', 'dateadded', 'dateupdated', 'category', 'keywords', 'developers', 'shortdescription', 'ncitations']
};

var featureList = new List('projects-list', options);

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
featureList.sort('ncitations', { order: "desc" });

function categories() {
    category = document.getElementById("ddcategory").value;

    if (category == 'all') {
        featureList.filter();
        return false;
    } else {

        featureList.filter(function (item) {
            if (item.values().category == category) {
                return true;
            } else {
                return false;
            }
        });
        return false;
    }
}