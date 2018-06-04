
$fn=100;
circDia = 2;
ringInitRadias = 18;

ringYTranslationAddition = 0.67;
ringXResize = 38.95;
ringYResize = 1.6;
ringZResize = 18;

module ring(){
  rotate([90,0,0])
    rotate_extrude(convexity=10,$fn=100)
      translate([ringInitRadias,,0,0])
        circle(d=circDia);
}


module stretchedRing(resizeFactor,wallThickness){                              
  resize(newsize=[resizeFactor*55.5+wallThickness,
                  0,
                  resizeFactor*24.96+wallThickness])
    ring();
}

module airfoilLip(cameraY,resizeFactor,wallThickness){
  translate([0,-cameraY/2.+ringYTranslationAddition,0])
    resize([ringXResize,ringYResize,ringZResize])
      stretchedRing(resizeFactor,wallThickness);
}  
  /*
  cameraY      = 60.452;
  wallThickness = 2;
  resizeFactor = 1.16;
  airfoilLip(cameraY,resizeFactor,wallThickness);
*/