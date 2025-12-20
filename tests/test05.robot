*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    DocxLibrary.py

Suite Setup    Create Directory    ${SCREENSHOT_DIR}
Suite Teardown    Close All Browsers

*** Variables ***
${SCREENSHOT_DIR}    ${CURDIR}${/}screenshots    # FIXED: No double tests/
${DOCX_FILE}         ${CURDIR}${/}ScreenshotsDoc.docx
${BROWSER}           chrome

*** Keywords ***
Capture Screenshot With Caption
    [Arguments]    ${filename}    ${caption}
    Capture Page Screenshot    ${filename}
    ${path}=    Set Variable    ${SCREENSHOT_DIR}${/}${filename}
    Log To Console    ✓ Captured: ${caption} -> ${path}
    RETURN    ${path}    ${caption}

Generate Dynamic DOCX Report
    [Arguments]    @{screenshot_list}
    Log To Console    📄 Creating DOCX with ${screenshot_list.__len__()//2} screenshots...
    # FIXED: Flatten list properly for Python *args
    @{flattened}=    Create List    @{screenshot_list}
    Create Screenshots Document    ${DOCX_FILE}    @{flattened}
    Log To Console    ✅ DOCX created: ${DOCX_FILE}

*** Test Cases ***
Capture Multiple Dynamic Screenshots
    Log To Console    \n🚀 ======================================
    Log To Console    Starting dynamic screenshot capture...
    Log To Console    Directory: ${SCREENSHOT_DIR}
    Log To Console    ======================================\n
    
    Set Screenshot Directory    ${SCREENSHOT_DIR}
    
    Open Browser    https://www.google.com    ${BROWSER}
    ${google}=    Capture Screenshot With Caption    Screenshot001.png    Google Home Page
    
    Go To    https://chatgpt.com
    ${chatgpt}=    Capture Screenshot With Caption    Screenshot002.png    ChatGPT Login Page
    
    Go To    https://github.com
    ${github}=    Capture Screenshot With Caption    Screenshot003.png    GitHub Dashboard
    
    Go To    https://stackoverflow.com
    ${stackoverflow}=    Capture Screenshot With Caption    Screenshot004.png    StackOverflow Home
    
    # DYNAMIC: Create flattened list
    @{all_screenshots}=    Create List    ${google}    Google Home Page    ${chatgpt}    ChatGPT Login Page    ${github}    GitHub Dashboard    ${stackoverflow}    StackOverflow Home
    
    Log To Console    Current Directory is - ${CURDIR}

    Generate Dynamic DOCX Report    @{all_screenshots}
    
    Log To Console    🎉 ======================================
    Log To Console    Process completed successfully!
    Log To Console    ======================================\n
