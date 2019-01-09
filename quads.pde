//*******by Ruxu Zhang, bug fixed by Jiahui Lu*******
class QUAD{
  PNT A=P(), B=P(), C=P(), D=P(); // four points
  QUAD (PNT A1, PNT B1, PNT C1, PNT D1) {A = A1; B = B1; C = C1; D = D1; } //create by four points
  //EDGE e1=E(A,B),e2=E(B,C),e3=E(C,D),e4=E(D,A);
  QUAD (EDGE ab,EDGE bc,EDGE cd,EDGE da) { A = ab.A; B = bc.A; C = cd.A; D = da.A; }
  EDGE e1() { return E(A,B); }
  EDGE e2() { return E(B,C); }
  EDGE e3() { return E(C,D); }
  EDGE e4() { return E(D,A); }
}

QUAD Q (PNT A, PNT B, PNT C, PNT D){return new QUAD(A, B, C, D);}

void drawQuad(QUAD Q){drawQuad(Q.A, Q.B, Q.C, Q.D);}
void drawQuadTextured(QUAD Q, PImage pix){drawQuadTextured(Q.A, Q.B, Q.C, Q.D, pix);}

QUAD LERP(QUAD Q0, float t, QUAD Q1){
  PNT At=LERP(Q0.A,t,Q1.A);
  PNT Bt=LERP(Q0.B,t,Q1.B);
  PNT Ct=LERP(Q0.C,t,Q1.C);
  PNT Dt=LERP(Q0.D,t,Q1.D);
  return Q(At,Bt,Ct,Dt);
}

QUAD LPM(QUAD Q0, float t, QUAD Q1){
  EDGE ab = LPM(Q0.e1(), t, Q1.e1());
  EDGE bc = LPM(Q0.e2(), t, Q1.e2());
  EDGE cd = LPM(Q0.e3(), t, Q1.e3());
  EDGE da = LPM(Q0.e4(), t, Q1.e4());
  PNT At=P((ab.A.x+da.B.x)/2.0,(ab.A.y+da.B.y)/2.0);
  PNT Bt=P((ab.B.x+bc.A.x)/2.0,(ab.B.y+bc.A.y)/2.0);
  PNT Ct=P((bc.B.x+cd.A.x)/2.0,(bc.B.y+cd.A.y)/2.0);
  PNT Dt=P((da.A.x+cd.B.x)/2.0,(da.A.y+cd.B.y)/2.0);
  //return Q0;
  return Q(At,Bt,Ct,Dt);
}

// Registration by Jiahui Lu
PNT quadCenter(QUAD Q) {
  return P((Q.A.x+Q.B.x+Q.C.x+Q.D.x)/4.0,(Q.A.y+Q.B.y+Q.C.y+Q.D.y)/4.0);
}

float registerAngle(QUAD Q0, QUAD Q1) {
  PNT O0 = quadCenter(Q0), O1 = quadCenter(Q1);
  float s = det(V(O1,Q1.A),V(O0,Q0.A))+det(V(O1,Q1.B),V(O0,Q0.B))
            +det(V(O1,Q1.C),V(O0,Q0.C))+det(V(O1,Q1.C),V(O0,Q0.C));
  float c = dot(V(O0,Q0.A),V(O1,Q1.A))+dot(V(O0,Q0.B),V(O1,Q1.B))
            +dot(V(O0,Q0.C),V(O1,Q1.C))+dot(V(O0,Q0.D),V(O1,Q1.D));
  return atan2(s,c);
}

QUAD registerQuad(QUAD Q0, float t, QUAD Q1) {
  PNT O0 = quadCenter(Q0), O1 = quadCenter(Q1);
  VCT O1A1 = V(O1,Q1.A), O1B1 = V(O1,Q1.B), O1C1 = V(O1,Q1.C), O1D1 = V(O1,Q1.D);
  float alpha = registerAngle(Q0,Q1);
  QUAD Q2 = Q(P(O0,Rotated(O1A1,alpha)),P(O0,Rotated(O1B1,alpha)),P(O0,Rotated(O1C1,alpha)),P(O0,Rotated(O1D1,alpha)));
  QUAD Qt1 = LPM(Q0,t,Q2), Qt2 = LPM(Q2,t,Q1);
  return Q(P(Qt1.A,V(Q2.A,Qt2.A)),P(Qt1.B,V(Q2.B,Qt2.B)),P(Qt1.C,V(Q2.C,Qt2.C)),P(Qt1.D,V(Q2.D,Qt2.D)));
}

QUAD NevilleSmooth(float a, QUAD Qt1, float b, QUAD Qt2, float c, QUAD Qt3, float d, float t) {
  return Q(Neville(a,Neville(a,Qt1.A,c,Qt2.A,t),d,Neville(b,Qt2.A,d,Qt3.A,t),t),
          Neville(a,Neville(a,Qt1.B,c,Qt2.B,t),d,Neville(b,Qt2.B,d,Qt3.B,t),t),
          Neville(a,Neville(a,Qt1.C,c,Qt2.C,t),d,Neville(b,Qt2.C,d,Qt3.C,t),t),
          Neville(a,Neville(a,Qt1.D,c,Qt2.D,t),d,Neville(b,Qt2.D,d,Qt3.D,t),t));
}
