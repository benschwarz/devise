require 'test_helper'

class ResetPasswordInstructionsTest < ActionMailer::TestCase

  def setup
    setup_mailer
    Devise.mailer_sender = 'test@example.com'
  end

  def user
    @user ||= begin
      user = create_user
      user.send_reset_password_instructions
      user
    end
  end

  def mail
    @mail ||= begin
      user
      ActionMailer::Base.deliveries.last
    end
  end

  test 'email sent after reseting the user password' do
    assert_not_nil mail
  end

  test 'content type should be set to html' do
    assert mail.content_type.include?('text/html')
  end

  test 'send confirmation instructions to the user email' do
    assert_equal [user.email], mail.to
  end

  test 'setup sender from configuration' do
    assert_equal ['test@example.com'], mail.from
  end

  test 'setup subject from I18n' do
    store_translations :en, :devise => { :mailer => { :reset_password_instructions => { :subject => 'Reset instructions' } } } do
      assert_equal 'Reset instructions', mail.subject
    end
  end

  test 'subject namespaced by model' do
    store_translations :en, :devise => { :mailer => { :reset_password_instructions => { :user_subject => 'User Reset Instructions' } } } do
      assert_equal 'User Reset Instructions', mail.subject
    end
  end

  test 'body should have user info' do
    assert_match(/#{user.email}/, mail.body.encoded)
  end

  test 'body should have link to confirm the account' do
    host = ActionMailer::Base.default_url_options[:host]
    reset_url_regexp = %r{<a href=\"http://#{host}/users/password/edit\?reset_password_token=#{user.reset_password_token}">}
    assert_match reset_url_regexp, mail.body.encoded
  end

  test 'mailer sender accepts a proc' do
    swap Devise, :mailer_sender => proc { "another@example.com" } do
      assert_equal ['another@example.com'], mail.from
    end
  end
end
