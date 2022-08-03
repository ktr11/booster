# frozen_string_literal: true

# 予定登録、編集処理のcontroller
class PlansController < ApplicationController
  before_action :logged_in_user, only: %i[new create edit update destroy done]

  # 予定登録画面の初期表示
  def new
    @plan = Plan.new
  end

  # 予定登録処理
  def create
    @plan = current_user.plans.build(plan_params)
    if @plan.save
      flash[:info] = '予定を登録しました。'
      redirect_to @plan
    else
      render 'new'
    end
  end

  # 予定詳細画面
  def show
    @plan = Plan.find(params[:id])
  end

  # 予定編集 初期表示
  def edit
    @plan = Plan.find(params[:id])
  end

  # 予定更新
  def update
    @plan = Plan.find(params[:id])
    if @plan.update(plan_params)
      flash[:success] = '予定を更新しました。'
      redirect_to @plan
    else
      render 'edit'
    end
  end

  # 予定削除
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    flash[:success] = '予定を削除しました。'
    redirect_to root_path
  end

  # 予定完了
  def done
    @plan = Plan.find(params[:id])
    if @plan.update(plan_params_done)
      flash[:success] = '予定を完了しました。' if @plan.done
      redirect_to @plan
    else
      render 'show'
    end
  end

  private

  # パラメータの制限処理(登録、更新時)
  def plan_params
    params.require(:plan).permit(:title, :content, :all_day, :start_date, :start_time, :end_date, :end_time)
  end

  # パラメータの制限処理(完了更新時)
  def plan_params_done
    params.require(:plan).permit(:done, :actual_time)
  end
end
