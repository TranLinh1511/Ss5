CREATE DATABASE Session_5_BT;
USE Session_5_BT;
CREATE TABLE students
(
    student_id    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    student_name  VARCHAR(20),
    student_age   INT,
    student_email VARCHAR(255)
);
CREATE TABLE subjects
(
    subject_id   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(20)
);
CREATE TABLE classes
(
    class_id   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(20)
);

CREATE TABLE class_student
(
    class_student_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    student_id       INT,
    class_id         INT,
    CONSTRAINT student_pkey FOREIGN KEY (student_id) REFERENCES students (student_id),
    CONSTRAINT subject_pkey FOREIGN KEY (class_id) REFERENCES classes (class_id)
);
CREATE TABLE marks
(
    mark_id    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    mark       INT,
    subject_id INT,
    check ( mark <= 10 ),
    CONSTRAINT student_pk FOREIGN KEY (student_id) REFERENCES students (student_id),
    CONSTRAINT subject_pk FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
);


DELIMITER //
CREATE PROCEDURE proc_getAll_student()
BEGIN
    SELECT * FROM students;
END //
CREATE PROCEDURE proc_getAll_subject()
BEGIN
    SELECT * FROM subjects;
END //
CREATE PROCEDURE proc_getAll_classes()
BEGIN
    SELECT * FROM classes;
END //
CREATE PROCEDURE proc_getAll_marks()
BEGIN
    SELECT * FROM marks;
END //
-- INSERT
CREATE PROCEDURE proc_insert_student(IN st_name VARCHAR(20), IN st_age INT, IN st_email VARCHAR(255))
BEGIN
    INSERT INTO students(student_name, student_age, student_email) VALUE (st_name, st_age, st_email);
END //
--
CREATE PROCEDURE proc_insert_marks(IN st_id INT, IN sj_id INT, IN markSet INT)
BEGIN
    INSERT INTO marks(student_id, subject_id, mark) VALUE (st_id, sj_id, markSet);
END //
--
CREATE PROCEDURE proc_insert_subject(IN sj_name VARCHAR(50))
BEGIN
    INSERT INTO subjects(subject_name) VALUE (sj_name);
END //
--
CREATE PROCEDURE proc_insert_class(IN cl_name VARCHAR(50))
BEGIN
    INSERT INTO classes(class_name) VALUE (cl_name);
END //
--
CREATE PROCEDURE proc_add_student_in_class(IN st_id INT, IN cl_id INT)
BEGIN
    INSERT INTO class_student(student_id, class_id) VALUE (st_id, cl_id);
END //
DELIMITER ;


/*
Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)
Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
Loai bo tat ca quan he giua cac bang
Xoa hoc vien co StudentID la 1
Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
Cap nhap gia tri Status trong bang Student thanh 0
 */
-- Main

-- TODO : Hien thi danh sach tat ca cac mon hoc
CALL proc_getAll_student();
-- TODO : Hiển thị danh sách các môn học
CALL proc_getAll_subject();
-- TODO : Tinh diem trung binh
SELECT student_name, avg(mark) AS avg
FROM students
         JOIN marks st on students.student_id = st.student_id
GROUP BY student_name;
-- TODO : Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
SELECT s.subject_name, st.student_name, m.mark
FROM subjects s
         JOIN marks m ON s.subject_id = m.subject_id
         JOIN students st on st.student_id = m.student_id
WHERE m.mark = (SELECT MAX(mark) FROM marks WHERE subject_id = s.subject_id)
ORDER BY m.mark DESC;
;
-- TODO : Danh so thu tu cua diem theo chieu giam
SELECT subject_name, student_name, mark
FROM subjects
         JOIN marks m on subjects.subject_id = m.subject_id
         JOIN students s on s.student_id = m.student_id
ORDER BY mark DESC;
-- TODO : Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
SELECT subject_name as "Đây là môn học"
FROM subjects;
-- TODO : Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
ALTER TABLE students
    ADD CHECK ( student_age > 15 && students.student_age < 50);
-- TODO : Xoa hoc vien co StudentID la 1
DELETE
FROM students
WHERE student_id = 1;
