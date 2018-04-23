class SummariesController < ApplicationController
  def tasks
    @tasks = task.all
  end
end
