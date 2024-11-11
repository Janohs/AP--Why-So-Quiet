# shows the list of users examples
class ExamplesController < ApplicationController
    def index
        @examples = Example.all
    end

    def shows
        @example = Example.find(params[:id])
    end
end
