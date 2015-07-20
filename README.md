# verilog
----


###1.ディレクトリ
名前--回路名  
ディレクトリ内--kairo, module, work  


###2.コンパイル方法

    $ iverilog -o オフジェクトファイル名 testファイル名.v moderingファイル名.v  
    $ vvp オブジェクトファイル名  

testファイルに以下の内容を書く必要がある．  

    initial begin  
        $monitor($time, "IN1=%b, IN2=%b, OUT=%b", IN1, IN2, OUT);  
        $dumpfile("波形ファイル名.vcd");  
        $dumpvars(0, テストモジュール名);  
    end

EX  

    $ iverilog -o hoge hoge_test.v hoge.v  
    $ vvp hoge


###3.gtkwaveでの波形表示

    $ gtkwave 波形ファイル名.vcd

EX  

    $ gtkwave hoge.vcd
