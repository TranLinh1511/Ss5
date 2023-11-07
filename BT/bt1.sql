CREATE DATABASE BT1;
USE BT1;
create table test
(
    test_id   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(30)
);
create table studentTest
(
    RN      INT,
    test_id INT,
    date    DATE,
    mark    INT,
    check ( mark < 10 ),
    CONSTRAINT pk_RN FOREIGN KEY (RN) REFERENCES student (RN),
    CONSTRAINT pk_test FOREIGN KEY (test_id) REFERENCES test (test_id),
    PRIMARY KEY (RN, test_id)
);
create table student
(
    RN     INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name   VARCHAR(50),
    age    INT,
    status INT
);
insert into student(name, age, status)
values ('Nguyen Van A', 18, 1),
       ('Nguyen Van B', 19, 1),
       ('Nguyen Van C', 20, 1),
       ('Nguyen Van D', 21, 1);

insert into student(name, age, status)
values ('Nguyen Van E', 28, 1);

insert into test(test_name)
values ('Van'),
       ('Su'),
       ('Dia');

INSERT INTO studentTest(RN, test_id, date, mark)
VALUES (1, 1, '2023-11-06', 8),
       (2, 1, '2023-11-06', 7),
       (3, 1, '2023-11-06', 8),
       (4, 1, '2023-11-06', 5),
       (1, 2, '2023-11-06', 6),
       (2, 2, '2023-11-06', 5),
       (3, 2, '2023-11-06', 3),
       (4, 2, '2023-11-06', 4);

create view vw1 as
select RN, test_id, date, mark
from studentTest;


-- todo  a. Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng: 15-55
alter table student
    add check ( age > 15 && age < 55 );
-- todo b. Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
alter table test
    add mark int default 0;
-- todo c. Thêm khóa chính cho bảng studenttest là (RN,TestID)
-- todo d. Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test
alter table test
    add unique (test_name);
-- todo e. Xóa ràng buộc duy nhất (unique) trên bảng Test
alter table test
    drop index test_name;
-- todo Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi
SELECT s.name, t.test_name, vw1.mark, vw1.date
FROM vw1
         JOIN student s ON vw1.RN = s.RN
         JOIN test t ON vw1.test_id = t.test_id;
-- todo Hiển thị danh sách các bạn học viên chưa thi môn nào
SELECT s.RN, s.name
FROM student s
WHERE s.RN NOT IN (select s.RN from studentTest s where mark is not null);
-- todo Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5)
SELECT s.name, t.test_name, vw1.mark
FROM vw1
         JOIN student s ON vw1.RN = s.RN
         JOIN test t ON vw1.test_id = t.test_id
where vw1.mark < 5;
select *
from vw1;

-- todo Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi. Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần
SELECT s.name, sum(t.mark) as average
FROM vw1
         JOIN student s ON vw1.RN = s.RN
         JOIN test t ON vw1.test_id = t.test_id
where t.mark is not null
group by s.name
order by average desc;

-- todo Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất
SELECT s.name, avg(t.mark) as average
FROM vw1
         JOIN student s ON vw1.RN = s.RN
         JOIN test t ON vw1.test_id = t.test_id
where t.mark = (select max(t.mark)
                from studentTest
                where t.test_id = vw1.test_id)
group by s.name;

-- todo Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học
SELECT t.test_name, MAX(st.mark) as max_mark
FROM test t
         JOIN studentTest st ON t.test_id = st.test_id
GROUP BY t.test_name
ORDER BY t.test_name;

-- todo Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null
SELECT s.name, t.test_name
from studentTest
         join student s on studentTest.RN = s.RN
         join bt1.test t on studentTest.test_id = t.test_id;

-- todo Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi
update student
set age = age + 1;

-- todo .Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student

ALTER TABLE Student
    MODIFY COLUMN Status VARCHAR(20);

-- todo Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’,
-- trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student

UPDATE Student
SET Status = CASE
                 WHEN age < 30 THEN 'Young'
                 ELSE 'Old'
    END;

select RN, name, age, status
from student;

-- todo Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi

select s.name, t.test_name, date
from vw1
         join student s on vw1.RN = s.RN
         join test t on vw1.test_id = t.test_id
order by date;