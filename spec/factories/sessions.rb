FactoryGirl.define do
  factory :user do
    trait :general do
      name 'seino'
      email 'seino@g.com'
      password 'pass'
      password_confirmation 'pass'
    end
    trait :admin do
      name 'gasdgad'
      email 'segasdgaino@g.com'
      password 'password'
      password_confirmation 'password'
      admin true
    end
  end
end