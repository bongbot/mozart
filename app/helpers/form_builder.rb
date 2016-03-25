# module SimpleForm
#   class FormBuilder
#     def input_mz(attribute_name, options = {}, &block)
#       edit = options[:edit] || false
#       if edit
#         self.input(attribute_name, options = {}, &block)
#       else
#         self[field.name]
#       end
#     end
#   end
# end