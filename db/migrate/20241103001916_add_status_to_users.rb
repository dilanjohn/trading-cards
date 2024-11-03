class AddStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :status, :string, default: 'pending'
    
    # Update existing users
    reversible do |dir|
      dir.up do
        # Set approved users to 'approved'
        execute <<-SQL
          UPDATE users 
          SET status = 'approved' 
          WHERE approved = true;
        SQL
      end
    end
  end
end