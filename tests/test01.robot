*** Settings ***
Library    OperatingSystem
Library    String

*** Variables ***
${CSV_FILE_PATH}    ${EMPTY}

*** Test Cases ***
Read CSV And Access Data By Index
    [Documentation]    Read CSV file and access data using array indices
    
    # Get CSV file path from Jenkins
    ${csv_path}=    Get Environment Variable    CSV_FILE_PATH    default=${CURDIR}/tests/test_data.csv
    Log To Console    \nReading CSV from: ${csv_path}
    
    # Read and parse CSV
    ${headers}    ${data_rows}=    Parse CSV File    ${csv_path}
    
    # Display all data
    Log To Console    \n=== CSV Data ===
    Log To Console    Headers: ${headers}
    Log To Console    Data Rows: ${data_rows}
    
    # Access specific data using indices
    # Example: Get first data row
    ${row_0}=    Get From List    ${data_rows}    0
    Log To Console    \nFirst Data Row: ${row_0}
    
    # Example: Get specific column from first row
    ${column_0}=    Get From List    ${row_0}    0
    ${column_1}=    Get From List    ${row_0}    1
    ${column_2}=    Get From List    ${row_0}    2
    Log To Console    Column 0 (${headers}[0]): ${column_0}
    Log To Console    Column 1 (${headers}[1]): ${column_1}
    Log To Console    Column 2 (${headers}[2]): ${column_2}
    
    # Example: Get data by header name
    ${email}=    Get Value By Header    ${headers}    ${row_0}    Email
    ${name}=    Get Value By Header    ${headers}    ${row_0}    Name
    Log To Console    \nAccess by Header Name:
    Log To Console    Name: ${name}
    Log To Console    Email: ${email}

*** Keywords ***
Parse CSV File
    [Arguments]    ${file_path}
    [Documentation]    Parse CSV file and return headers and data rows as lists
    
    File Should Exist    ${file_path}
    ${content}=    Get File    ${file_path}
    @{lines}=    Split To Lines    ${content}
    
    # Parse header row
    ${header_line}=    Get From List    ${lines}    0
    @{headers}=    Split String    ${header_line}    ,
    ${headers}=    Strip Whitespace From List    ${headers}
    
    # Parse data rows
    @{data_rows}=    Create List
    FOR    ${i}    IN RANGE    1    999999
        ${row_exists}=    Run Keyword And Return Status    Get From List    ${lines}    ${i}
        Exit For Loop If    not ${row_exists}
        
        ${data_line}=    Get From List    ${lines}    ${i}
        ${data_line}=    Strip String    ${data_line}
        Continue For Loop If    '${data_line}' == ''
        
        @{row_data}=    Split String    ${data_line}    ,
        ${row_data}=    Strip Whitespace From List    ${row_data}
        Append To List    ${data_rows}    ${row_data}
    END
    
    [Return]    ${headers}    ${data_rows}

Strip Whitespace From List
    [Arguments]    ${list}
    [Documentation]    Remove whitespace from all items in a list
    
    @{cleaned}=    Create List
    FOR    ${item}    IN    @{list}
        ${clean_item}=    Strip String    ${item}
        Append To List    ${cleaned}    ${clean_item}
    END
    [Return]    ${cleaned}

Get Value By Header
    [Arguments]    ${headers}    ${row_data}    ${header_name}
    [Documentation]    Get value from row using header name
    
    ${index}=    Get Index From List    ${headers}    ${header_name}
    ${value}=    Get From List    ${row_data}    ${index}
    [Return]    ${value}
