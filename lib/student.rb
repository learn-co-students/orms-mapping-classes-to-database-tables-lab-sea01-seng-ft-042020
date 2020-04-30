class Student
  attr_accessor :name, :grade
  attr_reader :id
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  def save
    sql = <<-GRANDMA
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      GRANDMA
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  def self.create_table
    sql = <<-DERP
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
      DERP
    DB[:conn].execute(sql)
  end
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
  def self.drop_table
    sql = <<-POTATOES
      DROP TABLE students
      POTATOES
    DB[:conn].execute(sql)
  end
end
