require_relative 'questions_database'
require_relative 'user'
require 'byebug'
class QuestionFollow

  def initialize(options)
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id )
    SELECT
    users.*
    FROM
    question_follows
    JOIN
    users ON question_follows.user_id  = users.id
    WHERE
    question_id = :question_id
    SQL

    data.map { |datum| User.new(datum) }

  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
    questions.*
    FROM
    question_follows
    JOIN
    questions ON question_follows.question_id = questions.id
    WHERE
    question_follows.user_id = ?
    SQL

    data.map { |datum| Question.new(datum) }

  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
    question_id
    FROM
    question_follows
    GROUP BY
    question_id
    ORDER BY count(user_id) desc
    limit 1
    offset (? - 1)
    SQL
    return nil if data.empty?
    Question.find_by_id(data.first['question_id'])
  end




end
