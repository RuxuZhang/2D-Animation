// by Jiahui Lu
class SIMILARITY {
  PNT F;
  float lambda, alpha;
  SIMILARITY () { F = null; lambda = 0; alpha = 0; }
  SIMILARITY (PNT f, float l, float a) { F = f; lambda = l; alpha = a; }
  SIMILARITY (PNT A0, PNT B0, PNT A1, PNT B1) {
    VCT AB0 = V(A0,B0), AB1 = V(A1,B1), A1A0 = V(A1,A0);
    lambda = normOf(AB1)/normOf(AB0);
    alpha = angle(AB0, AB1);  
    VCT w = V(lambda*cos(alpha)-1, lambda*sin(alpha));
    float d = sq(lambda*cos(alpha)-1) + sq(lambda*sin(alpha));
    if (d < 1e-8) F = null;
      else F = P(A0,Divided(V(dot(w,A1A0),dot(Rotated(w),A1A0)), d));
  }
  PNT Apply(PNT P, float t) {
    PNT PP = P(F, pow(lambda,t), Rotated(V(F,P), alpha*t));
    return PP;
  }
}

SIMILARITY S(PNT A, PNT B, PNT C, PNT D) {
  return new SIMILARITY(A,B,C,D);
}
