SELECT
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
  questions_count = COUNT(user_responses.user_id)
