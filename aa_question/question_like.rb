require_relative 'questions_database'
require 'byebug'
class QuestionLike

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

    def self.find_by_id(id)
      data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
      *
      FROM
      question_likes
      WHERE
      question_likes.id = :id
      SQL

      return nil if data.empty?
      QuestionLike.new(data.first)

    end

    def self.likers_for_question(question_id)
      data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
      users.*
      FROM
      question_likes
      JOIN users ON question_likes.user_id = users.id
      WHERE question_id = ?

      SQL
      return nil if data.empty?
      data.map { |datum| User.new(datum) }
    end

    def self.num_likes_for_question_id(question_id)
      data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
      count(user_id) AS num_likes
      FROM
      question_likes
      WHERE
      question_id = ?
      SQL
      data.first.values.first
    end

    def self.liked_questions_for_user_id(user_id)
      data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
        questions.*
        FROM
        question_likes
        JOIN
        questions ON question_id = questions.id
        WHERE
        question_likes.user_id = ?
        SQL

        return nil if data.empty?

        data.map { |datum| Question.new(datum) }

    end

    def self.most_liked_questions(n)
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT
        *
        FROM
        questions
        WHERE
        id =
        (SELECT
        question_id
        FROM
        question_likes
        GROUP BY
        question_id
        ORDER BY count(user_id) desc
        limit 1
        offset (? - 1)
        )
        SQL
        return nil if data.empty?

        data.map { |datum| Question.new(datum) }.first
    end





end
