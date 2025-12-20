*** Settings ***
Documentation    Append a new row to existing CSV. Works in Jenkins AND local CLI.

Library     Collections
Library     OperatingSystem
Library     CSVLibrary
Library     String

*** Variables ***
${CSV_FILE}     tests/data.csv
${NEW_NAME}     Abhi
${NEW_EMAIL}     abhi@test.com
${NEW_ROLE}     TechDev


*** Test Cases ***
Append New Row To CSV
    [Documentation]    Appends a new row to the CSV file with provided values.
    # Use provided path or default to current directory (same style as test03.robot)[2]
    ${csv_path}=    Run Keyword If    '${CSV_FILE}' != 'data.csv'
...    Normalize Path    ${CSV_FILE}
...    ELSE    Normalize Path    ${CURDIR}${/}data.csv
    Set Global Variable    ${CSV_FILE}    ${csv_path}

    File Should Exist    ${CSV_FILE}

 # Ensure file ends with newline so next CSV row starts on a new line
    ${content}=    Get File    ${CSV_FILE}
    ${length}=     Get Length    ${content}
    Run Keyword If    ${length} > 0
    ...    Ensure Trailing Newline   ${content}    ${CSV_FILE}

    # Build new row as list: column 0=email, 1=name, 2=role[web:2][web:3]
    ${new_row}=    Create List    ${NEW_EMAIL}    ${NEW_NAME}    ${NEW_ROLE}
    ${data}=       Create List    ${new_row}

# Append the new row to CSV (CSVLibrary keyword: Append To Csv File)[4]
    Append To Csv File    ${CSV_FILE}    ${data}

# Log result
    Log To Console    === APPENDED NEW CSV ROW ===
    Log To Console    File: ${CSV_FILE}
    Log To Console    Email: ${NEW_EMAIL}, Name: ${NEW_NAME}, Role: ${NEW_ROLE}


*** Keywords ***
Ensure Trailing Newline
    [Arguments]    ${content}    ${path}
    ${last_char}=    Get Substring    ${content}    -1
    Run Keyword If    '${last_char}' != '\n'
    ...    Append To File    ${path}    \n
