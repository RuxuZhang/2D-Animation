class EDGE // POINT
  { 
  PNT A=P(), B=P(); // Start and End vertices
  EDGE (PNT P, PNT Q) {A.setTo(P); B.setTo(Q);}; // Creates edge
  PNT PNTnearB() {return P(B,20,Normalized(V(A,B)));}
  }
EDGE E (PNT P, PNT Q) {return new EDGE(P,Q);}

void drawEdge(EDGE E) {drawEdge(E.A,E.B);} 
void drawEdgeAsArrow(EDGE E) {arrow(E.A,E.B);} 

EDGE LERP(EDGE E0, float t, EDGE E1) // LERP between EDGE endpoints
  {
  PNT At = LERP(E0.A,t,E1.A); 
  PNT Bt = LERP(E0.B,t,E1.B);
  return E(At,Bt);
  }

// **** You must replace this code by the correct solution *** 
// by Jiahui Lu
EDGE LPM(EDGE E0, float t, EDGE E1) // LPM between EDGE endpoints 
  {
  /*
  VCT V0 = V(E0.A,E0.B);
  VCT V1 = V(E1.A,E1.B);
  VCT Vt = LPM(V0,t,V1);
  // COMPUTE THE FIXED POINT F AND USE IT
  PNT At = LERP(E0.A,time,E1.A); 
  PNT Bt = P(At,Vt); // Bt = At + Vt (Point + Vector)
  return E(At,Bt);
  */
  // Here is the correct code LPM
    PNT A0 = E0.A, B0 = E0.B, A1 = E1.A, B1 = E1.B;
    SIMILARITY S = new SIMILARITY(A0,B0,A1,B1);
    if (S.F == null) return LERP(E0,t,E1);
    PNT P1 = S.Apply(A0,t), P2 = S.Apply(B0,t);
    return E(P1, P2);
  }
  
void drawLine(PNT P1, PNT P2) {
  line(P1.x,P1.y,P2.x,P2.y);
}

float lenEdge(EDGE E) {
  return normOf(V(E.A,E.B));
}
