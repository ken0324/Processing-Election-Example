/**
 * Example that loads up election data and draws something with it.
 */

// window size (it's a square)
final int WINDOW_SIZE = 800;
// how many milliseconds to show each state for
final int MILLIS_PER_STATE= 1000;
 
// will hold our anti-aliased font
PFont font;
// when did we last change states?
int lastStateMillis = 0;
// loads and holds the data in the election results CSV
ElectionData data;
// holds a list of state postal codes
String[] statePostalCodes;
// what index in the statePostalCodes array are we current showing
int currentStateIndex = 0;

/**
 * This is called once at the start to initialize things
 **/
void setup() {
  // create the main window
  size(WINDOW_SIZE, WINDOW_SIZE/2);
  // load the font
  font = createFont("Arial",36,true);
  // load in the election results data
  data = new ElectionData(loadStrings("data/2012_US_election_state.csv"));
  statePostalCodes = data.getAllStatePostalCodes();
  print("Loaded data for "+data.getStateCount()+" states");
}

/**
 * This is called repeatedly
 */
void draw() {
  // only update if it's has been MILLIS_PER_STATE since the last time we updated
  if (millis() - lastStateMillis >= MILLIS_PER_STATE) {
    // reset everything
    smooth();
    background(0);
    fill(255);
    // draw the state name
    textFont(font,36);
    textAlign(CENTER);
    String currentPostalCode = statePostalCodes[ currentStateIndex ];
    StateData state = data.getState(currentPostalCode);
    text(state.name,WINDOW_SIZE/2, (WINDOW_SIZE*3.8)/8);
    // draw the obama vote count and title
    fill(50,50,250);  // blue
    text("Obama",7*WINDOW_SIZE/8,WINDOW_SIZE/4);
    text(Math.round(state.pctForObama)+"%",7*WINDOW_SIZE/8,3*WINDOW_SIZE/8);
    // draw the romney vote count and title
    fill(201,50,50);  // red
    text("Romney",WINDOW_SIZE/8,WINDOW_SIZE/4);
    text(Math.round(state.pctForRomney)+"%",WINDOW_SIZE/8,3*WINDOW_SIZE/8);
    // update which state we're showing
    currentStateIndex = (currentStateIndex+1) % statePostalCodes.length;
    // update the last time we drew a state
    lastStateMillis = millis();
    
    
    int[] angles = {int(Math.round(state.pctForObama)*3.6),int(Math.round(state.pctForRomney)*3.6), 360-int(Math.round(state.pctForRomney)*3.6)-int(Math.round(state.pctForObama)*3.6)};
    pushMatrix();
    translate(width/2, height/2);
    rotate(-PI/2);
    pieChart(300, angles);
    popMatrix();
    

  }
}


void pieChart(float diameter, int[] data) {
  float lastAngle = 0;
  for (int i = 0; i < data.length; i++) {
    if(i == 0){
    fill(50,50,250);
    } else if (i == 1) {
      fill(201,50,50);
    } else  {
      fill(100,100,100);
    }
    arc(0, 0, diameter, diameter, lastAngle, lastAngle+radians(data[i]));
    lastAngle += radians(data[i]);
  }
}
