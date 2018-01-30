require_relative 'questions_database'
require_relative 'question_follow'
require_relative 'question_like'
require 'byebug'
class Question

  attr_accessor :title, :body

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

    def self.find_by_id(id)
      data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
      *
      FROM
      questions
      WHERE
      questions.id = :id
      SQL
      return nil if data.empty?
      Question.new(data.first)

    end

    def self.find_by_author_id(author_id)
      data = QuestionsDatabase.instance.execute(<<-SQL, author_id: author_id )
      SELECT
      *
      FROM
      questions
      WHERE
      questions.user_id = :author_id
      SQL
      return nil if data.empty?
      data.map { |datum| Question.new(datum) }
    end

    def self.most_followed(n)
      QuestionFollow.most_followed_questions(n)
    end

    def author
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id: @user_id)

    SELECT *
    FROM users
    WHERE users.id = :user_id
    SQL
    return nil if data.empty?
    User.new(data.first)
    end

    def replies
      Reply.find_by_question_id(@id)
    end

    def followers
      QuestionFollow.followers_for_question_id(@id)
    end

    def likers
      QuestionLike.likers_for_question(@id)
    end

    def num_likes
      QuestionLike.num_likes_for_question_id(@id)
    end


end
