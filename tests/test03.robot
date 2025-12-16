*** Settings ***
Documentation    Simplified CSV reader. Works in Jenkins AND local CLI.

Library    Collections
Library    OperatingSystem
Library    CSVLibrary

*** Variables ***
${CSV_FILE}    input.csv

*** Test Cases ***
Read And Store CSV Values
    [Documentation]    Reads CSV from current directory, stores values in variables.

    # Use provided path or default to current directory
    ${csv_path}=    Run Keyword If    '${CSV_FILE}' != 'input.csv'
    ...    Normalize Path    ${CSV_FILE}
    ...    ELSE    Normalize Path    ${CURDIR}${/}input.csv
    Set Global Variable    ${CSV_FILE}    ${csv_path}

    File Should Exist    ${CSV_FILE}

    # Read CSV and store values
    ${rows}=    Read CSV File To List    ${CSV_FILE}
    ${headers}=    Get From List    ${rows}    0
    ${data_row}=   Get From List    ${rows}    1

    # Store specific values
    ${email}=      Get From List    ${data_row}    0
    ${name}=       Get From List    ${data_row}    1

    # Log results
    Log To Console    === CSV VALUES ===
    Log To Console    File: ${CSV_FILE}
    Log To Console    Email: ${email}
    Log To Console    Name: ${name}
    Log To Console    Headers: ${headers}
