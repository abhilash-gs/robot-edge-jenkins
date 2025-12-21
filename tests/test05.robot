*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    DateTime
Library    DocxLibrary.py

Suite Setup    Create Directory    ${SCREENSHOT_DIR}
Suite Teardown    Close All Browsers

*** Variables ***
${SCREENSHOT_DIR}    ${CURDIR}${/}screenshots
${BROWSER}           chrome

*** Keywords ***
Capture Screenshot With Caption
    [Arguments]    ${filename}    ${caption}
    # Use full path for screenshot
    ${full_path}=    Set Variable    ${SCREENSHOT_DIR}${/}${filename}
    Capture Page Screenshot    ${full_path}
    Log To Console    ✓ Captured: ${caption} -> ${full_path}
    RETURN    ${full_path}    ${caption}

Generate Dynamic DOCX Report
    [Arguments]    ${docx_file}    @{screenshot_list}
    Log To Console    📄 Creating DOCX with ${screenshot_list.__len__()//2} screenshots...
    Create Screenshots Document    ${docx_file}    @{screenshot_list}
    Log To Console    ✅ DOCX created: ${docx_file}

*** Test Cases ***
Capture Multiple Dynamic Screenshots
    Log To Console    \n🚀 ======================================
    Log To Console    Starting dynamic screenshot capture...
    Log To Console    Directory: ${SCREENSHOT_DIR}
    Log To Console    ======================================\n
    
    # Get current timestamp in yyyymmdd_HHmm format
    ${timestamp}=        Get Current Date    result_format=%Y%m%d_%H%M
    Log To Console    📅 Timestamp: ${timestamp}
    
    # Create dynamic DOCX filename
    ${docx_file}=    Set Variable    ${CURDIR}${/}ScreenshotsDoc_${timestamp}.docx
    Log To Console    📄 DOCX filename: ${docx_file}
    
    Open Browser    https://www.google.com    ${BROWSER}
    ${google_path}    ${google_caption}=    Capture Screenshot With Caption    GoogleHome_${timestamp}.png    Google Home Page
    
    Go To    https://chatgpt.com
    ${chatgpt_path}    ${chatgpt_caption}=    Capture Screenshot With Caption    ChatGPT_${timestamp}.png    ChatGPT Login Page
    
    Go To    https://github.com
    ${github_path}    ${github_caption}=    Capture Screenshot With Caption    GitHub_${timestamp}.png    GitHub Dashboard
    
    Go To    https://stackoverflow.com
    ${stackoverflow_path}    ${stackoverflow_caption}=    Capture Screenshot With Caption    StackOverflow_${timestamp}.png    StackOverflow Home
    
    # Create list with proper path-caption pairs
    @{all_screenshots}=    Create List
    ...    ${google_path}    ${google_caption}
    ...    ${chatgpt_path}    ${chatgpt_caption}
    ...    ${github_path}    ${github_caption}
    ...    ${stackoverflow_path}    ${stackoverflow_caption}
    
    Log To Console    Current Directory is - ${CURDIR}

    Generate Dynamic DOCX Report    ${docx_file}    @{all_screenshots}
    
    Log To Console    🎉 ======================================
    Log To Console    Process completed successfully!
    Log To Console    ======================================\n
    [Teardown]    Close All Browsers
