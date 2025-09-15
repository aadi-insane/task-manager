FactoryBot.define do
  factory :task_dependency do
    predecessor_id { "" }
    successor_id { "" }
    dependency_type { "MyString" }
  end
end
