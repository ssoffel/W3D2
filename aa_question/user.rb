require_relative 'questions_database'
require_relative 'question'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'reply'
require 'byebug'
class User

  attr_accessor :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

    def self.find_by_id(id)

      data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
      *
      FROM
      users
      WHERE
      users.id = :id
      SQL

      User.new(data.first)

    end

    def self.find_by_name(fname, lname)
      data = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
      *
      FROM
      users
      WHERE
      users.fname = :fname AND users.lname = :lname
      SQL

      User.new(data.first)

    end

    def authored_questions
      Question.find_by_author_id(@id)
    end

    def authored_replies
      Reply.find_by_user_id(@id)
    end

    def followed_questions
      QuestionFollow.followed_questions_for_user_id(@id)
    end

    def likes_questions
      QuestionLike.liked_questions_for_user_id(@id)
    end
end
