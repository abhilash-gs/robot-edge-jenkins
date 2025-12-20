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
Capture And Move Screenshot
    [Arguments]    ${filename}    ${caption}
    Capture Page Screenshot    ${filename}
    # MOVE from default location to our directory
    Move File    ${CURDIR}${/}${filename}    ${SCREENSHOT_DIR}${/}${filename}
    ${path}=    Set Variable    ${SCREENSHOT_DIR}${/}${filename}
    Log To Console    ✓ Captured & Moved: ${caption} -> ${path}
    RETURN    ${path}    ${caption}

Generate Dynamic DOCX Report
    [Arguments]    @{screenshot_list}
    Log To Console    📄 Creating DOCX with ${screenshot_list.__len__()//2} screenshots...
    Create Screenshots Document    ${DOCX_FILE}    @{screenshot_list}
    Log To Console    ✅ DOCX created: ${DOCX_FILE}

*** Test Cases ***
Capture Multiple Dynamic Screenshots
    Log To Console    \n🚀 ======================================
    Log To Console    Starting screenshot capture...
    Log To Console    Target dir: ${SCREENSHOT_DIR}
    Log To Console    ======================================\n
    
    Open Browser    https://www.google.com    ${BROWSER}
    ${google}=    Capture And Move Screenshot    Screenshot001.png    Google Home Page
    
    Go To    https://chatgpt.com
    ${chatgpt}=    Capture And Move Screenshot    Screenshot002.png    ChatGPT Login Page
    
    Go To    https://github.com
    ${github}=    Capture And Move Screenshot    Screenshot003.png    GitHub Dashboard
    
    Go To    https://stackoverflow.com
    ${stackoverflow}=    Capture And Move Screenshot    Screenshot004.png    StackOverflow Home
    
    @{all_screenshots}=    Create List    ${google}    Google Home Page    ${chatgpt}    ChatGPT Login Page    ${github}    GitHub Dashboard    ${stackoverflow}    StackOverflow Home
    
    Generate Dynamic DOCX Report    @{all_screenshots}
    
    Log To Console    🎉 ====================================== SUCCESS!
