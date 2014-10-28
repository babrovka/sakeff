# This serves to update Task status from /orders/show/html.slim
#
# TODO: by @serj_prikhodko
# It should be validated that the user have permissions to mark task done
#
#
class Documents::TaskListsController < ApplicationController
  def update
    @task_list = Documents::TaskList.find(params[:id])
    @task_list.update_attributes(task_list_params)

    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def task_list_params
    params.require(:documents_task_list).permit(tasks_attributes: [:id, :completed])
  end
end
