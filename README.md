# Decidim::AccessRequests

[![Build Status](https://travis-ci.com/mainio/decidim-module-access_requests.svg?branch=master)](https://travis-ci.com/mainio/decidim-module-access_requests)
[![codecov](https://codecov.io/gh/mainio/decidim-module-access_requests/branch/master/graph/badge.svg)](https://codecov.io/gh/mainio/decidim-module-access_requests)

The gem has been developed by [Mainio Tech](https://www.mainiotech.fi/).

A [Decidim](https://github.com/decidim/decidim) module that provides a new
verification method that allows system administrators to define new verification
workflows where the admins can provide access to specific users.

This module does not itself register any verification workflows because these
access request workflows are generally specific to the system in question. For
example, if the admins want to provide access only for specific users to add
new proposals in a specific participatory space, they can define a new workflow
for that.

The access request workflow works as follows:

- User requests access against the registered workflow
- An admin will review the request
- Admin will either approve or reject the access request
- The user will get notified that their access request has been either approved
  or rejected

Alternatively, the admins can also provide access directly to specific users
from the admin panel. This way, the users won't have to create the access
requests themselves and they are automatically granted the access once the admin
has given it.

Development of this gem has been sponsored by the
[City of Helsinki](https://www.hel.fi/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-access_requests'
```

And then execute:

```bash
$ bundle
```

After installation, add this to your verifications initializer:

```ruby
# config/initializers/decidim_verifications.rb
Decidim::Verifications.register_workflow(:your_requests) do |workflow|
  workflow.engine = Decidim::AccessRequests::Verification::Engine
  workflow.admin_engine = Decidim::AccessRequests::Verification::AdminEngine
end
```

And finally, add these lines to your localization files to describe the workflow
you just registered:

```yaml
en:
  decidim:
    authorization_handlers:
      your_requests:
        explanation: An admin will approve or deny access
        name: Your access requests
```

## Usage

TODO

## Contributing

See [Decidim](https://github.com/decidim/decidim).

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
