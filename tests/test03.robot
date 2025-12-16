*** Settings ***
Documentation    Simplified CSV reader for Jenkins CI. Reads input.csv and stores values in variables.

Library          Collections
Library          OperatingSystem
Library          CSVLibrary

*** Variables ***
# Works in Jenkins (${WORKSPACE} is Jenkins env var) AND local CLI (defaults to current dir)
${CSV_FILE}    ${WORKSPACE}${/}input.csv
Run Keyword If    '${WORKSPACE}' == '${EMPTY}'    Set Variable    ${CURDIR}${/}input.csv

*** Test Cases ***
Read And Store CSV Values
    [Documentation]    Reads CSV, stores header and data values in variables, logs key values only.

    # Use absolute path for reliability
    ${absolute_path}=    Normalize Path    ${CSV_FILE}
    File Should Exist    ${absolute_path}
    Set Global Variable    ${CSV_FILE}    ${absolute_path}

    # Read entire CSV into rows
    ${rows}=    Read CSV File To List    ${CSV_FILE}

    # Store first row (headers) in variable
    ${headers}=    Get From List    ${rows}    0
    ${header_count}=    Get Length    ${headers}

    # Store second row (first data row) in variable
    ${data_row}=    Get From List    ${rows}    1
    ${row_count}=    Get Length    ${data_row}

    # Store specific cell values in variables (assuming Email is first column)
    ${email_value}=    Get From List    ${data_row}    0
    ${name_value}=    Get From List    ${data_row}    1

    # Log stored variables to console (Jenkins-friendly output)
    Log To Console    === CSV VALUES STORED ===
    Log To Console    File: ${CSV_FILE}
    Log To Console    Headers: ${headers}
    Log To Console    Email: ${email_value}
    Log To Console    Name: ${name_value}
    Log To Console    Row Length: ${row_count}
