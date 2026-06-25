use UniversityManagement;
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Admin','Faculty','Student')),
    Email VARCHAR(100) UNIQUE NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    Budget DECIMAL(12,2),
    OfficeLocation NVARCHAR(100)
);

CREATE TABLE Students (
    StudentID VARCHAR(10) PRIMARY KEY,
    UserID INT UNIQUE,
    FullName NVARCHAR(100) NOT NULL,
    Gender CHAR(1),
    BirthDate DATE,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address NVARCHAR(200),
    DepartmentID INT,
    AdmissionDate DATE DEFAULT GETDATE(),

    FOREIGN KEY(UserID) REFERENCES Users(UserID),
    FOREIGN KEY(DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
    InstructorID VARCHAR(10) PRIMARY KEY,
    UserID INT UNIQUE,
    FullName NVARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    DepartmentID INT,

    FOREIGN KEY(UserID) REFERENCES Users(UserID),
    FOREIGN KEY(DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Courses (
    CourseID VARCHAR(10) PRIMARY KEY,
    CourseName NVARCHAR(100),
    Credits INT,
    DepartmentID INT,
    InstructorID VARCHAR(10),

    FOREIGN KEY(DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY(InstructorID) REFERENCES Instructors(InstructorID)
);

CREATE TABLE CoursePrerequisites (
    CourseID VARCHAR(10),
    PrerequisiteCourseID VARCHAR(10),

    PRIMARY KEY(CourseID, PrerequisiteCourseID),

    FOREIGN KEY(CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY(PrerequisiteCourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Rooms (
    RoomID INT IDENTITY(1,1) PRIMARY KEY,
    RoomNumber VARCHAR(20),
    Capacity INT
);

CREATE TABLE TimeSlots (
    TimeSlotID INT IDENTITY(1,1) PRIMARY KEY,
    DayOfWeek VARCHAR(20),
    StartTime TIME,
    EndTime TIME
);

CREATE TABLE CourseSchedule (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID VARCHAR(10),
    RoomID INT,
    TimeSlotID INT,

    FOREIGN KEY(CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY(RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY(TimeSlotID) REFERENCES TimeSlots(TimeSlotID)
);

CREATE TABLE Enrollment (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID VARCHAR(10),
    CourseID VARCHAR(10),
    EnrollDate DATE DEFAULT GETDATE(),

    FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY(CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Grades (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentID INT UNIQUE,
    Grade CHAR(2),

    CHECK (Grade IN
    ('A','A-','B+','B','B-',
     'C+','C','C-','D','F')),

    FOREIGN KEY(EnrollmentID)
    REFERENCES Enrollment(EnrollmentID)
);

CREATE TABLE AcademicAdvisors (
    AdvisorID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID VARCHAR(10),
    InstructorID VARCHAR(10),

    FOREIGN KEY(StudentID)
        REFERENCES Students(StudentID),

    FOREIGN KEY(InstructorID)
        REFERENCES Instructors(InstructorID)
);

