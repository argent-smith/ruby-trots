Given /^I found "([^"]*)" binary$/ do |arg1|
  system("bundle exec mkhotspot > /dev/null 2>&1").should be_true
end

When /^I run `([^`]*)` with the following options:$/ do |cmd, table|
  table.rows.each do |row|
    run_simple(unescape(cmd + " " + row.first), false)
  end
end

