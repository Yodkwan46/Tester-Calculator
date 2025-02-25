*** Settings ***
Library    FlaUILibrary
Library    Process

Variables    ../Variables/Utility.yaml


*** Variables ***
${SCROLL_LIMIT}    10

*** Keywords ***
BeforeTestSetup
    # ตรวจสอบว่ามี Calculator เปิดอยู่หรือไม่
    ${is_running}    Run Keyword And Return Status    Is Process Running    ${xpath_calculator}
    Run Keyword If    not ${is_running}    Launch Application    ${xpath_calculator}
    Sleep    2s

AfterTestSetup
    # ตรวจสอบว่าปุ่ม Close มีอยู่ก่อนปิดโปรแกรม
    ${is_visible}    Run Keyword And Return Status    FlaUILibrary.Element Should Exist    ${xpath_closecalc_button}    timeout=2s
    Run Keyword If    ${is_visible}    FlaUILibrary.Click    ${xpath_closecalc_button}

Verify Standard Mode
    [Documentation]    ตรวจสอบว่าเครื่องคิดเลขอยู่ในโหมด Standard
    ${is_standard}    Run Keyword And Return Status    FlaUILibrary.Element Should Exist    ${xpath_standard_menu}    timeout=2s
    Run Keyword If    not ${is_standard}    Switch To Standard Mode

Clear Result
    [Documentation]    ตรวจสอบและเคลียร์ผลลัพธ์ที่ค้างอยู่ ถ้าไม่ใช่ "Display is 0"
    
    ${result_text}    Get Name From Element    ${xpath_result_label}
    ${result_cleaned}    Evaluate    "${result_text}".strip()

    Run Keyword If    "${result_cleaned}" != "Display is 0"    FlaUILibrary.Click    ${xpath_clearEntry_button}


Switch To Standard Mode
    FlaUILibrary.Click    ${xpath_navigation_button}
    Sleep    1s
    FlaUILibrary.Click    ${xpath_standard_menu}

Switch To Scientific Mode
    FlaUILibrary.Click    ${xpath_navigation_button}
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_scientific_menu}

Switch To Programmer Mode
    
    FlaUILibrary.Click    ${xpath_navigation_button}
    Sleep    1s
    FlaUILibrary.Click    ${xpath_programmer_menu}


Switch To Length Mode
    [Documentation]    ไปหน้าคำนวณ Length
    
    FlaUILibrary.Click    //Button[@Name="Maximize Calculator"]
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_navigation_button}
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_length_menu}
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Restore Calculator"]


Switch To Weight Mode
    [Documentation]    ไปหน้าคำนวณ Weight

    FlaUILibrary.Click    //Button[@Name="Maximize Calculator"]
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_navigation_button}
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_weight_menu}
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Restore Calculator"]

Switch To Temperature Mode
    [Documentation]    ไปหน้าคำนวณ Tempurature

    FlaUILibrary.Click    //Button[@Name="Maximize Calculator"]
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_navigation_button}
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_temperature_menu}
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Restore Calculator"]