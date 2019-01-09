// By Jiahui Lu
// Modified by Ruxu Zhang
void drawGrid(PNT A, PNT B, PNT C, PNT D, boolean ifMesh) {
  SIMILARITY S1 = S(A,B,D,C); 
  SIMILARITY S2 = S(A,D,B,C);
  if (S1.F == null) { // In fact, this time S2.F == null as well
    drawLine(A,D); drawLine(B,C); drawLine(A,B); drawLine(D,C);
    if (ifMesh) {
      for (int i = 1; i < numGrid; i++) {
        float t = (float)i / numGrid;
        PNT P1 = LERP(A,t,D), P2 = LERP(B,t,C), P3 = LERP(A,t,B), P4 = LERP(D,t,C);
        if (showCoon == 0 || showCoon == 2) {
          if (showLabels) {
            fill(magenta); writeLabel(P(740,760), "SQUINT"); if (!fill) noFill();
          }
          strokeWeight(2); stroke(red, 100);
          drawLine(P1,P2);
          strokeWeight(2); stroke(blue, 100);
          drawLine(P3,P4);
        }
        if (showCoon == 1 || showCoon == 2) {
          if (showLabels) {
            fill(brown); writeLabel(P(740,780), "Coon's Patch"); if (!fill) noFill();
          }
          strokeWeight(2); stroke(orange, 100);
          drawLine(P1,P2);
          strokeWeight(2); stroke(green, 100);
          drawLine(P3,P4);
        }
      }
    }
  }
  else {
    float lAD = dist(A,D), lBC = dist(B,C), lAB = dist(A,B), lDC = dist(D,C);
    for (float step = 0; step < lAD; step += 0.5) drawPoint(S1.Apply(A,step / lAD));
    for (float step = 0; step < lBC; step += 0.5) drawPoint(S1.Apply(B,step / lBC));
    for (float step = 0; step < lAB; step += 0.5) drawPoint(S2.Apply(A,step / lAB));
    for (float step = 0; step < lDC; step += 0.5) drawPoint(S2.Apply(D,step / lDC));
    
    if (ifMesh) {
      if (showCoon == 0 || showCoon == 2) { // Coon's Patch by Jiahui Lu
        if (showLabels) {
          fill(magenta); writeLabel(P(740,760), "SQUINT"); if (!fill) noFill();
        }
        for (int i = 1; i < numGrid; i++) {
          float t = (float)i / numGrid;
          PNT P1 = S1.Apply(A,t), P2 = S1.Apply(B,t);
          float lPP = dist(P1,P2);
          strokeWeight(2); stroke(red, 100);
          for (float step = 0; step < lPP; step += 0.5) drawPoint(S2.Apply(P1,step / lPP));
          P1 = S2.Apply(A,t); P2 = S2.Apply(D,t);
          lPP = dist(P1,P2);
          strokeWeight(2); stroke(blue, 100);
          for (float step = 0; step < lPP; step += 0.5) drawPoint(S1.Apply(P1,step / lPP));
        }
      }
      if (showCoon == 1 || showCoon == 2) { // Coon's Patch by Jiahui Lu
        if (showLabels) {
          fill(brown); writeLabel(P(740,780), "Coon's Patch"); if (!fill) noFill();
        }
        for (int i = 1; i < numGrid; i++) {
          float t1 = (float)i / numGrid;
          PNT P1 = S1.Apply(A,t1), P2 = S1.Apply(B,t1);
          float lPP = dist(P1,P2);
          strokeWeight(2); stroke(orange, 100);
          for (float step = 0; step < lPP; step += 0.5) {
            float t2 = (float)step / lPP;
            PNT P3 = S2.Apply(A,t2), P4 = S2.Apply(D,t2);
            drawPoint(coon(LERP(P1,t2,P2),LERP(P3,t1,P4),LERP(LERP(A,t1,D),t2,LERP(B,t1,C))));
          }
          P1 = S2.Apply(A,t1); P2 = S2.Apply(D,t1);
          lPP = dist(P1,P2);
          strokeWeight(2); stroke(green, 100);
          for (float step = 0; step < lPP; step += 0.5) {
            float t2 = (float)step / lPP;
            PNT P3 = S1.Apply(A,t2), P4 = S1.Apply(B,t2);
            drawPoint(coon(LERP(P1,t2,P2),LERP(P3,t1,P4),LERP(LERP(A,t2,D),t1,LERP(B,t2,C))));
          }
        }
      }
    }
  }       
}

void drawPhoto(PNT A, PNT B, PNT C, PNT D, PImage face) {
  SIMILARITY S1 = S(A,B,D,C); 
  SIMILARITY S2 = S(A,D,B,C);
  int w = face.width, h = face.height;
  PNT[] MAP = new PNT[w*h];
  int pix = 1; // to keep the picture brightness stable 
  for (int x = 0; x < w; x++) {
    PNT P0;
    if (S2.F == null) P0 = P(A,Scaled((2.0*x+1)/(2*w),V(A,B)));
      else P0 = S2.Apply(A,(2.0*x+1)/(2*w));
    for (int y = 0; y < h; y++) {
      int pos = y*w+x;
      if (S1.F == null) MAP[pos] = P(P0,Scaled((2.0*y+1)/(2*h),V(A,D)));
        else MAP[pos] = S1.Apply(P0,(2.0*y+1)/(2*h));
      if (x > 0) pix = max(pix,(int)dist(MAP[pos],MAP[pos-1]));
      if (y > 0) pix = max(pix,(int)dist(MAP[pos],MAP[pos-w]));
      if (x > 0 && y > 0) pix = max(pix,(int)dist(MAP[pos],MAP[pos-w-1]));
    }
  } 
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      int pos = y*w+x;
      PNT draw = MAP[pos];
      strokeWeight(pix*2+3); // to keep the picture brightness stable 
      stroke(face.pixels[pos],100); 
      drawPoint(draw);
    }
  }
}

void drawMesh(PNT A, PNT B, PNT C, PNT D) {
  if (texturing == 1) drawPhoto(A,B,C,D,FaceStudent1);
  else if (texturing == 2) drawPhoto(A,B,C,D,FaceStudent2);
  else drawGrid(A,B,C,D,true);
}
