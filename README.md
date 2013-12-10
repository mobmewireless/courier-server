# Courier Server

This is the server component of the Courier application suite. It manages registration of clients and receivers, and the
delivery of messages received from clients to receivers via the service provider's message delivery platform (only
Google Cloud Messaging, at the moment).

# Prerequisites

To run this web application, you'll need:

1.  A server with Ruby 2.0+.
2.  A Rack-compatible web server. In our opinion,
    [Phusion Passenger](https://www.phusionpassenger.com/) is the easiest way to get going (it has
    [excellent documentation](https://www.phusionpassenger.com/install_gem)).
3.  A database server - preferably MySQL, since that's what this application has been tested with, though others such as
    SQLite and PostGRESql should work just fine.

You'll also need to set up a Google project, enable the GCM service on it, and create a 'registered app' with OAuth 2.0
Client ID (Google login) and Server Key (pushing to GCM) credentials. Please refer
[Google's excellent documentation](http://developer.android.com/google/gcm/gs.html "Google Cloud Messaging > Getting Started")
to do this. Once you've set up the GCM service, and have your API credentials in hand, you can start the setup process.

# Setup

The following steps assume that you've completed the prerequisites.

1.  Clone this repository to your server.
2.  Install the required gems with the ``bundle install`` command.
3.  Generate a secret token with the ``rake secret`` command, and set this as the value of the environment variable
    ``COURIER_SECRET_TOKEN``. You can do this easily by creating a ``.env`` file in the repository root with the
    contents ``COURIER_SECRET_TOKEN=<GENERATED TOKEN>``. The environment variable will be set when the application is
    loaded.
4.  Configure your Google keys with environment variables ``GOOGLE_PROJECT_NUMBER`` (the number identifying your google
    project); ``GOOGLE_OAUTH_CLIENT_ID``, ``GOOGLE_OAUTH_CLIENT_SECRET``
    (for Google OAuth2 Login); and ``GOOGLE_SERVER_KEY`` (for GCM access). As in step 3, you can write these into the
    ``.env`` file.
5.  Configure the list of e-mail addresses that you wish to allow access to the interface (login is managed with Google
    OAuth 2.0). Set the e-mail addresses as comma-separated values in the environment variable
    ``COURIER_ALLOWED_USERS``.
5.  Configure database details using the environment variables ``COURIER_DATABASE_NAME``, ``COURIER_DATABASE_HOST``,
    ``COURIER_DATABASE_USERNAME`` and ``COURIER_DATABASE_PASSWORD``.
6.  Setup the database with ``bundle exec rake db:setup``. This will create the database and tables.
7.  Start the message push daemon with ``foreman start`` command. You can daemonize this script in a number of ways, of
    which, using foreman's export command to create start scripts is probably the easiest. On Ubuntu, you could do:

        $ sudo bundle exec foreman export --app courier-server --user USERNAME upstart /etc/init
        $ sudo start courier-server

8.  That's it. Fire up the application in your Rack-compatible web server.

## Notes

*   The application loads most of its configuration from environment variables, and relies on
    [dotenv](https://github.com/bkeepers/dotenv) to do so. However, there are a few options that aren't exposed - such
    as database port and adaptor, which can be configured manually in ``config/database.yml``.
*   If you're not using MySQL, please edit ``Gemfile`` to use the correct adapter rubygem, and ``config/database.yml``
    to alter the value of the adapter key to match the adapter in use.

# API

Courier Server has an API which allows you to register devices and push messages to registered devices. The API is what
Courier Clients use to communicate with the server.

## Registering a device

*TODO:* Documentation for device registration API.

## Push a message

*TODO:* Documentation for message push API.

# References

1. [Ruby On Rails](http://rubyonrails.org/)
2. [Google Cloud Messaging for Android](http://developer.android.com/google/gcm/index.html)
3. [higcm, GCM Ruby wrapper](https://github.com/hifrank/higcm)
4. [Foreman, a manager for Procfile-based applications](http://blog.daviddollar.org/2011/05/06/introducing-foreman.html)
5. [dotenv, loads environment variables from .env into ENV](https://github.com/bkeepers/dotenv)
