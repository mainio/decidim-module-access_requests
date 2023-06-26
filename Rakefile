# frozen_string_literal: true

require "decidim/dev/common_rake"

def install_module(path)
  Dir.chdir(path) do
    # Temporary fix to overcome the issue with sass-embedded, see:
    # https://github.com/decidim/decidim/pull/11074
    system("npm i sass-embedded@~1.62.0")
  end
end

# Temporary fix to overcome the issue with babel plugin updates, see:
# https://github.com/decidim/decidim/pull/10916
def fix_babel_config(path)
  Dir.chdir(path) do
    babel_config = "#{Dir.pwd}/babel.config.json"
    File.delete(babel_config) if File.exist?(babel_config)
    FileUtils.cp("#{__dir__}/babel.config.json", Dir.pwd)
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  fix_babel_config("spec/decidim_dummy_app")
  install_module("spec/decidim_dummy_app")
end

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

  fix_babel_config("development_app")
  install_module("development_app")

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
