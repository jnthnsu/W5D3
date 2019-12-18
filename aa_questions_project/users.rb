require_relative "questions_db.rb"
require_relative "questions.rb"
require_relative "replies.rb"

# def self.all
#     data = PlayDBConnection.instance.execute("SELECT * FROM playwrights")
#     data.map {|datum| Playwright.new(datum)}
#   end
  
class User
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map {|datum| User.new(datum)}
    end
    
    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(
            "SELECT * 
            FROM users 
            WHERE users.id = ?", id
            )
        data.map {|datum| User.new(datum) }
    end

    def self.find_by_name(fname,lname)
        data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT * 
            FROM users 
            WHERE users.fname = ?
                AND users.lname = ?
        SQL
        data.map {|datum| User.new(datum) }
    end
    
    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end
    
    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end
    
    def followed_questions
        QuestionFollows.followed_questions_for_user_id(id)
    end

    private    
    attr_accessor :id, :fname, :lname

end

