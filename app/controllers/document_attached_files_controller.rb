class DocumentAttachedFilesController < ApplicationController
  def destroy
    @attachment = DocumentAttachedFile.find(params[:id])
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end
