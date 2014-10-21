# This serves to update Task status from /orders/show/html.slim
#
# TODO: by @serj_prikhodko
# It should be validated that the user have permissions to mark task done
#
#
class TaskListsController < ApplicationController
  def update
    @task_list = TaskList.find(params[:id])
    @task_list.update_attributes(task_list_params)

    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def task_list_params
    params.require(:task_list).permit(tasks_attributes: [:id, :completed])
    # "task_list"=>{"tasks_attributes"=>{"0"=>{"completed"=>"1", "id"=>"dbdeea69-d013-4674-b8a2-5318a8072254"}}}
  end
end
