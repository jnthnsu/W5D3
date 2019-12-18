require_relative "questions_db.rb"

class Reply
    def self.find_by_id(id)
        replies_data = QuestionsDatabase.instance.execute(<<-SQL,id)
            SELECT *
            FROM replies
            WHERE replies.id  = ?
        SQL
        replies_data.map {|datum| Reply.new(datum)}
    end
    
    def self.find_by_user_id(author_id)
        replies_data = QuestionsDatabase.instance.execute(<<-SQL,author_id)
            SELECT *
            FROM replies
            WHERE replies.reply_author_id  =  ?
        SQL
        replies_data.map {|datum| Reply.new(datum)}
    end
   
    def self.find_by_question_id(question_id)
        replies_data = QuestionsDatabase.instance.execute(<<-SQL,question_id)
            SELECT *
            FROM replies
            WHERE replies.question_id  =  ?
        SQL
        replies_data.map {|datum| Reply.new(datum)}

    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @reply_author_id = options['reply_author_id']
        @body = options['body']
    end

    def author
        User.find_by_id(reply_author_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        raise "this is a main reply" if parent_reply_id.nil? #AKA !parent_reply_id.is_a?(Integer) 
        Reply.find_by_id(parent_reply_id)
    end

    def child_replies
        child_data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL

        child_data.map {|datum| Reply.new(datum)}
    end
    

    private 
    attr_accessor :id, :question_id, :parent_reply_id, :reply_author_id, :body
end
