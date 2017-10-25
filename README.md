# SmartSettings

Stores and retrieves settings on an ActiveRecord class, with support for application and per record settings.

[![Gem Version](https://badge.fury.io/rb/smart_settings.svg)](https://badge.fury.io/rb/smart_settings)
[![Build Status](https://travis-ci.org/hardpixel/smart-settings.svg?branch=master)](https://travis-ci.org/hardpixel/smart-settings)
[![Maintainability](https://api.codeclimate.com/v1/badges/930d42bb2bf6f54a4268/maintainability)](https://codeclimate.com/github/hardpixel/smart-settings/maintainability)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smart_settings'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smart_settings

Then run the settings generator that will create a migration and a `Setting` model:

    rails g smart_settings:install

And finally run the migrations:

    rails db:migrate

## Usage

To create an new setting you can use the setting generator. The format of the generator arguments is `name attribute:type:default:group`. To generate a setting with the name email:

    rails g smart_settings:setting email sender:string:info@website.com domain:string:website.com:smtp user:string:smtp@website.com:smtp password:string::smtp

The command above will generate the `EmailSettings` class inside the `app/settings` folder:

```ruby
class EmailSettings < SmartSettings::Base
  setting :sender,   :string, default: 'info@website.com'
  setting :domain,   :string, default: 'website.com',      group: :smtp
  setting :user,     :string, default: 'smtp@website.com', group: :smtp
  setting :password, :string, group: :smtp
end
```

Then you can use the `Setting` model or the `EmailSettings` class to get and set attributes:

```ruby
# Get email settings using the Setting model
email = Setting.find(:email)

# Get email settings using EmailSettings class
email = EmailSettings

# Get all setting attributes
email.all  # { sender: "info@website.com", smtp: { domain: "website.com", user: "smtp@website.com", password: nil } }

# Get all setting group attributes
email.smtp # { domain: "website.com", user: "smtp@website.com", password: nil }

# Get setting specific attributes
email.sender    # "info@website.com"
email.smtp_user # "smtp@website.com"

# Update setting attributes and save them in the settings table
email.update sender: "notify@website.com", smtp_user: "admin@website.com"

# Get setting updated attributes
email.sender    # "notify@website.com"
email.smtp_user # "admin@website.com"
```

The `Setting` model that is created with the install generator and the settings classes the are created with the setting generator, use the [tableless](https://github.com/hardpixel/tableless) gem to act like ActiveRecord models. This makes it easy to create CRUD controllers and views like you would do with any model:

```ruby
class SettingsController < ApplicationController
  # Show and edit actions are omitted from the example since they usually are empty
  # New and create actions cannot be used since you cannot create new settings

  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  def index
    @setting = Setting.all
  end

  def update
    if @setting.update(setting_params)
      redirect_to setting_path(@setting), notice: 'Setting was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @setting.destroy
    redirect_to request.referrer, notice: 'Setting was successfully reset to defaults.'
  end

  private

    def set_setting
      @setting = Setting.find(params[:id])
    end

    def setting_params
      params.require(:setting).permit(@setting.permitted_attributes)
    end
end
```

# TODO

* Add support for record settings

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hardpixel/smart-settings.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
