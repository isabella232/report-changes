class SignSubmitForm < Form
  set_attributes_for :change_report, :signature

  validates_presence_of :signature, message: "Make sure you enter your full legal name"
end