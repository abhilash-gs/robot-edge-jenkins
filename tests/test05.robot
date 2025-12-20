*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DocxLibrary.py

Suite Setup    Create Directory    ${SCREENSHOT_DIR}
Suite Teardown    Close All Browsers

*** Variables ***
${SCREENSHOT_DIR}    ${CURDIR}/tests/screenshots
${DOCX_FILE}         ${CURDIR}/ScreenshotsDoc.docx
${BROWSER}           chrome

*** Test Cases ***
Capture Google and ChatGPT Screenshots
    Log To Console   \n The current directory Loggin is ${CURDIR}
    Set Screenshot Directory    ${SCREENSHOT_DIR}
    Open Browser    https://www.google.com    ${BROWSER}
    Capture Page Screenshot    Screenshot001.png
    Go To    https://chatgpt.com
    Capture Page Screenshot    Screenshot002.png
    Create Screenshots Document    ${SCREENSHOT_DIR}/Screenshot001.jpg    Screenshot 1 - Google    ${SCREENSHOT_DIR}/Screenshot002.jpg    Screenshot 2 - ChatGPT    ${DOCX_FILE}
