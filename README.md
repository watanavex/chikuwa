# danger-chikuwa

Danger Plugin for reporting Android build errors and warnings

## Installation

Add this line to your Gemfile:

```
gem danger-chikuwa
```

## Usage

Redirect the standard and error output of the command line build to a text file.
Change the build flavor as needed.

```
$ ./gradlew assembleDebug 2>&1 | tee build.log
```

Add a line to your Dangerfile.

```
chikuwa.report "build.log"
```

Optionally supports inline comments.

```
chikuwa.inline_mode = true
```

Here is a sample repository.  
https://github.com/watanavex/android-check-for-chikuwa/pull/5

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.

## What is Chikuwa?

Chikuwa is my family❤️
![chikuwa-photo](https://user-images.githubusercontent.com/3221619/173847362-e4cb1bd4-1b18-4ef9-abc6-fa061c215e81.png)
