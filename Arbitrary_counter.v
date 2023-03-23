//Código del contador arbitrario//



module counter (input clk,reset, output [3:0] counts);

wire Q0,Q1,Q2,Q3,Qn0,Qn1,Qn2,Qn3; //Declaramos las entradas con sus negados//
wire J0,K0,J1,K1,J2,K2,J3,K3;     //Declaramos las salidas de los biestables// 


assign J0 = Q1 | Q3;                         //Asignamos las entradas y puertas de los biestables y el circuito// 
assign K0 = (Q3 & Q1) | (Qn3 & Qn2 & Qn1);
assign J1 = (Q3 & Q0) | (Qn3 & Qn0);
assign K1 = Qn0 | Q3;
assign J2 = Q1 & Qn0;
assign K2 = 1'b1;
assign J3 = (Q1 & Q0) | (Q2 & Q0);
assign K3 = Qn1;

//Le indicamos al programa que compone cada biestable//

JK_FF JK0(.J(J0),.K(K0),.clk(clk),.reset(reset),.Q(Q0),.Qn(Qn0));

JK_FF JK1(.J(J1),.K(K1),.clk(clk),.reset(reset),.Q(Q1),.Qn(Qn1));

JK_FF JK2(.J(J2),.K(K2),.clk(clk),.reset(reset),.Q(Q2),.Qn(Qn2));

JK_FF JK3(.J(J3),.K(K3),.clk(clk),.reset(reset),.Q(Q3),.Qn(Qn3));

//asignamos los 4 salidas que formaran el JK Flip Flop habiendo ya declarado un registro en las salidas de los biestables//

assign counts = {Q3,Q2,Q1,Q0};


endmodule


//Código para JK Flip Flop //



module JK_FF(input J,K,clk,reset,output Q,Qn);


reg q;

always @ (posedge clk, posedge reset) //"Ponemos a punto" los biestables Siempre estableciendo el valor de reloj del contador y el reset//

begin              //basicamente esto es lo que se encarga de establecer los valores del Flip FLop//

if (reset)
q <= 1'b0;                    

else
begin

if (J==1'b0 && K==1'b0)
q <= q;
else if (J==1'b0 && K==1'b1)
q <=1'b0;
else if (J==1'b1 && K==1'b0)
q <=1'b1;
else
q<=~q; 

  end

end

assign Q = q;         //una vez calculados los valores se asigna a Q y Qn sobre el valor de q y su negada//
assign Qn = ~q;       
endmodule


//Módulo para probar el circuito//



module test;

reg clk,reset;
wire [3:0] counts;

counter ak(clk,reset,counts);

always
 
#5 clk=~clk;

initial 
begin

$dumpfile("Trabajo.dmp");    //para usar el gtkwave//
$dumpvars(1, ak, counts);

clk=0; reset=1;
#10 reset=0;
#200 $stop;
#500 $finish;


end
endmodule