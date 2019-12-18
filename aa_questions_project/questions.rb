require_relative "questions_db.rb"
require_relative "replies.rb"

class Question
    def self.find_by_author_id(author_id)
        questions_data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT * 
            FROM questions 
            WHERE questions.author_id = ?
        SQL
        questions_data.map {|datum| Question.new(datum) }
    end
        
    def self.find_by_id(id)
        questions_data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM questions 
            WHERE questions.id = ?
        SQL
        questions_data.map {|datum| Question.new(datum) }
    end
    
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end
    
    def author
        User.find_by_id(author_id)
    end

    def replies
        Reply.find_by_question_id(id)
    end

    def followers
        QuestionFollows.followers_for_question_id(id)
    end
    
    private
    attr_accessor :id, :title, :body, :author_id
end

