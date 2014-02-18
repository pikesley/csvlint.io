Then(/^I should see a page of validation results$/) do
  page.body.should include("Validation Results")
end

Then(/^I should see my URL$/) do
  page.body.should include(@url)
end

Then(/^my file should be persisted in the database$/) do
  Validation.count.should == 1
  Validation.first.filename.should == File.basename(@file)
end

Then(/^my url should be persisted in the database$/) do
  Validation.count.should == 1
  Validation.first.url.should == @url
  filename = File.basename(URI.parse(@url).path)
  Validation.first.filename.should == filename
end


Then(/^the database record should have a "(.*?)" of the type "(.*?)"$/) do |category, type|
  result = Marshal.load(Validation.first.result)
  result.send(category.pluralize).first.type.should == type.to_sym
end

Then(/^I should see my schema URL$/) do
  page.body.should include(@schema_url)
end

Then(/^the validation should be updated$/) do
  Validation.any_instance.should_receive(:update_attributes).once
end

Then(/^the validation should not be updated$/) do
  Validation.any_instance.should_not_receive(:update_attributes)
end

Given(/^it's two weeks in the future$/) do
  Timecop.freeze(2.weeks.from_now)
end

Then(/^I should be given the option to revalidate using a different dialect$/) do
  page.body.should include("The CSV you have specified seems to be invalid. You can try resubmitting it using a different dialect using the form below:")
end