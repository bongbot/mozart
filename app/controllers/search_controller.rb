# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class SearchController < ApplicationController
  before_action :load_ransack_search, only: :index

  def search
    @keyword = param_search[:keyword]

    if @keyword
      @result = []
      @entitiy_names = %w{Campaign Lead Account Contact Opportunity}
      @current_entity_name = @entitiy_names[0].downcase

      @entitiy_names.each_with_index do |entity_name, idx|
        if idx == 0
          scope = search_objects(@keyword, entity_name)
          @entities = scope
        else
          scope = search_objects(@keyword, entity_name)
        end

        key = entity_name.underscore.to_sym

        @result  << {
            key: key,
            count: scope.count
        }
      end

    else
      # todo
    end
  end

  def search_partial
    keyword = params[:keyword]
    model = params[:model]
    scope = search_objects(keyword, model)
    @entities = scope
    @current_entity_name = model

    respond_custom(:search)
  end

  def my_entities(name)
    klass = name.classify.constantize
    klass.my.merge(ransack_search(klass).result(distinct: true))
  end

  def search_objects(query, entity_name)
    scope = my_entities(entity_name)
    scope = scope.text_search(query)              if query.present?
    scope
  end

  def ransack_search(klass)
    @ransack_search = klass.search(params[:q])
    @ransack_search.build_grouping if @ransack_search.groupings.empty?

    @ransack_search.build_sort if @ransack_search.sorts.empty?
    @ransack_search
  end




  def param_search
    params.require(:search).permit(:keyword)
  end
end
