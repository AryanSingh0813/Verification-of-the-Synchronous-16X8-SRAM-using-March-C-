`timescale 1ns / 1ps

module tb();

reg [3:0] addr;
reg [7:0] din;

reg clk;
reg ce;
reg wr;

wire [7:0] dout;

sram16_8 dut(addr, din, clk, ce, wr, dout);

initial begin
    clk = 1'b0;
end

always #5 clk <= ~clk;

integer i;

task w0(); // ascending order

    integer i;
    begin
        $display("=================w0===================");
        for(i = 0; i < 16; i = i + 1)begin //write 0
            @(posedge clk);
            wr   = 1'b1;
            din  = 8'h00;
            addr = i;
            @(posedge clk);
            $display("wr = %0d, addr = %0h, din = %0d", wr, addr, din);
        end
         $display("write0 completed");
    end
  
endtask 

task r0_w1_r1_asc();//ascending order
    integer i;
    begin
        $display("=================r0_w1_r1_asc===================");
        for(i = 0; i < 16; i = i + 1)begin //read 0
            @(posedge clk);
            wr   = 1'b0;
            addr = i;
            @(posedge clk);
            $display("wr = %0d, addr = %0h, dout = %0d", wr, addr, dout);
        end
        $display("read0 completed");
        #1;
        for(i = 0; i < 16; i = i + 1)begin // write 1
            @(posedge clk);
            wr   = 1'b1;
            addr = i;
            din  = 8'h01;
            $display("wr = %0d, addr = %0h, din = %0d", wr, addr, din);
        end
        $display("write1 completed");
        #1;
        for(i = 0; i < 16; i = i + 1)begin // read 1
            @(posedge clk);
            wr   = 1'b0;
            addr = i;
            @(posedge clk);
            $display("wr = %0d, addr = %0h, dout = %0d", wr, addr, dout);
        end
        $display("read1 completed");
    end
endtask

task r1_w0_r0_desc();//descending order

        integer i;
    begin
        $display("=================r1_w0_r0_desc===================");
        for(i = 15; i >= 0; i = i - 1)begin //read 1
            @(posedge clk);
            wr   = 1'b0;
            addr = i;
            @(posedge clk);
            $display("wr = %0d, addr = %0h, dout = %0d", wr, addr, dout);
        end
        $display("read1 completed");
        #1;
        for(i = 15; i >= 0; i = i - 1)begin //write 0
            @(posedge clk);
            wr   = 1'b1;
            addr = i;
            din  = 8'h00;
            $display("wr = %0d, addr = %0h, din = %0d", wr, addr, din);
        end
        $display("write0 completed");
        #1;
        for(i = 15; i >= 0; i = i - 1)begin //read 0
            @(posedge clk);
            wr   = 1'b0;
            addr =  i;
            @(posedge clk);
            $display("wr = %0d, addr = %0h, dout = %0d", wr, addr, dout);
        end
        $display("read0 completed");
    end

endtask

task r0_w1_r1_desc();//descending order
    integer i;
    begin
        $display("=================r0_w1_r1_desc===================");
        for(i = 15; i >= 0; i = i - 1)begin //read 0
            @(posedge clk);
            wr   = 1'b0;
            addr = i;
            @(posedge clk);
            $display("wr = %0d, addr = %0h, dout = %0d", wr, addr, dout);
        end
        $display("read0 completed");
        #1;
        for(i = 15; i >= 0; i = i - 1)begin // write 1
            @(posedge clk);
            wr   = 1'b1;
            addr = i;
            din  = 8'h01;
            $display("wr = %0d, addr = %0h, din = %0d", wr, addr, din);
        end
        $display("write1 completed");
        #1;
        for(i = 15; i >= 0; i = i - 1)begin // read 1
            @(posedge clk);
            wr   = 1'b0;
            addr = i;
            @(posedge clk);
            $display("wr = %0d, addr = %0h, dout = %0d", wr, addr, dout);
        end
        $display("read1 completed");
        
    end
endtask

task r1_w0_r0_asc();//ascending order

        integer i;
    begin
        $display("=================r1_w0_r0_asc===================");
        for(i = 0; i < 16; i = i + 1)begin //read 1
            @(posedge clk);
            wr   = 1'b0;
            addr = i;
            @(posedge clk);
            $display("wr = %0d, addr = %0h, dout = %0d", wr, addr, dout);
        end
        $display("read1 completed");
        #1;
        for(i = 0; i < 16; i = i + 1)begin //write 0
            @(posedge clk);
            wr   = 1'b1;
            addr = i;
            din  = 8'h00;
            $display("wr = %0d, addr = %0h, din = %0d", wr, addr, din);
        end
        $display("write0 completed");
        #1;
        for(i = 0; i < 16; i = i + 1)begin //read 0
            @(posedge clk);
            wr   = 1'b0;
            addr =  i;
            @(posedge clk);
            $display("wr = %0d, addr = %0h, dout = %0d", wr, addr, dout);
        end
        $display("read0 completed");
    end

endtask

initial begin
    ce = 1'b0;
    #5 @(posedge clk) ce = 1'b1;
    
        w0();
        r0_w1_r1_asc();
        r1_w0_r0_desc();
        r0_w1_r1_desc();
        r1_w0_r0_asc();

    #10 $finish();
end

endmodule
