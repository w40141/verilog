# verilog

コンパイル方法

$ iverilog -o オフジェクトファイル名 testファイル名.v moderingファイル名.v
$ vvp オブジェクトファイル名

testファイルに以下の内容を書く必要がある．
initial begin
    $monitor($time, "IN1=%b, IN2=%b, OUT=%b", IN1, IN2, OUT);
    $dumpfile("波形ファイル名.vcd");
    $dumpvars(0, テストモジュール名);
end

ex
$ iverilog -o hoge hoge_test.v hoge.v
$ vvp hoge


gtkwaveでの波形表示

$ gtkwave 波形ファイル名.vcd

ex
$ gtkwave hoge.vcd
