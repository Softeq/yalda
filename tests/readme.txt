
Current tests provide ability to run smoke tests on build of linux image components.

Usage: ./run_tests.sh [-c config_file_name] [-t test_name]
    options:
        c   Config file name
                Config files are located at 'YALDA/tests/config' directory

        t   Test name
                Test located at 'YALDA/tests/test_source' file

The script runs from the "YALDA" directory.
Test run creates the following file structure:

    YALDA/tests
      |--- generated
            | --- <config_file_name>
                    | --- components
                    |      | --- <downloaded components>
                    |
                    | --- out
                           | --- <test run artifacts>

Notes:
+ Add new configuration:
    There are default config files existed. Place new config file at 'YALDA/config' directory.
    Change paths it the config according to any jf default config file.

+ Add new test:
    Add test function for specific test 'YALDA/tests/test_source' file: test_<test_name>
    Add <test_name> to get_test_list() function at the file.
