# Bài tập tính hiệu năng mạng trung bình trong một khoảng thời gian
https://github.com/vietanhtran2710/network-performance-evaluation

## Hướng dẫn chạy file script:

1. Tính thông lượng trung bình của từng kết nối:
`python3 averageThroughput.py <tên file trace> <tên kết nối>`
Ví dụ: 
`python3 averageThroughput.py out.tf tcp0`
`python3 averageThroughput.py out.tf tcp1`
`python3 averageThroughput.py out.tf tcp2`
`python3 averageThroughput.py out.tf udp`

2. Tính độ trễ trung bình của các gói tin theo từng kết nôi:
`python3 averageDelay.py <tên file trace> <tên kết nối>`
Ví dụ: 
`python3 averageDelay.py out.tf tcp0`
`python3 averageDelay.py out.tf tcp1`
`python3 averageDelay.py out.tf tcp2`
`python3 averageDelay.py out.tf udp`
