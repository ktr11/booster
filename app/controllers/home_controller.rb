# frozen_string_literal: true

# Home画面のcontroller
class HomeController < ApplicationController
  # Home画面
  def home
    @plans = current_user.plans.order(start_date: :asc, start_time: :asc) if logged_in?
  end
end
