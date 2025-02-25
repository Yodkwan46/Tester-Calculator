*** Settings ***
Documentation    ทดสอบเครื่องคิดเลขโดยเปิดโปรแกรมครั้งเดียวและปิดหลังทดสอบเสร็จ
Library          FlaUILibrary
Library          Process
Resource        ./Keywords/Keywords.robot

Suite Setup    BeforeTestSetup
Suite Teardown    AfterTestSetup


*** Test Cases ***
Case 1.1 ทดสอบเครื่องคิดเลขโหมด Standard
    [Documentation]    ตรวจสอบว่าสามารถเปลี่ยนไปยังโหมด Standard ได้
    [Tags]    เครื่องคิดเลข    โหมดมาตรฐาน
    Sleep    1.0s

    Verify Standard Mode

    FlaUILibrary.Click    //Button[@AutomationId="num8Button"]
    FlaUILibrary.Click    //Button[@AutomationId="num8Button"]
    FlaUILibrary.Click    //Button[@AutomationId="num8Button"]
    FlaUILibrary.Click    //Button[@AutomationId="num8Button"]
    FlaUILibrary.Click    //Button[@AutomationId="num8Button"]
    
    FlaUILibrary.Click    //Button[@Name="Plus"]

    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]

    FlaUILibrary.Click    //Button[@Name="Equals"]

    Sleep    1.0s

    # ดึงค่าจากเครื่องคิดเลข
    ${actual_Result}    Get Name From Element    ${xpath_result_label}

    # ลบเครื่องหมายจุลภาค (,) ออกจากตัวเลข และตัด "Display is "
    ${actual_Result_Cleaned}    Evaluate    "${actual_Result}".replace('Display is ', '').replace(',', '').strip()

    # ตั้งค่าตัวแปรให้เป็น Global เพื่อใช้ใน Case ถัดไป
    Set Global Variable    ${actual_Result_Cleaned}    ${actual_Result_Cleaned}

    # ตรวจสอบว่าได้ค่าถูกต้อง
    Should Contain    ${actual_Result_Cleaned}    111110

Case 1.2 คัดลอกผลลัพธ์และเปลี่ยนไปโหมด Programmer
    [Documentation]    ตรวจสอบว่าสามารถเปลี่ยนไปยังโหมด Programmer และวางค่าผลลัพธ์ได้
    [Tags]    เครื่องคิดเลข    โหมดโปรแกรมเมอร์
    Sleep    1.0s
    # เปิดเมนูเลือกโหมดเครื่องคิดเลข
    Switch To Programmer Mode

    # ถ้าตัวแปรเป็น None หรือไม่มีค่า ให้หยุดการทำงาน
    Run Keyword If    '${actual_Result_Cleaned}' == ''    Fail    "ตัวแปร actual_Result_Cleaned ไม่มีค่า"

    # แปลงตัวเลขจาก String เป็น List ของตัวเลขแต่ละหลัก
    ${number_list}    Evaluate    list(str(${actual_Result_Cleaned}))

    # ป้อนค่าตัวเลขแต่ละหลักลงไปในเครื่องคิดเลข
    FOR    ${char}    IN    @{number_list}
        FlaUILibrary.Click    //Button[@AutomationId="num${char}Button"]
    END

    # ดึงค่าที่ถูกแปลงเป็นเลขฐานอื่นๆ ในโหมด Programmer
    ${programmer_Result}    Get Name From Element    ${xpath_result_label}
    Log    ${programmer_Result}

    # ลบ "Display is " และเครื่องหมายจุลภาค (,) ออก
    ${programmer_Result_Cleaned}    Evaluate    "${programmer_Result}".replace('Display is ', '').replace(',', '').strip()

    # ตรวจสอบว่าเลขที่ป้อนเข้ามาถูกต้อง (ในโหมด Programmer)
    Should Contain    ${programmer_Result_Cleaned}    111110

Case 1.3 ตรวจสอบค่าที่แปลงเป็นเลขฐานต่างๆ ในโหมด Programmer
    [Documentation]    ตรวจสอบว่าสามารถคลิกเพื่อดูค่าของเลขฐาน HEX, DEC, OCT, BIN ได้
    [Tags]    เครื่องคิดเลข    โหมดโปรแกรมเมอร์    เลขฐาน
    Sleep    2.0s

    # คลิกที่ปุ่ม HEX และดึงค่า
    FlaUILibrary.Click    //RadioButton[@AutomationId="hexButton"]
    Sleep    1.5s
    ${HEX_Result}    Get Name From Element    ${xpath_result_label}
    
    # คลิกที่ปุ่ม DEC และดึงค่า
    FlaUILibrary.Click    //RadioButton[@AutomationId="decimalButton"]
    Sleep    1.5s
    ${DEC_Result}    Get Name From Element    ${xpath_result_label}

    # คลิกที่ปุ่ม OCT และดึงค่า
    FlaUILibrary.Click    //RadioButton[@AutomationId="octolButton"]
    Sleep    1.5s
    ${OCT_Result}    Get Name From Element    ${xpath_result_label}

    # คลิกที่ปุ่ม BIN และดึงค่า
    FlaUILibrary.Click    //RadioButton[@AutomationId="binaryButton"]
    Sleep    1.5s
    ${BIN_Result}    Get Name From Element    ${xpath_result_label}

    # ลบช่องว่างและจุลภาคออกจากค่าที่ได้
    ${HEX_Cleaned}    Evaluate    "${HEX_Result}".replace('Display is ', '').replace(' ', '').replace(',', '').strip()
    ${DEC_Cleaned}    Evaluate    "${DEC_Result}".replace('Display is ', '').replace(',', '').strip()
    ${OCT_Cleaned}    Evaluate    "${OCT_Result}".replace('Display is ', '').replace(' ', '').replace(',', '').strip()
    ${BIN_Cleaned}    Evaluate    "${BIN_Result}".replace('Display is ', '').replace(' ', '').replace(',', '').strip()

    # ตรวจสอบว่าค่าที่ได้ถูกต้อง
    Should Be Equal As Strings    ${HEX_Cleaned}    1B206
    Should Be Equal As Strings    ${DEC_Cleaned}    111110
    Should Be Equal As Strings    ${OCT_Cleaned}    331006
    Should Be Equal As Strings    ${BIN_Cleaned}    00011011001000000110
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="clearEntryButton"]


Case 1.4 ทดสอบการปรับย่อ-หน้าจอ
    [Documentation]    ตรวจสอบว่าสามารถปรับหน้าจอได้ถูกต้อง
    [Tags]    หน้าจอ    เครื่องคิดเลข
    Sleep    1.0s
    FlaUILibrary.Press Key    s'LWIN + RIGHT'
    # FlaUILibrary.Click    //Button[@Name="Maximize Calculator"]
    # Sleep    1.0s
    # FlaUILibrary.Click    //Button[@Name="Restore Calculator"]
    # Sleep    1.0s
    FlaUILibrary.Focus    ${xpath_calculator_window}
    

Case 1.5 ทดสอบการใช้หน่วยความจำ (Memory Functions)
    [Documentation]    ตรวจสอบว่าฟังก์ชัน Memory สามารถทำงานได้
    [Tags]    เครื่องคิดเลข    หน่วยความจำ
    Sleep    3.0s

    FlaUILibrary.Click    ${xpath_navigation_button}
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_standard_menu}
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_memory_label}
    Sleep    1.0s

    
    # กดเลข 5 และบันทึกค่าลงหน่วยความจำ
    FlaUILibrary.Click    //Button[@AutomationId="num5Button"]
    FlaUILibrary.Click    //Button[@Name="Memory store"]
    Sleep    1.0s
    
    # กด MR เพื่อนำค่าที่บันทึกไว้กลับมา
    FlaUILibrary.Click    //Button[@Name="Memory recall"]

    Sleep    1.0s

    ${memory_Result}    Get Name From Element    ${xpath_result_label}
    # ลบ "Display is " 
    ${memory_Result}    Evaluate    "${memory_Result}".replace('Display is ', '').strip()


    Should Be Equal As Strings    ${memory_Result}    5

    # กด MC เพื่อล้างค่าหน่วยความจำ
    FlaUILibrary.Click    //Button[@Name="Clear all memory"]
    Sleep    1.0s

    ${exists}    Run Keyword And Return Status    FlaUILibrary.Get Name From Element    //List[@AutomationId="MemoryListView"]
    Run Keyword If    ${exists}    Fail    "AutomationID CalculatorResults ถูกพบ (ต้องการให้ไม่พบ)"


Case 1.6 ทดสอบการคำนวณเปอร์เซ็นต์ (%)
    [Documentation]    ตรวจสอบว่าสามารถคำนวณเปอร์เซ็นต์ได้ถูกต้อง
    [Tags]    เครื่องคิดเลข    เปอร์เซ็นต์
    Sleep    1.0s

    # ป้อน 50 x 25% และตรวจสอบผลลัพธ์
    FlaUILibrary.Click    //Button[@AutomationId="num5Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Multiply by"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num5Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Percent"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Equals"]

    ${percent_Result}    Get Name From Element    ${xpath_result_label}
    ${percent_Cleaned}    Evaluate    "${percent_Result}".replace('Display is ', '').replace(',', '').strip()
    
    Should Be Equal As Strings    ${percent_Cleaned}    12.5


Case 1.7 ทดสอบ Factorial และ Square Root
    [Documentation]    ตรวจสอบว่าสามารถคำนวณ Factorial และ Square Root ได้
    [Tags]    เครื่องคิดเลข    ค่าทางคณิตศาสตร์
    Sleep    1.0s

    # ทดสอบ Factorial (5!)
    Switch To Scientific Mode

    FlaUILibrary.Click    //Button[@AutomationId="num5Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="factorialButton"]
    Sleep    1.0s
    ${factorial_Result}    Get Name From Element    ${xpath_result_label}
    ${factorial_Cleaned}    Evaluate    "${factorial_Result}".replace('Display is ', '').replace(',', '').strip()
    
    Should Be Equal As Strings    ${factorial_Cleaned}    120

    # ทดสอบ Square Root (√49)
    FlaUILibrary.Click    //Button[@AutomationId="num4Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num9Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="squareRootButton"]
    ${sqrt_Result}    Get Name From Element    ${xpath_result_label}
    ${sqrt_Cleaned}    Evaluate    "${sqrt_Result}".replace('Display is ', '').replace(',', '').strip()

    Should Be Equal As Strings    ${sqrt_Cleaned}    7


Case 1.8 ทดสอบ Bitwise Operations (AND, OR, XOR, NOT)
    [Documentation]    ตรวจสอบว่าสามารถใช้ฟังก์ชัน Bitwise ได้ในโหมด Programmer
    [Tags]    เครื่องคิดเลข    โหมดโปรแกรมเมอร์    Bitwise
    Sleep    1.0s
    
    Switch To Programmer Mode

    # 1100 AND 1010 = 1000
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="bitwiseButton"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="And"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Equals"]
    Sleep    1.0s
    FlaUILibrary.Click    //RadioButton[@AutomationId="octolButton"]
    ${bitwise_Result}    Get Name From Element    ${xpath_result_label}
    ${bitwise_Cleaned}    Evaluate    "${bitwise_Result}".replace('Display is ', '').replace(',', '').replace(' ', '').strip()
    Should Be Equal As Strings    ${bitwise_Cleaned}    100


Case 1.9 ทดสอบฟังก์ชันตรีโกณ (Trigonometric Functions)
    [Documentation]    สลับไปโหมด Scientific แล้วทดสอบฟังก์ชัน sin, cos และ tan
    
    Switch To Scientific Mode

    # ทดสอบ sin(30°) คาดว่าผลลัพธ์เป็น 0.5
    FlaUILibrary.Click    //Button[@AutomationId="clearButton"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num3Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_trigonometry_button}
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_sin_button}
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Equals"]
    Sleep    1.0s
    ${sin_result}    Get Name From Element    ${xpath_result_label}
    ${sin_cleaned}    Evaluate    "${sin_result}".replace('Display is ', '').strip()
    Should Be Equal As Strings    ${sin_cleaned}    0.5
    
    # ทดสอบ cos(60°) คาดว่าผลลัพธ์เป็น 0.5
    FlaUILibrary.Click    //Button[@AutomationId="clearEntryButton"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num6Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_trigonometry_button}
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_cos_button}
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Equals"]
    Sleep    1.0s
    ${cos_result}    Get Name From Element    ${xpath_result_label}
    ${cos_cleaned}    Evaluate    "${cos_result}".replace('Display is ', '').strip()
    Should Be Equal As Strings    ${cos_cleaned}    0.5
    
    # ทดสอบ tan(45°) คาดว่าผลลัพธ์เป็น 1
    FlaUILibrary.Click    //Button[@AutomationId="clearEntryButton"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num4Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num5Button"]
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_trigonometry_button}
    Sleep    1.0s
    FlaUILibrary.Click    ${xpath_tan_button}
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Equals"]
    Sleep    1.0s
    ${tan_result}    Get Name From Element    ${xpath_result_label}
    ${tan_cleaned}    Evaluate    "${tan_result}".replace('Display is ', '').strip()
    Should Be Equal As Strings    ${tan_cleaned}    1

Case 1.10 ทดสอบฟังก์ชันลอการิทึมและยกกำลัง (Logarithmic and Exponential Functions)
    [Documentation]    สลับไปโหมด Scientific แล้วทดสอบฟังก์ชัน log10 กับการคำนวณยกกำลัง (x^y)
    
    Clear Result

    # ทดสอบ log(100) คาดว่าผลลัพธ์เป็น 2
    # FlaUILibrary.Click    //Button[@AutomationId="clearButton"]
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Log"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Equals"]
    Sleep    1.0s
    ${log_result}    Get Name From Element    ${xpath_result_label}
    ${log_cleaned}    Evaluate    "${log_result}".replace('Display is ', '').strip()
    Should Be Equal As Strings    ${log_cleaned}    2
    
    # ทดสอบ 2^3 คาดว่าผลลัพธ์เป็น 8
    FlaUILibrary.Click    //Button[@AutomationId="clearEntryButton"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="powerButton"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num3Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Equals"]
    Sleep    1.0s
    ${power_result}    Get Name From Element    ${xpath_result_label}
    ${power_cleaned}    Evaluate    "${power_result}".replace('Display is ', '').strip()
    Should Be Equal As Strings    ${power_cleaned}    8

Case 1.11 ทดสอบฟังก์ชันกลับค่า (Reciprocal Function)
    [Documentation]    สลับไปโหมด Scientific แล้วทดสอบฟังก์ชัน 1/x สำหรับค่า 4 คาดว่าผลลัพธ์เป็น 0.25
    
    Switch To Scientific Mode
    
    FlaUILibrary.Click    //Button[@AutomationId="clearEntryButton"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num4Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Reciprocal"]
    Sleep    2.0s
    ${reciprocal_result}    Get Name From Element    ${xpath_result_label}
    ${reciprocal_cleaned}    Evaluate    float("${reciprocal_result}".replace('Display is ', '').strip())
    Should Be Equal As Numbers    ${reciprocal_cleaned}    0.25


Case 1.12 ทดสอบฟังก์ชันเปลี่ยนเครื่องหมาย (Plus/Minus Toggle)
    [Documentation]    ทดสอบการสลับเครื่องหมายบวก/ลบ โดยป้อนค่า 25 แล้วกดปุ่มเปลี่ยนเครื่องหมาย คาดว่าจะแสดงเป็น -25
    
    Switch To Standard Mode
    
    FlaUILibrary.Click    //Button[@AutomationId="clearEntryButton"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num5Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@Name="Positive negative"]
    Sleep    1.0s
    ${toggle_result}    Get Name From Element    ${xpath_result_label}
    ${toggle_cleaned}    Evaluate    "${toggle_result}".replace('Display is ', '').strip()
    Should Be Equal As Strings    ${toggle_cleaned}    -25

Case 1.13 ทดสอบฟังก์ชัน Backspace (ลบหลักสุดท้าย)
    [Documentation]    ทดสอบการใช้งานปุ่ม Backspace เพื่อลบหลักสุดท้ายของตัวเลขที่ป้อนเข้าไป
    
    Switch To Standard Mode
    
    FlaUILibrary.Click    //Button[@AutomationId="clearEntryButton"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num3Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num4Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num5Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="backSpaceButton"]
    Sleep    1.0s
    ${backspace_result}    Get Name From Element    ${xpath_result_label}
    ${backspace_cleaned}    Evaluate    "${backspace_result}".replace('Display is ', '').strip()
    Should Be Equal As Strings    ${backspace_cleaned}    1,234


Case 1.14 Convert Temperature: Celsius to Fahrenheit
    [Documentation]    แปลงอุณหภูมิจาก Celsius เป็น Fahrenheit: 100°C คาดว่าผลลัพธ์จะเป็น 212°F
    Sleep    1.0s

    Switch To Temperature Mode
    
    FlaUILibrary.Click    //ComboBox[@Name="Input unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //Text[@Name="Celsius"]
    Sleep    1.0s
    FlaUILibrary.Click    //ComboBox[@Name="Output unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //Text[@Name="Fahrenheit"]
    Sleep    1.0s
    FlaUILibrary.Click    //Text[@AutomationId="Value1"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    ${result}    Get Name From Element    //Text[@AutomationId="Value2"]
    ${result_cleaned}    Evaluate    re.sub(r'[^0-9.-]', '', "${result}")    re
    Should Contain    ${result_cleaned}    212

    FlaUILibrary.Click    //Button[@AutomationId="ClearEntryButtonPos0"]


Case 1.15 Convert Temperature: Fahrenheit to Celsius
    [Documentation]    แปลงอุณหภูมิจาก Fahrenheit เป็น Celsius: 212°F คาดว่าผลลัพธ์จะเป็น 100°C
    Sleep    1.0s

    FlaUILibrary.Click    //ComboBox[@Name="Input unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //Text[@Name="Fahrenheit"]
    Sleep    1.0s
    FlaUILibrary.Click    //ComboBox[@Name="Output unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //Text[@Name="Celsius"]
    Sleep    1.0s
    FlaUILibrary.Click    //Text[@AutomationId="Value1"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    ${result}    Get Name From Element    //Text[@AutomationId="Value2"]
    ${result_cleaned}    Evaluate    re.sub(r'[^0-9.-]', '', "${result}")    re
    Should Contain    ${result_cleaned}    100

    FlaUILibrary.Click    //Button[@AutomationId="ClearEntryButtonPos0"]

Case 1.16 Convert Temperature: Celsius to Kelvin
    [Documentation]    แปลงอุณหภูมิจาก Celsius เป็น Kelvin: 25°C คาดว่าผลลัพธ์จะอยู่ที่ประมาณ 298.15K

    FlaUILibrary.Click    //ComboBox[@Name="Input unit"]
    Sleep    2.0s
    FlaUILibrary.Click    //Text[@Name="Celsius"]
    Sleep    1.0s
    FlaUILibrary.Click    //ComboBox[@Name="Output unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //Text[@Name="Kelvin"]
    Sleep    1.0s
    FlaUILibrary.Click    //Text[@AutomationId="Value1"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num5Button"]
    Sleep    1.0s
    ${result}    Get Name From Element    //Text[@AutomationId="Value2"]
    ${result_cleaned}    Evaluate    re.sub(r'[^0-9.-]', '', "${result}")    re
    Should Contain    ${result_cleaned}    298.15

    FlaUILibrary.Click    //Button[@AutomationId="ClearEntryButtonPos0"]

Case 1.17 Convert Length: Kilometers to Miles
    [Documentation]    แปลงหน่วยความยาว: 1 Kilometer คาดว่าผลลัพธ์จะเป็นประมาณ 0.62137 Miles

    Switch To Length Mode
    
    FlaUILibrary.Click    //ComboBox[@Name="Input unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //Text[@Name="Kilometers"]
    Sleep    1.0s
    FlaUILibrary.Click    //ComboBox[@Name="Output unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //ListItem[@Name="Miles"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    ${result}    Get Name From Element    //Text[@AutomationId="Value2"]
    ${result_cleaned}    Evaluate    re.sub(r'[^0-9.-]', '', "${result}")    re
    Should Contain    ${result_cleaned}    0.62137

    FlaUILibrary.Click    //Button[@AutomationId="ClearEntryButtonPos0"]

Case 1.18 Convert Length: Meters to Feet
    [Documentation]    แปลงหน่วยความยาว: 1 Meter คาดว่าผลลัพธ์จะเป็นประมาณ 3.28084 Feet
    
    FlaUILibrary.Click    //ComboBox[@Name="Input unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //Text[@Name="Meters"]
    Sleep    1.0s
    FlaUILibrary.Click    //ComboBox[@Name="Output unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //ListItem[@Name="Feet"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    ${result}    Get Name From Element    //Text[@AutomationId="Value2"]
    ${result_cleaned}    Evaluate    re.sub(r'[^0-9.-]', '', "${result}")    re
    Should Contain    ${result_cleaned}    3.28084

    FlaUILibrary.Click    //Button[@AutomationId="ClearEntryButtonPos0"]

Case 1.19 Convert Weight: Kilograms to Pounds
    [Documentation]    แปลงหน่วยน้ำหนัก: 1 Kilogram คาดว่าผลลัพธ์จะเป็นประมาณ 2.20462 Pounds
    
    Switch To Weight Mode

    FlaUILibrary.Click    //ComboBox[@Name="Input unit"]
    Sleep    2.0s
    FlaUILibrary.Click    //Text[@Name="Kilograms"]
    Sleep    1.0s
    FlaUILibrary.Click    //ComboBox[@Name="Output unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //ListItem[@Name="Pounds"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num1Button"]
    Sleep    1.0s
    ${result}    Get Name From Element    //Text[@AutomationId="Value2"]
    ${result_cleaned}    Evaluate    re.sub(r'[^0-9.-]', '', "${result}")    re
    Should Contain    ${result_cleaned}    2.20462

    FlaUILibrary.Click    //Button[@AutomationId="ClearEntryButtonPos0"]

Case 1.20 Convert Weight: Pounds to Kilograms
    [Documentation]    แปลงหน่วยน้ำหนัก: 2.20462 Pounds คาดว่าผลลัพธ์จะเป็นประมาณ 1 Kilogram
    
    FlaUILibrary.Click    //ComboBox[@Name="Input unit"]
    Sleep    2.0s
    FlaUILibrary.Click    //Text[@Name="Pounds"]
    Sleep    1.0s
    FlaUILibrary.Click    //ComboBox[@Name="Output unit"]
    Sleep    1.0s
    FlaUILibrary.Click    //ListItem[@Name="Kilograms"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="decimalSeparatorButton"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num0Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num4Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num6Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    FlaUILibrary.Click    //Button[@AutomationId="num2Button"]
    Sleep    1.0s
    ${result}    Get Name From Element    //Text[@AutomationId="Value2"]
    ${result_cleaned}    Evaluate    re.sub(r'[^0-9.-]', '', "${result}")    re
    
    Should Contain    ${result_cleaned}    1

    FlaUILibrary.Click    //Button[@AutomationId="ClearEntryButtonPos0"]

Case 1.21 ปิดโปรแกรมเครื่องคิดเลข
    [Documentation]    ตรวจสอบว่าสามารถปิดโปรแกรมได้ถูกต้อง
    [Tags]    เครื่องคิดเลข    ปิดโปรแกรม
    Sleep    1.0s

    # ปิดโปรแกรมเครื่องคิดเลขโดยคลิกปุ่มปิด
    Switch To Standard Mode

    FlaUILibrary.Focus    ${xpath_calculator_window}
    Sleep    1.0s