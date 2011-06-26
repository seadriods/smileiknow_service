class Notifier < ActionMailer::Base
  default :from => "customer-service@amazon.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_recieved.subject
  #
  def order_recieved(order)
    @order = order
    mail :to => order.user.email, :subject => "Amazon Seadriods Store Order Confirmation"
  end
end
