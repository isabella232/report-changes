require "rails_helper"

RSpec.feature "Admin viewing dashboard" do
  scenario "admin can view login page" do
    visit admin_root_path

    expect(page).to have_content "Log in"
  end

  context "logged in admin" do
    let(:report) { create :report, :filled, change_type: "job_termination" }

    before do
      user = create(:admin_user)
      login_as(user)

      report.metadata.update consent_to_sms: "no"
      report.current_member.update first_name: "Todd", last_name: "Chavez"

      report.current_change.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )
      report.current_change.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
    end

    scenario "viewing details for a report" do
      visit admin_root_path

      expect(page).to have_content("Report")

      click_on report.id

      expect(page).to have_content("Report ##{report.id}")
      expect(page).to have_content("CONSENT TO SMS", "no")

      click_on report.reported_changes.last.id

      expect(page).to have_content("Change ##{report.reported_changes.last.id}")
    end

    context "with verifications" do
      scenario "viewing the pdf" do
        visit admin_root_path

        click_on "Download"

        pdf = PDF::Reader.new(StringIO.new(page.html))
        pdf_text = pdf.pages.first.text.gsub("\t", " ").gsub("\n", " ").squeeze(" ")
        pdf_attachment_text = pdf.pages.last.text

        expect(pdf_text).to have_content "Change Request Form"
        expect(pdf_text).to have_content "Todd Chavez"
        expect(pdf_text).to have_content "See attached"

        expect(pdf_attachment_text).to have_content "This is the test pdf contents."
      end
    end

    scenario "searching isn't broken", js: true do
      visit admin_root_path(search: "asdf")

      expect(page).to have_content("Report")
    end
  end
end
