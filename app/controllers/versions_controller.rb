class VersionsController < ApplicationController

  def index
    version = {
      level: "info",
      message: "This is an API application. Please check the documents to interact with it.",
      data: {
        version: {
          major: 0,
          minor: 1,
          revision: 1
        }
      }
    }
    render json: version, status: 200
  end

end
