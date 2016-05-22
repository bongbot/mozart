shared_examples_for "destroy_common" do
  describe "should destroy in index page properly" do
    before do
      create_variables(model)
    end

    it "should blind up destroyed #{@model} partial" do
      expect(rendered).to include("slideUp")
    end

    it "should update pagination" do
      expect(rendered).to include("#paginate")
    end

    it "should update #{@models} toolbar" do
      expect(rendered).to include("#toolbar")
    end
  end
end