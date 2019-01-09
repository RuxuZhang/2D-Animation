// base code 01 for graphics class 2018, Jarek Rossignac

// **** LIBRARIES
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.awt.Toolkit;
import java.awt.datatransfer.*;


// **** GLOBAL VARIABLES

// COLORS
color // set more colors using Menu >  Tools > Color Selector
  black=#000000, grey=#5F5F5F, white=#FFFFFF, 
  red=#FF0000, green=#00FF01, blue=#0300FF, 
  yellow=#FEFF00, cyan=#00FDFF, magenta=#FF00FB, 
  orange=#FCA41F, dgreen=#026F0A, brown=#AF6E0B;

// FILES and COUNTERS
String PicturesFileName = "SixteenPoints";
int frameCounter=0;
int pictureCounterPDF=0, pictureCounterJPG=0, pictureCounterTIF=0; // appended to file names to avoid overwriting captured images

// PICTURES
PImage FaceStudent1, FaceStudent2; // picture of student's face as /data/XXXXX.jpg in sketch folder !!!!!!!!

// TEXT
PFont bigFont; // Font used for labels and help text

// KEYBOARD-CONTROLLED BOOLEAM TOGGLES AND SELECTORS 
int method=0; // selects which method is used to set knot values (0=uniform, 1=chordal, 2=centripetal)
boolean animating=true; // must be set by application during animations to force frame capture
int texturing = 0;
boolean showArrows=true;
boolean showInstructions=true;
boolean showLabels=true;
boolean showLERP=true;
boolean showLPM=true;
boolean showRegister=true;
boolean fill=true;
boolean filming=false;  // when true frames are captured in FRAMES for a movie

// flags used to control when a frame is captured and which picture format is used 
boolean recordingPDF=false; // most compact and great, but does not always work
boolean snapJPG=false;
boolean snapTIF=false;   

// ANIMATION
float totalAnimationTime=9; // at 1 sec for 30 frames, this makes the total animation last 270 frames
float time=0;
int sec = 0;

//POINTS 
int pointsCountMax = 32;         //  max number of points
int pointsCount=4;               // number of points used
PNT[] Point = new PNT[pointsCountMax];   // array of points
QUAD[] Quad = new QUAD[4];        //array of quads
PNT A, B, C, D; // Convenient global references to the first 4 control points 
PNT P; // reference to the point last picked by mouse-click

//MESH
boolean meshMode = false;
int numGrid = 1;
int showCoon = 0;

//SMOOTH
boolean nevSmooth = false;

// **** SETUP *******
void setup()               // executed once at the begining LatticeImage
{
  size(800, 800, P2D);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  bigFont = createFont("AdobeFanHeitiStd-Bold-32", 16); 
  textFont(bigFont); // font used to write on screen
  //*******by Ruxu Zhang*******
  FaceStudent1 = loadImage("data/student1.jpg");  // file containing photo of student's face
  FaceStudent2 = loadImage("data/student2.jpg");  // file containing photo of student's face
  FaceStudent1.loadPixels();
  declarePoints(Point); // creates objects for 
  readPoints("data/points.pts");
  A=Point[0]; 
  B=Point[1]; 
  C=Point[2]; 
  D=Point[3]; // sets the A B C D pointers
  textureMode(NORMAL); // addressed using [0,1]^2
} // end of setup


// **** DRAW
void draw()      // executed at each frame (30 times per second)
{
  if (recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF

  if (showInstructions) showHelpScreen(); // display help screen with student's name and picture and project title

  else // display frame
  {
    background(white); // erase screen
    A=Point[0]; 
    B=Point[1]; 
    C=Point[2]; 
    D=Point[3]; // sets the A B C D pointers

    // Update animation time
    if (animating) 
    {
      if (time<1) time+=1./(totalAnimationTime*frameRate); // advance time
      else  
      time=0;// reset time to the beginning
    } 

    // WHEN USING 4 CONTROL POINTS:  Use this for morphing edges (in 6491)
    if (pointsCount==4)
    {
      if (meshMode) { // draw quad mesh, by Jiahui Lu
        drawMesh(A, B, C, D);
      } else { // draw two vectors
        EDGE E0 = new EDGE(A, B);
        EDGE E1 = new EDGE(D, C);

        if (showArrows)         // Draw edges as arrows
        {
          stroke(grey); 
          strokeWeight(5); 
          drawEdgeAsArrow(E0); 
          drawEdgeAsArrow(E1);
        }

        if (showLERP)         // Draw lerp of endpoints (as a reference of a bad morph)
        {
          EDGE Et = LERP(E0, time, E1);
          stroke(blue); 
          strokeWeight(3); 
          fill(blue);
          drawEdgeAsArrow(Et);
          writeLabel(Et.PNTnearB(), " LERP");
          noFill();
        }

        if (showLPM)         // Draw LMP: This is a place holder with the wrong solution. 
        {
          EDGE Et = LPM(E0, time, E1); // You must change this code (see TAB edges)
          stroke(red); 
          strokeWeight(3); 
          fill(red);
          drawEdgeAsArrow(Et);
          writeLabel(Et.PNTnearB(), " LPM");
          noFill();
        }
      }

      // Draw and label control points
      if (showLabels) // draw names of control points
      {
        textAlign(CENTER, CENTER); // to position the label around the point
        stroke(black); 
        strokeWeight(1); // attribute of circle around the label
        showLabelInCircle(A, "A"); 
        showLabelInCircle(B, "B"); 
        showLabelInCircle(C, "C"); 
        showLabelInCircle(D, "D");
      } else // draw small dots at control points
      {
        fill(brown); 
        stroke(brown); 
        drawCircle(A, 4); 
        drawCircle(B, 4); 
        drawCircle(C, 4); 
        drawCircle(D, 4);
      }
      noFill();
    } // end of when 4 points


    // ***** WHEN USING 16 CONTROL POINTS (press '4' to make them or 'R' to load them from file)  *****
    if (pointsCount==16)
    {
      noFill();
      strokeWeight(6); 
      for (int i=0; i<4; i++) {
        stroke(50*i, 200-50*i, 0); 
        if (meshMode) drawGrid(Point[i*4], Point[i*4+1], Point[i*4+2], Point[i*4+3], false);//by Ruxu Zhang
        else drawQuad(Point[i*4], Point[i*4+1], Point[i*4+2], Point[i*4+3]);
      }

      // Draw control points
      if (showLabels) // draw names of control points
      {
        textAlign(CENTER, CENTER); // to position the label around the point
        stroke(black); 
        strokeWeight(1); // attribute of circle around the label
        for (int i=0; i<pointsCount; i++) showLabelInCircle(Point[i], Character.toString((char)(int)(i+65)));
      } else // draw small dots at control points
      {
        fill(blue); 
        stroke(blue); 
        strokeWeight(2);  
        for (int i=0; i<pointsCount; i++) drawCircle(Point[i], 4);
      }

      // Animate quad
      strokeWeight(20); 
      stroke(red, 100); // semitransparent
      //replace {At,Bt..} by QUAD OBJECT in the code below
      //here is the code replaced 
      //by Ruxu Zhang
      PNT At=P(), Bt=P(), Ct=P(), Dt=P();
      QUAD Qt=Q(At, Bt, Ct, Dt);
      Quad[0]=Q(Point[0], Point[1], Point[2], Point[3]);
      Quad[1]=Q(Point[4], Point[5], Point[6], Point[7]);
      Quad[2]=Q(Point[8], Point[9], Point[10], Point[11]);
      Quad[3]=Q(Point[12], Point[13], Point[14], Point[15]);

      //*******LERP by Ruxu Zhang, bug fixed by Jiahui Lu*******
      if (showLERP)
      {     
        if (showLabels) {
          fill(red); writeLabel(P(740,700), "LERP"); if (!fill) noFill();
        }
        if (!nevSmooth) {
          strokeWeight(2); 
          stroke(grey, 100); 
          noFill();
          for (int i=0; i<4; i++) drawOpenQuad(Point[i], Point[i+4], Point[i+8], Point[i+12]);        
  
          if (time <= 1.0/3) Qt = LERP(Quad[0], time*3.0, Quad[1]); // *** changed
          else if (time <= 2.0/3) Qt = LERP(Quad[1], (time-1.0/3.0)*3.0, Quad[2]);
          else Qt = LERP(Quad[2], (time-2.0/3.0)*3.0, Quad[3]);
        }
        else { //**** Smoothening by Ruxu Zhang ****
          for (int step = 0; step <= 1350; step++) {
            QUAD Qt1 = LERP(Quad[0], step/450.0, Quad[1]);
            QUAD Qt2 = LERP(Quad[1], step/450.0-1, Quad[2]);
            QUAD Qt3 = LERP(Quad[2], step/450.0-2, Quad[3]);
            QUAD Qtt = NevilleSmooth(0,Qt1,450,Qt2,900,Qt3,1350,step);
            strokeWeight(2); 
            stroke(grey, 100);
            drawPoint(Qtt.A); drawPoint(Qtt.B); drawPoint(Qtt.C); drawPoint(Qtt.D);
          }
          QUAD Qt1 = LERP(Quad[0], time*3.0, Quad[1]); 
          QUAD Qt2 = LERP(Quad[1], time*3.0-1, Quad[2]);
          QUAD Qt3 = LERP(Quad[2], time*3.0-2, Quad[3]);
          Qt = NevilleSmooth(0.0,Qt1,1.0/3,Qt2,2.0/3,Qt3,1.0,time);
        }
        noFill(); 
        noStroke(); 
        if (meshMode) {// use SQUINT mode in three fixed quads by Ruxu Zhang
          strokeWeight(2); 
          stroke(grey, 100);
          drawMesh(Qt.A, Qt.B, Qt.C, Qt.D);
        } else {
          if (texturing == 1) drawQuadTextured(Qt, FaceStudent1); //changed
          else if (texturing == 2) drawQuadTextured(Qt, FaceStudent2); //changed
          else {
            noFill(); 
            if (fill) fill(yellow);
            strokeWeight(20); 
            stroke(red, 100); // semitransparent
            drawQuad(Qt);
          }
        }
      }
      //*******LPM by Ruxu Zhang, bug fixed by Jiahui Lu*******

      // Draw route of LPM , by Jiahui Lu
      // We found that using point() is much faster than using curve()
      if (showLPM)
      {
        if (showLabels) {
          fill(cyan); writeLabel(P(740,720), "LPM"); if (!fill) noFill();
        }
        if (!nevSmooth) {
          for (int i = 0; i < 3; i++) 
            for (int step = 0; step <= 450; step++) {
              QUAD Qtt = LPM(Quad[i], step/450.0, Quad[i+1]);
              strokeWeight(2); 
              stroke(grey, 100);
              drawPoint(Qtt.A); drawPoint(Qtt.B); drawPoint(Qtt.C); drawPoint(Qtt.D);
            }
  
          if (time <= 1.0/3) Qt = LPM(Quad[0], time*3.0, Quad[1]); // *** changed
          else if (time <= 2.0/3) Qt = LPM(Quad[1], (time-1.0/3.0)*3.0, Quad[2]);
          else Qt = LPM(Quad[2], (time-2.0/3.0)*3.0, Quad[3]);
        }
        else { //**** Smoothening by Ruxu Zhang ****
          for (int step = 0; step <= 1350; step++) {
            QUAD Qt1 = LPM(Quad[0], step/450.0, Quad[1]);
            QUAD Qt2 = LPM(Quad[1], step/450.0-1, Quad[2]);
            QUAD Qt3 = LPM(Quad[2], step/450.0-2, Quad[3]);
            QUAD Qtt = NevilleSmooth(0,Qt1,450,Qt2,900,Qt3,1350,step);
            strokeWeight(2); 
            stroke(grey, 100);
            drawPoint(Qtt.A); drawPoint(Qtt.B); drawPoint(Qtt.C); drawPoint(Qtt.D);
          }
          QUAD Qt1 = LPM(Quad[0], time*3.0, Quad[1]); 
          QUAD Qt2 = LPM(Quad[1], time*3.0-1, Quad[2]);
          QUAD Qt3 = LPM(Quad[2], time*3.0-2, Quad[3]);
          Qt = NevilleSmooth(0.0,Qt1,1.0/3,Qt2,2.0/3,Qt3,1.0,time);
        }
        noFill(); 
        noStroke(); 
        if (meshMode) {
          strokeWeight(2); 
          stroke(grey, 100);
          drawMesh(Qt.A, Qt.B, Qt.C, Qt.D);
        } else {
          if (texturing == 1) drawQuadTextured(Qt, FaceStudent1); // changed
          else if (texturing == 2) drawQuadTextured(Qt, FaceStudent2); // changed
          else {
            noFill(); 
            if (fill) fill(cyan);
            strokeWeight(20); 
            stroke(red, 100); // semitransparent
            drawQuad(Qt);
          }
        }
      }
      // Registeration by Jiahui Lu
      if (showRegister) {
        if (showLabels) {
          fill(orange); writeLabel(P(740,740), "Registration"); if (!fill) noFill();
        }
        if (!nevSmooth) { 
          for (int i = 0; i < 3; i++) 
            for (int step = 0; step <= 450; step++) {
              QUAD Qtt = registerQuad(Quad[i], step/450.0, Quad[i+1]);
              strokeWeight(2); 
              stroke(grey, 100);
              drawPoint(Qtt.A); drawPoint(Qtt.B); drawPoint(Qtt.C); drawPoint(Qtt.D);
            }
  
          if (time <= 1.0/3) Qt = registerQuad(Quad[0], time*3.0, Quad[1]); // *** changed
          else if (time <= 2.0/3) Qt = registerQuad(Quad[1], (time-1.0/3.0)*3.0, Quad[2]);
          else Qt = registerQuad(Quad[2], (time-2.0/3.0)*3.0, Quad[3]);
        }
        else { //**** Smoothening by Ruxu Zhang ****
          for (int step = 0; step <= 1350; step++) {
            QUAD Qt1 = registerQuad(Quad[0], step/450.0, Quad[1]);
            QUAD Qt2 = registerQuad(Quad[1], step/450.0-1, Quad[2]);
            QUAD Qt3 = registerQuad(Quad[2], step/450.0-2, Quad[3]);
            QUAD Qtt = NevilleSmooth(0,Qt1,450,Qt2,900,Qt3,1350,step);
            strokeWeight(2); 
            stroke(grey, 100);
            drawPoint(Qtt.A); drawPoint(Qtt.B); drawPoint(Qtt.C); drawPoint(Qtt.D);
          }
          QUAD Qt1 = registerQuad(Quad[0], time*3.0, Quad[1]); 
          QUAD Qt2 = registerQuad(Quad[1], time*3.0-1, Quad[2]);
          QUAD Qt3 = registerQuad(Quad[2], time*3.0-2, Quad[3]);
          Qt = NevilleSmooth(0.0,Qt1,1.0/3,Qt2,2.0/3,Qt3,1.0,time);
        }
        noFill(); 
        noStroke(); 
        if (meshMode) {
          strokeWeight(2); 
          stroke(grey, 100);
          drawMesh(Qt.A, Qt.B, Qt.C, Qt.D);
        } else {
          if (texturing == 1) drawQuadTextured(Qt, FaceStudent1); // changed
          else if (texturing == 2) drawQuadTextured(Qt, FaceStudent2); // changed
          else {
            noFill(); 
            if (fill) fill(orange);
            strokeWeight(20); 
            stroke(red, 100); // semitransparent
            drawQuad(Qt);
          }
        }
      }
    } // end of when 16 points
  } // end of display frame



  // snap pictures or movie frames
  if (recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas
  if (snapTIF) snapPictureToTIF();   
  if (snapJPG) snapPictureToJPG();   
  if (filming) snapFrameToTIF(); // saves image on canvas as movie frame
} // end of draw()
