module conway_life_test ();

    parameter  WIDTH = 20;
    parameter  HEIGHT = 24;

    localparam FULLWIDTH = WIDTH*HEIGHT;

    bit clk;
    bit load;
    bit [WIDTH * HEIGHT - 1:0] data;
    bit [WIDTH * HEIGHT - 1:0] q;

    conway_life #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .FULLWIDTH(FULLWIDTH)) conway_life_dut (.*);
   
    initial begin
        clk = 0;
        load = 0;
        data = 'h000020000100007 ;  
        forever begin
            #5; clk = ~clk;
        end
    end

    initial begin
        #20; load = 1;
        #10; load = 0; ShowState(0); 
        #10; ShowState(1);
        #10; ShowState(2);
        #10; ShowState(3);
        #10; ShowState(4);
        #10; ShowState(5);
        #10; ShowState(6);
        #10; ShowState(7);
        #10; ShowState(8);
        #10; ShowState(9);
        #10; ShowState(10);
        #10; ShowState(11);
        #10; ShowState(12);
        #10; ShowState(13);
        #10; ShowState(14);
        #10; ShowState(15);
        #10; ShowState(16);
        $stop();
    end

    initial begin
        $dumpfile("life.vcd");
        $dumpvars();
    end


task ShowState(int StateNum);
    
    $display();
    $display("State number is: %1d", StateNum);
    for (int j = HEIGHT - 1; j >= 0; j = j - 1 ) begin
        for (int i = WIDTH - 1; i >=0 ; i = i - 1 )
        begin
            $write ("%1b ", q[j * WIDTH + i]);
        end
        $display();
    end
endtask //
endmodule

module conway_life #(
    parameter WIDTH         = 16,
    parameter HEIGHT        = 16,
    parameter FULLWIDTH     = 256
) (
    input logic  clk,
    input logic  load,
    input logic [FULLWIDTH - 1:0] data,
    output logic [FULLWIDTH - 1:0] q ); 
    
    reg [HEIGHT-1:0][WIDTH-1:0] neighbours_me_buf;

    genvar i, j;
    generate
        for (j = 0; j < HEIGHT; j = j + 1) begin : gen_col
       		for (i = 0; i < WIDTH; i = i + 1) begin : gen_row
                    
                //****************************************************
                if (i > 0 & i < WIDTH - 1 & j > 0 & j < HEIGHT - 1) 
                    assign neighbours_me_buf [j][i] = life_math({
                        q[(j - 1)*WIDTH + i - 1], 	q[(j - 1)*WIDTH + i], 	q[(j - 1)*WIDTH + i + 1],
                        q[j*WIDTH + i - 1],     	q[j*WIDTH + i],     	q[j*WIDTH + i + 1],
                        q[(j + 1)*WIDTH + i - 1], 	q[(j + 1)*WIDTH + i], 	q[(j + 1)*WIDTH + i + 1]
                    });
                //****************************************************
                else if (i == 0 & j == 0 ) 
                    assign neighbours_me_buf [j][i] = life_math({
                        q[WIDTH * HEIGHT - 1],	q[WIDTH * (HEIGHT - 1)], 	q[WIDTH * (HEIGHT - 1) + 1],
                        q[WIDTH - 1],   		q[i],     					q[i + 1],
                        q[2*WIDTH - 1],			q[WIDTH], 					q[WIDTH + 1]
                    });
                
                else if (i == WIDTH - 1 & j == 0 ) 
                    assign neighbours_me_buf [j][i] = life_math({
                        q[WIDTH * (HEIGHT - 1) + i - 1],	q[WIDTH * (HEIGHT - 1) + i], 	q[WIDTH * (HEIGHT - 1)],
                        q[i - 1],   						q[i],     						q[0],
                        q[WIDTH + i - 1],					q[WIDTH + i], 					q[WIDTH]
                    });
                               
                else if (i == 0 & j == HEIGHT - 1) 
                    assign neighbours_me_buf [j][i] = life_math({
                        q[WIDTH * (HEIGHT - 1) - 1], q[WIDTH * (j-1)], 	q[WIDTH * (j - 1) + 1],
                        q[WIDTH * HEIGHT - 1],		 q[WIDTH * j],    	q[WIDTH * j + 1],
                        q[WIDTH - 1],				 q[0], 				q[1]
                    });
                
                else if (i == WIDTH - 1 & j == HEIGHT - 1) 
                    assign neighbours_me_buf [j][i] = life_math({
                        q[WIDTH * (HEIGHT - 1) - 2],	q[WIDTH * (HEIGHT - 1) - 1],	q[WIDTH * (HEIGHT - 2)],
                        q[WIDTH * HEIGHT - 2],			q[WIDTH * HEIGHT - 1],  		q[WIDTH * (HEIGHT - 1)],
                        q[WIDTH - 2],					q[WIDTH - 1], 					q[0]
                    });
                
                else if (i < WIDTH - 1 & j == 0 ) 
                    assign neighbours_me_buf [j][i] = life_math({
                        q[WIDTH * (HEIGHT - 1) + i - 1],	q[WIDTH * (HEIGHT - 1) + i], 	q[WIDTH * (HEIGHT - 1) + i + 1],
                        q[i - 1],   						q[i],     						q[i+1],
                        q[WIDTH + i - 1],					q[WIDTH + i], 					q[WIDTH + i + 1]
                    });
                
                else if (i < WIDTH - 1 & j == HEIGHT - 1 ) 
                    assign neighbours_me_buf [j][i] = life_math({
                        q[(j - 1)*WIDTH + i - 1], 	q[(j - 1)*WIDTH + i], 	q[(j - 1)*WIDTH + i + 1],
                        q[j*WIDTH + i - 1],     	q[j*WIDTH + i],     	q[j*WIDTH + i + 1],
                        q[i - 1], 					q[i], 					q[i + 1]
                    });
                
                else if (i == 0  & j < HEIGHT - 1 ) 
                    assign neighbours_me_buf [j][i] = life_math({
                        q[(j - 1)*WIDTH + WIDTH - 1], 	q[(j - 1)*WIDTH], 	q[(j - 1)*WIDTH + 1],
                        q[j*WIDTH + WIDTH - 1],     	q[j*WIDTH],     	q[j*WIDTH + 1],
                        q[(j + 1)*WIDTH + WIDTH - 1], 	q[(j + 1)*WIDTH], 	q[(j + 1)*WIDTH + 1]
                    });
                
                else if (i == WIDTH - 1  & j < HEIGHT - 1 ) 
                    assign neighbours_me_buf [j][i] = life_math({
                        q[(j - 1)*WIDTH + i - 1], 	q[(j - 1)*WIDTH + i], 	q[(j - 1)*WIDTH],
                        q[j*WIDTH + i - 1],     	q[j*WIDTH + i],     	q[j*WIDTH],
                        q[(j + 1)*WIDTH + i - 1], 	q[(j + 1)*WIDTH + i], 	q[(j + 1)*WIDTH]
                    });
        	end
        end 
    endgenerate
     	
    
    always @(posedge clk)
        if (load)
        	q <= data; 
        else begin
            q <= neighbours_me_buf;
        end
   
    function bit life_math (input [8:0] neighbours_me);
        bit [3:0] num;
        num = 0;
        for (int i = 0; i < 9; i = i + 1) 
            num = i!=4 ? num + neighbours_me[i] : num;
        case (num)
            0,1		: return 0;
            2  		: return neighbours_me[4];
    	    3  		: return 1'b1;
            default : return 0;
        endcase
    endfunction : life_math
 
endmodule