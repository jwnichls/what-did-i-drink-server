class DropMailingListTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :mailing_list_emails
  end
end
