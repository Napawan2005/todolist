require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  test "first_or_create returns a profile with defaults" do
    profile = Profile.first_or_create(name: "Test User", university: "Test U")
    assert profile.persisted?
    assert_equal "Test User", profile.name
    assert_equal "Test U", profile.university
  end

  test "calling first_or_create twice returns same record" do
    Profile.first_or_create(name: "A", university: "B")
    assert_equal 1, Profile.count
    Profile.first_or_create(name: "A", university: "B")
    assert_equal 1, Profile.count
  end
end
