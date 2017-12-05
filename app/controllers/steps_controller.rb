class StepsController < ApplicationController

  # Steps are children of lessons. This controller handles the CRUD of a step,
  # but must always have a lesson id provided.

  before_action :authenticate_user!
  before_action :set_lesson, only: [:index, :new, :show, :edit, :update, :destroy]
  before_action :set_step, only: [:show, :edit, :update, :destroy]

  def index

    @steps = Step.all

    # Specify section as steps for use in sub nav
    @section = :steps

  end

  def show

  end

  def new

    # Simmilar to lessons, create a step and then immediately hand off to edit
    @step_obj = Step.create!(
      lesson_id: @lesson_obj.id,
      summary: ""
    )

    redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @step_obj.id) if @step_obj.present?

  end

  def edit

    # If the step isn't found, return to index
    unless @step_obj.present?
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id)
      return
    end

  end

  def create

    @step_obj = Step.new(step_params)

    # TODO: if create param is set, we need to redirect to new

    respond_to do |format|
      if @step_obj.save
        format.html { redirect_to @step_obj, notice: 'Step was successfully created.' }
        format.json { render :show, status: :created, location: @step_obj }
      else
        format.html { render :new }
        format.json { render json: @step_obj.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      puts step_params.inspect

      # # TODO - duration fails because no slider...
      filtred_params = step_params
      # filtred_params.delete(:duration)
      # @step_obj.duration = 0

      if @step_obj.update(filtred_params)
        format.html { redirect_to @step_obj, notice: 'Step was successfully updated.' }
        format.json { render :show, status: :ok, location: @step_obj }
      else
        format.html { render :edit }
        format.json { render json: @step_obj.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    # If the step isn't found, return to index
    unless @step_obj.present?
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id)
      return
    end

    # Lessons must always have one step, so don't destroy it if it's the last one
    if @lesson_obj.steps.count >= 2

      # Destroy the step
      @step_obj.destroy

      # Redirect to the lessons first step
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id), notice: 'Step was deleted.'

    else

      # Don't destroy the step, return to edit
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @step_obj.id), notice: 'A lesson needs at least one step'

    end

  end

  private

    def set_step
      @step_obj = Step.find_by_id(params[:id])
    end

    def step_params
      params.fetch(:step).permit(
        :name,
        :duration,
        :description,
        materials: [],
        fabrication_equipment: [],
        software: [],
        external_links: []
      )
    end

end
