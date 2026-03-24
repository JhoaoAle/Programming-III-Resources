enum COLOR = {GREEN, YELLOW, BLUE, ORANGE};

var COLOR: Colombia;
var COLOR: Venezuela;
var COLOR: Ecuador;
var COLOR: Peru;
var COLOR: Brasil;
var COLOR: Bolivia;
var COLOR: Paraguay;
var COLOR: Uruguay;
var COLOR: Argentina;
var COLOR: Chile;

constraint Colombia != Venezuela;
constraint Colombia != Ecuador;
constraint Colombia != Brasil;
constraint Colombia != Peru;
constraint Venezuela != Brasil;
constraint Ecuador != Peru;
constraint Peru != Brasil;
constraint Peru != Bolivia;
constraint Peru != Chile;
constraint Brasil != Bolivia;
constraint Brasil != Paraguay;
constraint Brasil != Uruguay;
constraint Brasil != Argentina;
constraint Bolivia != Paraguay;
constraint Bolivia != Chile;
constraint Bolivia != Argentina;
constraint Paraguay != Argentina;
constraint Uruguay != Argentina;
constraint Argentina != Chile;

solve satisfy;