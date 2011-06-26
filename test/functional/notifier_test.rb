require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "order_recieved" do
    mail = Notifier.order_recieved
    assert_equal "Order recieved", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
