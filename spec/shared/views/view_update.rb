shared_examples_for "update_common" do
  describe "update should render success or error properly" do
    before do
      create_variables(model)
      instance_variable_set("@#{@model}".to_sym, data)
    end

    describe "no errors:" do
      it "should flip render #{@model} and emit edit ok" do
        id = data.id

        render template: "#{@models}/js/update", formats: [:js]
        expect(rendered).to include("#{@model}_#{id}")
        expect(rendered).to include("crm.event.emit(EVENT_EDIT_OK);")
      end

      it "should update recently" do
        render template: "#{@models}/js/update", formats: [:js]
        expect(rendered).to include("$('#recently').replaceWith")
      end
    end # no errors

    describe "validation errors:" do
      before do
        instance_variable_get("@#{@model}").errors.add(:name)
      end

      it "should redraw the [edit_#{@model}] form and shake it" do
        render template: "#{@models}/js/update", formats: [:js]

        expect(rendered).to include("#edit_#{@model}")
        expect(rendered).to include(%/$('#edit_#{@model}').effect("shake"/)
        expect(rendered).to include('focus()')
        expect(rendered).to include("crm.event.emit(EVENT_EDIT_NG);")
      end
    end # errors
  end
end