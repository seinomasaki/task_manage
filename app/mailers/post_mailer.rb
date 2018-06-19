class PostMailer < ApplicationMailer
  default from: 'm.seino.ashita@gmail.com'

  def post_email(user, mk_user, task)
    @task = task
    @mk_user = mk_user
    mail to: user.email, subject: 'Taskの確認してください。'
  end
end
