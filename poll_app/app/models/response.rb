class Response < ActiveRecord::Base
  validates :answer_choice_id, :user_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_cannot_answer_own_poll

  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  belongs_to(
    :respondent,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )

  def sibling_responses
    question.responses.where(':id IS NULL OR responses.id != :id', id: self.id)
  end

  # private
  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(user_id: self.user_id)
      errors[:respondent] << "can't answer same question more than once"
    end
  end

  def author_cannot_answer_own_poll
    polls_by_author = Poll.find_by_sql("
    SELECT
      polls.*
    FROM
      responses
    JOIN
      answer_choices ON answer_choices.id = responses.answer_choice_id
    JOIN
      questions ON answer_choices.question_id = questions.id
    JOIN
      polls ON questions.poll_id = polls.id
    WHERE
      polls.author_id = #{self.user_id}")

    unless polls_by_author.empty?
      errors[:poll_author] << "can't answer own poll"
    end
  end

end
