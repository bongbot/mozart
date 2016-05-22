shared_examples_for "index_list" do
  describe "list view should be render properly" do
    before do
      create_variables(model)
    end

    it "should render list of accounts if list of #{@models} is not empty" do
      puts "TTT: " + @models.inspect + "/**#{__FILE__}:#{__LINE__}"
      assign(@models.to_sym, data)

      render
      expect(view).to render_template(partial: @_model)
      expect(view).to render_template(partial: "shared/_paginate_with_per_page")
    end

    it "should render a message if there're no #{@models}" do
      assign(@models.to_sym, [].paginate)

      render
      expect(view).not_to render_template(partial: @_models)
      expect(view).to render_template(partial: "shared/_empty")
      expect(view).to render_template(partial: "shared/_paginate_with_per_page")
    end
  end
end

shared_examples_for "index_js_common" do
  describe "list view should be render properly" do
    before do
      create_variables(model)
    end

    it "should render [#{@model}] template with @#{@models} collection if there are #{@models}" do
      assign(@models.to_sym, data)
      id = data[0].id

      render template: "#{@models}/js/index", formats: [:js]
      expect(rendered).to include("$('##{@models}').html('<li class=\\'#{@model} highlight\\' id=\\'#{@model}_#{id}\\'")
      expect(rendered).to include("#paginate")
    end

    it "should render [empty] template if @#{@models} collection if there are no #{@models}" do
      assign(@models.to_sym, [].paginate)

      render template: "#{@models}/js/index", formats: [:js]
      expect(rendered).to include("$('##{@models}').html('<div id=\\'empty\\'>")
      expect(rendered).to include("#paginate")

    end
  end
end