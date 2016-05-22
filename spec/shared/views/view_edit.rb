shared_examples_for "background" do
  describe "background" do
    before do
      create_variables(model)
    end

    it "should render background info field in edit mode if settings require so" do
      Setting.background_info = [model]

      render partial: @models + "/edit", locals: {edit: true}
      expect(rendered).to have_tag("textarea[id=#{@model}_background_info]")
    end

    it "should not render background info field if settings do not require so" do
      Setting.background_info = []

      render partial: @models + "/edit", locals: {edit: true}
      expect(rendered).not_to have_tag("textarea[id=#{@model}_background_info]")
    end
  end
end

shared_examples_for "edit_js_common" do
  describe "edit js should work properly" do
    before do
      create_variables(model)
    end

    it "should show [edit #{@model}] form" do
      params[:cancel] = "false"

      render template: "#{@models}/js/edit", formats: [:js]
      expect(rendered).to include("edit_#{@model}")
      expect(rendered).to include("crm.event.emit(EVENT_EDIT_START);")
    end

  end
end