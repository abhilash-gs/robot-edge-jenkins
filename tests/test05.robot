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
    Set Screenshot Directory    ${SCREENSHOT_DIR}
    Open Browser    https://www.google.com    ${BROWSER}
    Capture Page Screenshot    Screenshot001.jpg
    Go To    https://chatgpt.com
    Capture Page Screenshot    Screenshot002.jpg
    Create Screenshots Document    ${SCREENSHOT_DIR}/Screenshot001.jpg    Screenshot 1 - Google    ${SCREENSHOT_DIR}/Screenshot002.jpg    Screenshot 2 - ChatGPT    ${DOCX_FILE}
