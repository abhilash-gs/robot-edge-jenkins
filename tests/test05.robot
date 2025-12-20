*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    DocxLibrary.py

Suite Setup    Create Directory    ${SCREENSHOT_DIR}
Suite Teardown    Close All Browsers

*** Variables ***
${SCREENSHOT_DIR}    ${CURDIR}${/}screenshots
${DOCX_FILE}         ${CURDIR}${/}ScreenshotsDoc.docx
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
    [Arguments]    @{screenshot_list}
    Log To Console    📄 Creating DOCX with ${screenshot_list.__len__()//2} screenshots...
    Create Screenshots Document    ${DOCX_FILE}    @{screenshot_list}
    Log To Console    ✅ DOCX created: ${DOCX_FILE}

*** Test Cases ***
Capture Multiple Dynamic Screenshots
    Log To Console    \n🚀 ======================================
    Log To Console    Starting dynamic screenshot capture...
    Log To Console    Directory: ${SCREENSHOT_DIR}
    Log To Console    ======================================\n
    
    # No longer needed since we use full paths
    # Set Screenshot Directory    ${SCREENSHOT_DIR}
    
    Open Browser    https://www.google.com    ${BROWSER}
    ${google_path}    ${google_caption}=    Capture Screenshot With Caption    Screenshot001.png    Google Home Page
    
    Go To    https://chatgpt.com
    ${chatgpt_path}    ${chatgpt_caption}=    Capture Screenshot With Caption    Screenshot002.png    ChatGPT Login Page
    
    Go To    https://github.com
    ${github_path}    ${github_caption}=    Capture Screenshot With Caption    Screenshot003.png    GitHub Dashboard
    
    Go To    https://stackoverflow.com
    ${stackoverflow_path}    ${stackoverflow_caption}=    Capture Screenshot With Caption    Screenshot004.png    StackOverflow Home
    
    # Create list with proper path-caption pairs
    @{all_screenshots}=    Create List    
    ...    ${google_path}    ${google_caption}
    ...    ${chatgpt_path}    ${chatgpt_caption}
    ...    ${github_path}    ${github_caption}
    ...    ${stackoverflow_path}    ${stackoverflow_caption}
    
    Log To Console    Current Directory is - ${CURDIR}

    Generate Dynamic DOCX Report    @{all_screenshots}
    
    Log To Console    🎉 ======================================
    Log To Console    Process completed successfully!
    Log To Console    ======================================\n
