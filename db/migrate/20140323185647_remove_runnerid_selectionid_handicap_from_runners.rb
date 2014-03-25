class RemoveRunneridSelectionidHandicapFromRunners < ActiveRecord::Migration
	 def change
			remove_column :runners, :runner_id
			remove_column :runners, :selection_id
			remove_column :runners, :handicap
	 end
end
