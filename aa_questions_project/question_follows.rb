require_relative "questions_db.rb"
require_relative "questions.rb"
require_relative "users"

class QuestionFollows

    def self.followers_for_question_id(question_id) # who follows this question
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                who_follows.id, who_follows.fname, who_follows.lname
            FROM
                (users JOIN question_follows 
                    ON users.id = question_follows.user_id) 
                    AS who_follows
            WHERE
                who_follows.question_id = ?
        SQL
        data.map {|datum| User.new(datum)}
    end
    
    def self.followed_questions_for_user_id(user_id) # what questions is this user following
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                whatchu_following.id, whatchu_following.title, whatchu_following.body, whatchu_following.author_id
            FROM
                (questions JOIN question_follows
                    ON questions.id = question_follows.question_id)
                    AS whatchu_following
            WHERE
                whatchu_following.user_id = ?
        SQL
        data.map {|datum| Question.new(datum)}
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    private
    attr_accessor
end

