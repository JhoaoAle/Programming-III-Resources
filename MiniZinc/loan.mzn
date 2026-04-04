var float: Pago;
var float: Prestamo;

var 0 .. 1.0: I;

var float: B1;
var float: B2;
var float: B3;
var float: B4;

constraint B1 = Prestamo * (1.0 + I) - Pago;
constraint B2 = B1 * (1.0 + I) - Pago;
constraint B3 = B2 * (1.0 + I) - Pago;
constraint B4 = B3 * (1.0 + I) - Pago;

solve satisfy;

output["Loaning $", show_float(0,2,Prestamo), " with \(I*100)% interest, repaying $", show_float(0,2,Pago)," quarterly for one year, leaves with a debt of $", show_float(0,2,B4)];