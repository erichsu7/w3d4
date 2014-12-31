class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many(
    :authored_polls,
    class_name: "Poll",
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: 'Response',
    foreign_key: :user_id,
    primary_key: :id
  )

  def completed_polls_in_sql
    Poll.find_by_sql(
    [
      "SELECT
        polls.*, COUNT(DISTINCT questions.id) AS questions_count
      FROM
        polls
      JOIN
        questions ON questions.poll_id = polls.id
      JOIN
        answer_choices ON answer_choices.question_id = questions.id
      LEFT JOIN
        (
        SELECT
          responses.*
        FROM
          responses
        WHERE
          responses.user_id = ?
        )
      AS user_responses ON user_responses.answer_choice_id = answer_choices.id
      GROUP BY
        polls.id
      HAVING
        questions_count = COUNT(user_responses.user_id)",
        self.id]
    )
  end

  def completed_polls
    Poll.all
        .select('polls.*, COUNT(DISTINCT questions.id) AS questions_count')
        .joins("JOIN questions ON questions.poll_id = polls.id")
        .joins("JOIN answer_choices ON answer_choices.question_id = questions.id")
        .joins("LEFT OUTER JOIN (SELECT responses.* FROM responses
                WHERE responses.user_id = #{self.id})
                AS user_responses
                ON user_responses.answer_choice_id = answer_choices.id")
        .group("polls.id")
        .having("questions_count = COUNT(user_responses.user_id)")
  end

end
