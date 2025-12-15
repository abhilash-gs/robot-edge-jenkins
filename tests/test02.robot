*** Settings ***
Library    RPA.Tables
Library    OperatingSystem

*** Variables ***
${CSV_FILE_PATH}    ${CURDIR}/workspace/data.csv
${WORKSPC_DIR}      ${CURDIR}/workspace

*** Tasks ***
Read CSV From Jenkins Workspace
    Create Workspace Directory If Needed
    Verify CSV File Exists
    ${table}=    Read CSV File    ${CSV_FILE_PATH}
    Log Table Contents    ${table}
    Log Specific Row    ${table}    0
    Log Specific Column    ${table}    Name
    Log Cell Value    ${table}    1    Email

*** Keywords ***
Create Workspace Directory If Needed
    Directory Should Exist    ${WORKSPC_DIR}
    Log    Workspace directory exists: ${WORKSPC_DIR} [web:1]

Verify CSV File Exists
    File Should Exist    ${CSV_FILE_PATH}
    ${file_size}=    Get File Size    ${CSV_FILE_PATH}
    Log    CSV file found. Size: ${file_size} bytes [web:1]

Read CSV File
    [Arguments]    ${file_path}
    ${table}=    Read Table From CSV    ${file_path}    header=True
    [Return]    ${table}

Log Table Contents
    [Arguments]    ${table}
    Log    Total rows: ${table.RowCount}
    Log    Total columns: ${table.ColumnCount}
    FOR    ${row}    IN RANGE    0    ${table.RowCount}
        ${row_data}=    Get Table Row    ${table}    ${row}
        Log    Row ${row}: ${row_data}
    END

Log Specific Row
    [Arguments]    ${table}    ${row_index}
    ${row_data}=    Get Table Row    ${table}    ${row_index}
    Log    Row ${row_index} values: ${row_data} [web:2]

Log Specific Column
    [Arguments]    ${table}    ${column_name}
    ${column_values}=    Get Column Values    ${table}    ${column_name}
    Log    Column '${column_name}' values: ${column_values} [web:2]

Log Cell Value
    [Arguments]    ${table}    ${row_index}    ${column_name}
    ${cell_value}=    Get Table Value    ${table}    ${row_index}    ${column_name}
    Log    Cell [${row_index}, ${column_name}]: ${cell_value} [web:2]
