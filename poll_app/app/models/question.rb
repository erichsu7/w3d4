class Question < ActiveRecord::Base
  validates :text, presence: true

  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :answer_choices,
    class_name: 'AnswerChoice',
    foreign_key: :question_id,
    primary_key: :id
  )

  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )

  def results_n_plus_one
    results = {}
    answer_choices.each do |answer_choice|
      results[answer_choice.text] = answer_choice.responses.length
    end
    results
  end

  def results
    answer_choices_with_counts = self.answer_choices
                              .select("answer_choices.*, COUNT(responses.answer_choice_id) AS responses_count")
                              .joins("LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_choice_id")
                              .group("answer_choices.id")

    answer_choices_with_counts.map do |answer_choice|
    [answer_choice.text, answer_choice.responses_count]
    end
  end
end
