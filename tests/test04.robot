*** Settings ***
Documentation    Append a new row to existing CSV on a new line. Works in Jenkins AND local CLI.

Library    Collections
Library    OperatingSystem
Library    CSVLibrary

*** Variables ***
${CSV_FILE}      tests/data.csv
${NEW_NAME}      Abhi,GS
${NEW_EMAIL}     
${NEW_ROLE}      TechDev

*** Test Cases ***
Append New Row To CSV
    [Documentation]    Appends a new row (email, name, role) on a new line to the CSV file.

    # Use provided path or default to current directory (same style as test03.robot)
    ${csv_path}=    Run Keyword If    '${CSV_FILE}' != 'data.csv'
    ...    Normalize Path    ${CSV_FILE}
    ...    ELSE    Normalize Path    ${CURDIR}${/}data.csv
    Set Global Variable    ${CSV_FILE}    ${csv_path}

    File Should Exist    ${CSV_FILE}

    # Build CSV line: column 0=name, 1=email, 2=role
    ${line}=    Catenate    SEPARATOR=,    ${NEW_NAME}    ${NEW_EMAIL}    ${NEW_ROLE}

    # Always append with a leading newline so it becomes a new row
    Append To File    ${CSV_FILE}    \n${line}

    # (Optional) Read back to verify structure still OK
    ${rows}=    Read CSV File To List    ${CSV_FILE}
    Log To Console    === CSV AFTER APPEND ===
    Log To Console    ${rows}
