/* Box.scad
 * 2018 05 12
 * gratefulfrog.org
 * generates a box for a video camera that mounts to the Freewing Stores pod
 * Usage:
 * at the very end of the file, uncomment the line:
 * //boxWithGridAndHooks("d");
 * then hit F5 to get a view, or F6 to build the object.
 * It will take quite some time, during which OpenSCAD will bu unresponsive, that is normal
 * so just be patient.
 * ATENTION: this file is included in 2PartBox.scad so be sure to leave the last line
 * commented out if you intend to use 2PartBox.scad
 */

$fn=100;
// hook measurements
hookSpacingY  = 50;
hookLength    = 4.76;
BottomWidth      = 1.58 ;
FirstVertical    = 2.39;
bottomWingWidth  = 1.58;
_2ndVertical     = 0.78;
_3rdVertical     = _2ndVertical+0.01;
TopWidth         = 3.18;

hookSupportX = BottomWidth  + 2*bottomWingWidth;
hookSupportY = hookSpacingY + hookLength;

slotEpsilon=0.1;
BottomWidthS      = 1.58 + slotEpsilon;
FirstVerticalS    = 2.39 - slotEpsilon;
bottomWingWidthS  = 1.58 + slotEpsilon;
_2ndVerticalS     = 0.78 + slotEpsilon;
_3rdVerticalS     = _2ndVertical+0.01 + slotEpsilon;
TopWidthS         = 3.18 + slotEpsilon;

module measuredBlock(){
  epsilon= 1;
  blockX=2*(BottomWidth/2.+bottomWingWidth)+3*slotEpsilon;
  blockY = hookLength+2*epsilon;
  blockZ = FirstVertical + _2ndVertical + _3rdVertical+slotEpsilon;
  translate([-blockX/2.,-1.5*epsilon,-epsilon])
    cube([blockX,blockY,blockZ+epsilon]);
}
module measuredHookCutter(wallThickness){
  epsilon= wallThickness;  // to ensure ancoring in the base!
  points = [[0,-epsilon],
            [BottomWidthS,-epsilon],
            [BottomWidthS,FirstVerticalS],
            [BottomWidthS+bottomWingWidthS,FirstVerticalS],
            [BottomWidthS+bottomWingWidthS,FirstVerticalS+_2ndVerticalS],
            [BottomWidthS+bottomWingWidthS-_3rdVerticalS,FirstVerticalS+_2ndVerticalS+_3rdVerticalS],
            [BottomWidthS+bottomWingWidthS-_3rdVerticalS-TopWidthS,FirstVerticalS+_2ndVerticalS+_3rdVerticalS],
            [-BottomWidthS,FirstVerticalS+_2ndVerticalS],
            [-BottomWidthS,FirstVerticalS],
            [0,FirstVerticalS]];
  translate([-BottomWidthS/2.0,hookLength,0])
  rotate([90,0,0])
    linear_extrude(height = hookLength)
      polygon(points,convexity = 1);
}


module measuredHook(wallThickness){
  epsilon= wallThickness;  // to ensure ancoring in the base!
  points = [[0,-epsilon],
            [BottomWidth,-epsilon],
            [BottomWidth,FirstVertical],
            [BottomWidth+bottomWingWidth,FirstVertical],
            [BottomWidth+bottomWingWidth,FirstVertical+_2ndVertical],
            [BottomWidth+bottomWingWidth-_3rdVertical,FirstVertical+_2ndVertical+_3rdVertical],
            [BottomWidth+bottomWingWidth-_3rdVertical-TopWidth,FirstVertical+_2ndVertical+_3rdVertical],
            [-BottomWidth,FirstVertical+_2ndVertical],
            [-BottomWidth,FirstVertical],
            [0,FirstVertical]];
  translate([-BottomWidth/2.0,hookLength,0])
  rotate([90,0,0])
    linear_extrude(height = hookLength)
      polygon(points,convexity = 1);
}
module twoMeasuredHooks(wallThickness,withSupport){
  hookSupportZ = wallThickness;
  translate([0,
             -hookSupportY/2.,
             0]){
    measuredHook(wallThickness);
    translate([0,hookSpacingY,0])
      measuredHook(wallThickness);
  }
  if (withSupport){
    hookSupport(wallThickness);
  }
}
  

module hookSupport(wallThickness){
  hookSupportZ = wallThickness;
  translate([-hookSupportX/2.,-hookSupportY/2.,-hookSupportZ])
          cube([hookSupportX,hookSupportY,hookSupportZ]);
}

pylonX = 2*hookSupportX;
pylonY = 64+pylonX;
pylonZ = 30;

module plyon0(){
  hull(){
    separation= pylonY - pylonX;
    translate([0,separation/2.,0])
      cylinder(d=pylonX,h=pylonZ);
    translate([0,-separation/2.,0])
      cylinder(d=pylonX,h=pylonZ);
  }
}
module pylon1(){
  difference(){
    union(){
      plyon0();
      translate([0,0,pylonZ])
        twoMeasuredHooks(2, false);
    }
    #translate([0,0/**hookLength/2*/,0])
      plyonCutters();
  }
}

module plyonCutters(){
  translate([0,-hookLength,0])
    twoMeasuredBlocks(2, false);
  twoMeasuredHookCutters();
}

module twoMeasuredBlocks(){
  translate([0,
             -hookSupportY/2.,
             0]){
    measuredBlock();
    translate([0,hookSpacingY,0])
      measuredBlock();
  }
}
module twoMeasuredHookCutters(){
  translate([0,
             -hookSupportY/2.,
             0]){
    measuredHookCutter(2);
    translate([0,hookSpacingY,0])
      measuredHookCutter(2);
  }
}
pylon1();
//translate([0,hookLength,0])
//  plyonCutters();
