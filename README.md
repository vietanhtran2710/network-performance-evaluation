# Bài tập tính hiệu năng mạng trung bình trong một khoảng thời gian
https://github.com/vietanhtran2710/network-performance-evaluation

## Hướng dẫn chạy file script:

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
