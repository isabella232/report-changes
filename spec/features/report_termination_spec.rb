require "rails_helper"

RSpec.feature "Reporting a change", js: true do
  scenario "job termination" do
    visit "/"
    expect(page).to have_text "Report job changes"

    click_on "Start my report", match: :first
    expect(page).to have_text "Welcome! Here’s how reporting a change works"

    click_on "Start the form"
    expect(page).to have_text "do you live in Arapahoe County?"

    choose "I'm not sure"
    click_on "Continue"

    expect(page).to have_text "Where do you live?"

    fill_in "Street address", with: "1355 South Laredo Court"
    fill_in "City", with: "Aurora"
    fill_in "Zip code", with: "80017"
    click_on "Continue"
    expect(page).to have_text "Great, it looks like you live in Arapahoe County."
    click_on "Continue"
    expect(page).to have_text "Tell us about yourself."

    fill_in "What is your name?", with: "Jane Doe"
    fill_in "What is your phone number?", with: "555-222-3333"
    select "January", from: "form[birthday_month]"
    select "1", from: "form[birthday_day]"
    select 20.years.ago.year.to_s, from: "form[birthday_year]"
    click_on "Continue"

    expect(page).to have_text "Tell us about the job that ended"

    fill_in "What is the name of the company?", with: "Abc Corp"
    fill_in "What is the name of someone from the company who can verify your employment?", with: "My boss"
    fill_in "What is their phone number?", with: "999-888-7777"
    select "February", from: "form[last_day_month]"
    select "2", from: "form[last_day_day]"
    select "2018", from: "form[last_day_year]"
    select "February", from: "form[last_paycheck_month]"
    select "12", from: "form[last_paycheck_day]"
    select "2018", from: "form[last_paycheck_year]"
    click_on "Continue"

    expect(page).to have_text "Do you have proof of this change?"

    click_on "Continue"

    expect(page).to have_text "Do you have a letter?"

    choose "Yes, I have this with me"
    click_on "Continue"

    expect(page).to have_text "Add your letter."

    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"
    click_on "Continue"

    expect(page).to have_text "May we send you text messages"
    expect(page).to have_text "We'll send them to (555) 222-3333"
    choose "Yes"

    click_on "Continue"

    expect(page).to have_text "Sign your change report"
    fill_in "Type your full legal name", with: "Person McPeoples"
    click_on "Sign and submit"

    expect(page).to have_text "You have successfully submitted your change report"
    choose "Good", allow_label_click: true
    fill_in "Do you have any feedback for us?", with: "My feedback"
    click_on "Submit"

    expect(page).to have_content("Thanks for your feedback")
  end
end
