class BatchesController < ApplicationController
  def index
    @batches = Batch.all
  end
end
