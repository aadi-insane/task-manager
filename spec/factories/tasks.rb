FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    project { nil }
    parent_id { 1 }
    assignee { nil }
    status { "MyString" }
    priority { 1 }
    starts_at { "2025-09-15 15:11:14" }
    due_at { "2025-09-15 15:11:14" }
  end
end
