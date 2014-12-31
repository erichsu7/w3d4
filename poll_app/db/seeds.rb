# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

eric = User.create!(user_name: 'erichsu')
ben = User.create!(user_name: 'beneng')
archer = User.create!(user_name: 'archer')

poll = Poll.create!(title: 'Favorite color and food', author_id: 1)

q1 = Question.create!(text: 'What is your favorite color?', poll_id: 1)
q2 = Question.create!(text: 'What is your favorite food?', poll_id: 1)

ac1 = AnswerChoice.create!(text: 'Blue', question_id: 1)
ac2 = AnswerChoice.create!(text: 'Red', question_id: 1)
ac3 = AnswerChoice.create!(text: 'Yellow', question_id: 1)

ac4 = AnswerChoice.create!(text: 'Burgers', question_id: 2)
ac5 = AnswerChoice.create!(text: 'Hot dogs', question_id: 2)
ac6 = AnswerChoice.create!(text: 'Pizza', question_id: 2)

r1 = Response.create!(answer_choice_id: 2, user_id: 1)
r2 = Response.create!(answer_choice_id: 1, user_id: 2)
r3 = Response.create!(answer_choice_id: 2, user_id: 3)
r4 = Response.create!(answer_choice_id: 6, user_id: 1)
r5 = Response.create!(answer_choice_id: 4, user_id: 2)
r6 = Response.create!(answer_choice_id: 4, user_id: 3)
