module Documents
  class Accounter
    def self.sign(accountable)
      document = accountable.document
      serial_number = accountable.document.try(:sn)
      document.update_column(:approved_at, Time.now)
      document.update_column(:serial_number, serial_number)
    end
  end
end
