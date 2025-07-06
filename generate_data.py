
from faker import Faker
import random
from datetime import datetime, timedelta

fake = Faker()

# Constants for numbers of records
NUM_STUDENTS = 60
NUM_INSTRUCTORS = 15
NUM_COURSES = 60
NUM_OFFERINGS = 15
NUM_ENROLLMENTS = 25
NUM_PREREQUISITES = 5

years = ['Year 1', 'Year 2', 'Year 3', 'Year 4']
majors = ['Computer Science', 'Mathematics', 'Engineering', 'Physics', 'Biology', 'Chemistry', 'Economics']

departments = ['Computer Science', 'Mathematics', 'Engineering', 'Physics', 'Biology', 'Chemistry', 'Economics']

semesters = ['Fall 2025', 'Spring 2026', 'Summer 2026']

grades = [
    ('A', 4.00), ('A-', 3.70), ('B+', 3.30), ('B', 3.00),
    ('B-', 2.70), ('C+', 2.30), ('C', 2.00), ('D', 1.00), ('F', 0.00)
]

def sql_string(val):
    return "'" + val.replace("'", "''") + "'"  # escape single quotes for SQL

print("-- Insert Students")
for i in range(1, NUM_STUDENTS+1):
    first = fake.first_name()
    last = fake.last_name()
    email = f"{first.lower()}.{last.lower()}{i}@example.com"
    phone = fake.phone_number()
    major = random.choice(majors)
    year = random.choice(years)
    print(f"INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES "
          f"({sql_string(first)}, {sql_string(last)}, {sql_string(email)}, {sql_string(phone)}, {sql_string(major)}, {sql_string(year)});")

print("\n-- Insert Instructors")
for i in range(1, NUM_INSTRUCTORS+1):
    first = fake.first_name()
    last = fake.last_name()
    email = f"{first.lower()}.{last.lower()}{i}@university.edu"
    dept = random.choice(departments)
    print(f"INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES "
          f"({sql_string(first)}, {sql_string(last)}, {sql_string(email)}, {sql_string(dept)});")

print("\n-- Insert Courses")
for i in range(1, NUM_COURSES+1):
    dept = random.choice(departments)
    course_code = f"{dept[:2].upper()}{100 + i}"
    title = f"Intro to {dept} {i}"
    credits = random.choice([3, 4])
    print(f"INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES "
          f"({sql_string(course_code)}, {sql_string(title)}, {credits}, {sql_string(dept)});")

print("\n-- Insert CourseOfferings")
for i in range(1, NUM_OFFERINGS+1):
    course_id = random.randint(1, NUM_COURSES)
    semester = random.choice(semesters)
    instructor_id = random.randint(1, NUM_INSTRUCTORS)
    schedule = random.choice([
        'Mon/Wed 10:00-11:30', 'Tue/Thu 09:00-10:30',
        'Mon/Wed/Fri 11:00-12:00', 'Tue/Thu 13:00-14:30',
        'Mon/Wed 14:00-15:30'
    ])
    print(f"INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES "
          f"({course_id}, {sql_string(semester)}, {instructor_id}, {sql_string(schedule)});")

print("\n-- Insert Grades")
for i, (grade, score) in enumerate(grades, 1):
    print(f"INSERT INTO Grades (Grade_ID, Grade, Grade_Score) VALUES "
          f"({i}, {sql_string(grade)}, {score});")

print("\n-- Insert Enrollments")
for i in range(1, NUM_ENROLLMENTS+1):
    student_id = random.randint(1, NUM_STUDENTS)
    offering_id = random.randint(1, NUM_OFFERINGS)
    enroll_date = fake.date_between(start_date='-1y', end_date='today').strftime('%Y-%m-%d')
    # 70% chance of having a grade, else NULL
    if random.random() < 0.7:
        grade_id = random.randint(1, len(grades))
    else:
        grade_id = 'NULL'
    print(f"INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES "
          f"({student_id}, {offering_id}, '{enroll_date}', {grade_id});")

print("\n-- Insert Prerequisites")
added_pairs = set()
while len(added_pairs) < NUM_PREREQUISITES:
    course = random.randint(1, NUM_COURSES)
    prereq = random.randint(1, NUM_COURSES)
    if prereq != course and (course, prereq) not in added_pairs:
        added_pairs.add((course, prereq))
        print(f"INSERT INTO Prerequisites (CourseID, PrerequisiteID) VALUES ({course}, {prereq});")
