# frozen_string_literal: true

require "decidim/dev/common_rake"

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app"

desc "Generates a development app."
task :development_app do
  Bundler.with_original_env do
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--demo"
    )
  end

  # Copy the initializer and translation file to the development app folder
  base_path = __dir__
  source_path = "#{base_path}/lib/decidim/access_requests/generators/app_templates"
  target_path = "#{base_path}/development_app/config"
  FileUtils.cp(
    "#{source_path}/initializer.rb",
    "#{target_path}/initializers/decidim_verifications_access_requests.rb"
  )
  FileUtils.cp(
    "#{source_path}/en.yml",
    "#{target_path}/locales/decidim-access_requests.en.yml"
  )

  # Seed the DB after the initializer has been installed
  Dir.chdir("development_app") do
    system("bundle exec rake db:seed")
  end
end

# Run all tests, include all
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

# Run both by default
task default: [:spec]
