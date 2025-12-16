*** Settings ***
Documentation    Simplified CSV reader for Jenkins CI. Reads input.csv and stores values in variables.

Library          Collections
Library          OperatingSystem
Library          CSVLibrary

*** Variables ***
# Default paths - will be overridden in test case
${CSV_FILE}    input.csv

*** Test Cases ***
Read And Store CSV Values
    [Documentation]    Reads CSV, stores header and data values in variables, logs key values only.

    # Set CSV file path (Jenkins or local)
    Run Keyword If    '${WORKSPACE}' != '${EMPTY}'    Set CSV Path For Jenkins
    ...    ELSE    Set CSV Path For Local

    # Verify file exists
    File Should Exist    ${CSV_FILE}

    # Read entire CSV into rows
    ${rows}=    Read CSV File To List    ${CSV_FILE}

    # Store first row (headers) in variable
    ${headers}=    Get From List    ${rows}    0
    ${header_count}=    Get Length    ${headers}

    # Store second row (first data row) in variable
    ${data_row}=    Get From List    ${rows}    1
    ${row_count}=    Get Length    ${data_row}

    # Store specific cell values in variables
    ${email_value}=    Get From List    ${data_row}    0
    ${name_value}=    Get From List    ${data_row}    1

    # Log stored variables to console
    Log To Console    === CSV VALUES STORED ===
    Log To Console    File: ${CSV_FILE}
    Log To Console    Headers: ${headers}
    Log To Console    Email: ${email_value}
    Log To Console    Name: ${name_value}
    Log To Console    Row Length: ${row_count}

*** Keywords ***
Set CSV Path For Jenkins
    Set Global Variable    ${CSV_FILE}    ${WORKSPACE}${/}input.csv

Set CSV Path For Local
    ${cur_dir}=    Normalize Path    ${CURDIR}${/}input.csv
    Set Global Variable    ${CSV_FILE}    ${cur_dir}
