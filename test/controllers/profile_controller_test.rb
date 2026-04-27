require "test_helper"

class ProfileControllerTest < ActionDispatch::IntegrationTest
  DEFAULTS = { name: "Napassawan korsinprasert", university: "ศิลปากร CS" }.freeze

  setup do
    Profile.destroy_all
  end

  test "GET /profile returns 200" do
    get profile_path
    assert_response :success
  end

  test "GET /profile creates profile with defaults if none exists" do
    get profile_path
    assert_equal 1, Profile.count
    assert_equal "Napassawan korsinprasert", Profile.first.name
  end

  test "GET /profile/edit returns 200" do
    get edit_profile_path
    assert_response :success
  end

  test "PATCH /profile with valid params redirects to profile" do
    get profile_path  # ensure profile exists
    patch profile_path, params: { profile: { name: "Bam", university: "SU" } }
    assert_redirected_to profile_path
    assert_equal "Bam", Profile.first.name
    assert_equal "SU", Profile.first.university
  end

  test "PATCH /profile with blank name renders edit" do
    get profile_path
    patch profile_path, params: { profile: { name: "", university: "SU" } }
    assert_response :unprocessable_entity
  end
end
