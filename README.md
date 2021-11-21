# Bài tập đánh giá hiệu năng mạng
https://github.com/vietanhtran2710/network-performance-evaluation

## Hướng dẫn chạy file script:

### Chặng 1: Tính hiệu năng mạng trung bình trong một khoảng thời gian

1. Tính thông lượng trung bình của từng kết nối:

`python3 averageThroughput.py <tên file trace> <tên kết nối>`

Ví dụ: 

`python3 averageThroughput.py out.tr tcp0`

`python3 averageThroughput.py out.tr tcp1`

`python3 averageThroughput.py out.tr tcp2`

`python3 averageThroughput.py out.tr udp`

2. Tính độ trễ trung bình của các gói tin theo từng kết nôi:

`python3 averageDelay.py <tên file trace> <tên kết nối>`

Ví dụ: 

`python3 averageDelay.py out.tr tcp0`

`python3 averageDelay.py out.tr tcp1`

`python3 averageDelay.py out.tr tcp2`

`python3 averageDelay.py out.tr udp`

### Chặng 2: Vẽ đồ thị thông lượng trung bình

3. Tạo trace thông lượng trung bình trong thời gian của 4 kết nối

`perl throughput.pl <trace file> <flow id> <required node> > <output trace file>`

Ví dụ:

tcp0: `perl throughput.pl out.tr 0 5 > out-tcp0.tr`

tcp1: `perl throughput.pl out.tr 1 6 > out-tcp1.tr`

tcp2: `perl throughput.pl out.tr 2 7 > out-tcp2.tr`

cbr: `perl throughput.pl out.tr 3 6 > out-cbr.tr`

4. Tạo trace thông lượng trung bình trong từng khoảng thời gian granularity của 4 kết nối

`perl throughput.pl <trace file> <flow id> <required node> <granularity> > <output trace file>`

Ví dụ:

tcp0: `perl throughput.pl out.tr 0 5 0.15 > out-tcp0.tr`

tcp1: `perl throughput.pl out.tr 1 6 0.15 > out-tcp1.tr`

tcp2: `perl throughput.pl out.tr 2 7 0.15 > out-tcp2.tr`

cbr: `perl throughput.pl out.tr 3 6 0.15 > out-cbr.tr`

5. Vẽ đồ thị thông lượng trung bình bằng gnuplot
`set title “Throughput_vs_sim_time of all Connections”`

`set xlabel “Simulation Time (s)”`

`set ylabel “Throughput(t) (kbps)”`

`Plot ‘out-tcp0.tr’ w lines,‘out-tcp0.tr’ w lines, ‘out-tcp1.tr’ w lines, ‘out-tcp2.tr’ w lines, ‘out-cbr.tr’ w lines`

### Chặng 3: Tính và vẽ đồ thị thăng giáng độ trễ của từng gói tin (Jitter) trong quá trình mô phỏng

6. Đồ thị có thể được vẽ trực tiếp trong code Python hoặc vẽ bằng Gnuplot từ output file mà code tạo ra:

a) Cài đặt Matplotlib cho Python: `pip install matplotlib`

b) Chạy code Python từ dòng lệnh: `python3 delayGraph.py <trace file> <connection name> > <output file>`

Connection name có thể là 1 trong 4: ()

Ví dụ: 

`python3 delayGraph.py out.tr tcp0 > delay-tcp0.tr`

`python3 delayGraph.py out.tr tcp1 > delay-tcp1.tr`

`python3 delayGraph.py out.tr tcp2 > delay-tcp2.tr`

`python3 delayGraph.py out.tr udp > delay-udp.tr`

7. Vẽ đồ thị bằng Gnuplot bằng 4 file output:

a) Vẽ đồ thị cho từng luồng:
```
set title "TCP connection n0-n5, Delay, Mean_Delay and Jitter vs Simulation Time“
set xlabel "Time (s)”
plot "delay-tcp0.tr" using 2:4 t "Delay" w lines, "delay-tcp0.tr" using 2:5 t "Mean_Delay" w lines, "delay-tcp0.tr" using 2:6 t "Jitter" w lines
```
Ta có thể thay `delay-tcp0.tr` bằng bất kỳ file output nào khác được tạo ra bởi code Python `delayGraph.py` phía trên

b) Vẽ đồ thị so sánh sự thay đổi của delay của 3 kết nối TCP và 1 "kết nối” UDP theo thời gian mô phỏng:
```
set title "Comparison of packet Delay of TCP and UDP connections"
set xlabel "Time (s)”
plot "tcp0-5.tr" using 2:4 w lines,"tcp1-6.tr" using 2:4 w lines,"tcp2-7.tr" using 2:4 w lines,”udp3-6.tr” using 2:4 w lines
```

