# frozen_string_literal: true

# 予定登録、編集処理のcontroller
class PlansController < ApplicationController
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

  private

  # パラメータの制限処理
  def plan_params
    params.require(:plan).permit(:title, :content, :all_day, :start_date, :start_time, :end_date, :end_time)
  end
end
