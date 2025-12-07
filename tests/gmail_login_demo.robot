*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${BROWSER}        Edge
${URL}            https://www.facebook.com
${USERNAME}       abc@gmail.com
${PASSWORD}       123
${HEADLESS}       False    # Set to True for headless mode, False for headed mode

*** Test Cases ***
Login To Facebook
    [Documentation]    Test case to login to Facebook using Edge browser
    Open Browser To Facebook
    Enter Login Credentials
    Click Login Button
    Sleep    3s    # Wait to observe the result
    [Teardown]    Close Browser

*** Keywords ***
Open Browser To Facebook
    [Documentation]    Opens Edge browser and navigates to Facebook
    Run Keyword If    ${HEADLESS}    Open Browser With Headless Mode
    ...    ELSE    Open Browser With Headed Mode
    Maximize Browser Window
    Sleep    2s    # Wait for page to load

Open Browser With Headless Mode
    [Documentation]    Opens browser in headless mode
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --no-sandbox
    Create Webdriver    Edge    options=${options}
    Go To    ${URL}

Open Browser With Headed Mode
    [Documentation]    Opens browser in headed mode (visible window)
    Open Browser    ${URL}    ${BROWSER}

Enter Login Credentials
    [Documentation]    Enters username and password
    Wait Until Element Is Visible    id=email    timeout=10s
    Input Text    id=email    ${USERNAME}
    Input Text    id=pass    ${PASSWORD}

Click Login Button
    [Documentation]    Clicks the Log In button
    Click Button    name=login