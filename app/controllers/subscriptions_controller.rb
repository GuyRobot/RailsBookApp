# frozen_string_literal: true

#   reviews[book1] = 'Great reference!'
#   reviews[book2] = 'Nice and compact!'
#
#   reviews.length #=> 1
#
# See also Object#hash and Object#eql?
class SubscriptionsController < ApplicationController
  layout 'subscribe'
  before_action :authenticate_user!, except: %i[new create]

  def new
    redirect_to root_path, notice: 'You are already a subscriber' if user_signed_in? && current_user.subscribed?
  end

  def create
    Stripe.api_key = Rails.application.credentials.stripe_api_key
    plan_id = params[:plan_id]
    plan = Stripe::Plan.retrieve(plan_id)

    customer = if current_user.stripe_id?
                 Stripe::Customer.retrieve(current_user.stripe_id)
               else
                 Stripe::Customer.create(email: current_user.email, source: token)
               end

    subscription = customer.subscriptions.create(plan: plan.id)

    options = {
      stripe_id: customer.id,
      stripe_subscription_id: subscription.id,
      subscribed: true
    }

    if params[:user][:card_last4]
      options.merge!(
        card_last4: params[:user][:card_last4],
        card_exp_month: params[:user][:card_exp_month],
        card_exp_year: params[:user][:card_exp_year],
        card_type: params[:user][:card_type]
      )
    end

    current_user.update(options)

    redirect_to root_path, notice: 'Your subscription was setup successfully'
  end

  def destroy
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    customer.subscriptions.retrieve(current_user.stripe_subscription_id).delete
    current_user.update(stripe_subscription_id: nil)
    current_user.subscribed = false

    redirect_to root_path, notice: 'Your subscription has been canceled.'
  end
end
