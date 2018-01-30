require_relative 'questions_database'
require_relative 'user'
require 'byebug'
class Reply

  attr_accessor :body

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @reply_id = options['reply_id']
  end

    def self.find_by_id(id)
      data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
      *
      FROM
      replies
      WHERE
      replies.id = :id
      SQL

      Reply.new(data.first)

    end

    def self.find_by_user_id(user_id)
      data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
      *
      FROM
      replies
      WHERE
      replies.user_id = :user_id
      SQL

      data.map { |datum| Reply.new(datum) }

    end

    def self.find_by_question_id(question_id)
      data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
      *
      FROM
      replies
      WHERE
      replies.question_id = :question_id
      SQL
      data.map { |datum| Reply.new(datum) }
    end

    def author
      User.find_by_id(@user_id)
    end

    def question
      Question.find_by_id(@question_id)
    end

    def parent_reply
      Reply.find_by_id(@reply_id)
    end

    def child_replies
      data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
      *
      FROM
      replies
      WHERE
      replies.reply_id = ?
      SQL

      return nil if data.empty?
      Reply.new(data.first)
    end

end
