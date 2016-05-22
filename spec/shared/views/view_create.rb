shared_examples_for "create_common" do
  describe "create should render success or error properly" do
    before do
      create_variables(model)
    end

    describe "create success" do
      before do
        assign(@model.to_sym, success_data)
        render template: "#{@models}/js/create", formats: [:js]
      end

      it "should redirect to index or back to resource page if successful" do
        expect(rendered).to include("window.location.href")
      end
    end

    describe "create failure" do
      it "should re-render [create] template in :create_#{@model} div" do
        assign(@model.to_sym, error_data) # make it invalid
        assign(:users, [current_user])

        render template: "#{@models}/js/create", formats: [:js]
        expect(rendered).to include("#edit_#{@model}")
        expect(rendered).to include(%/$('#edit_#{@model}').effect("shake"/)
      end
    end
  end
end